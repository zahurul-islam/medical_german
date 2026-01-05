/// Lesson screen with tabs for text, audio, and video content
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';

// Global audio service instance
final _audioService = AudioService();

class LessonScreen extends ConsumerStatefulWidget {
  final String sectionId;

  const LessonScreen({super.key, required this.sectionId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionAsync = ref.watch(sectionProvider(widget.sectionId));
    final userLanguage = ref.watch(userLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/phases');
            }
          },
        ),
        title: sectionAsync.when(
          data: (section) => Text(section?.titleDe ?? 'Lesson'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Lesson'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.article_outlined), text: 'Text'),
            Tab(icon: Icon(Icons.translate), text: 'Vocab'),
            Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Dialogue'),
            Tab(icon: Icon(Icons.quiz_outlined), text: 'Practice'),
          ],
        ),
      ),
      body: sectionAsync.when(
        data: (section) {
          if (section == null) {
            return const Center(child: Text('Section not found'));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _TextContentTab(section: section, language: userLanguage),
              _VocabularyTab(sectionId: widget.sectionId, language: userLanguage),
              _DialogueTab(sectionId: widget.sectionId, language: userLanguage),
              _ExerciseTab(sectionId: widget.sectionId),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error loading lesson', style: AppTextStyles.heading4()),
              const SizedBox(height: 8),
              Text(error.toString(), style: AppTextStyles.bodySmall()),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextContentTab extends StatelessWidget {
  final SectionModel section;
  final String language;

  const _TextContentTab({required this.section, required this.language});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.book, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.titleDe,
                        style: AppTextStyles.heading4(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        section.getTitle(language),
                        style: AppTextStyles.bodyMedium(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Introduction
          if (section.textContent != null) ...[
            _ContentSection(
              title: l10n.introduction,
              content: section.textContent!.getIntroduction(language),
            ),
            const SizedBox(height: 24),

            // Learning Objectives
            if (section.textContent!.getLearningObjectives(language).isNotEmpty) ...[
              Text(
                l10n.learningObjectives,
                style: AppTextStyles.heading4(),
              ),
              const SizedBox(height: 12),
              ...section.textContent!.getLearningObjectives(language).map(
                (objective) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                        color: AppColors.success, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(objective, style: AppTextStyles.bodyMedium()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Grammar Focus - uses markdown rendering
            _ContentSection(
              title: l10n.grammarFocus,
              content: section.textContent!.getGrammarFocus(language),
              useMarkdown: true,
            ),
            const SizedBox(height: 24),

            // Cultural Notes
            _ContentSection(
              title: l10n.culturalNotes,
              content: section.textContent!.getCulturalNotes(language),
              icon: Icons.lightbulb_outline,
              iconColor: AppColors.accent,
            ),
            const SizedBox(height: 24),

            // Summary
            _ContentSection(
              title: l10n.summary,
              content: section.textContent!.getSummary(language),
            ),
          ] else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.article_outlined,
                      size: 64, color: AppColors.textHintLight),
                    const SizedBox(height: 16),
                    Text(
                      l10n.comingSoon,
                      style: AppTextStyles.bodyLarge(color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;
  final bool useMarkdown;

  const _ContentSection({
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.useMarkdown = false,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
              const SizedBox(width: 8),
            ],
            Text(title, style: AppTextStyles.heading4()),
          ],
        ),
        const SizedBox(height: 12),
        if (useMarkdown)
          MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium(),
              h1: AppTextStyles.heading2(),
              h2: AppTextStyles.heading3(),
              h3: AppTextStyles.heading4(),
              strong: AppTextStyles.bodyMedium().copyWith(fontWeight: FontWeight.bold),
              em: AppTextStyles.bodyMedium().copyWith(fontStyle: FontStyle.italic),
              listBullet: AppTextStyles.bodyMedium(),
              tableHead: AppTextStyles.labelMedium().copyWith(fontWeight: FontWeight.bold),
              tableBody: AppTextStyles.bodySmall(),
              tableBorder: TableBorder.all(color: AppColors.dividerLight, width: 1),
              tableColumnWidth: const IntrinsicColumnWidth(),
              tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              blockquote: AppTextStyles.bodyMedium().copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondaryLight,
              ),
              code: AppTextStyles.bodySmall().copyWith(
                fontFamily: 'monospace',
                backgroundColor: AppColors.surfaceLight,
              ),
            ),
          )
        else
          Text(
            content,
            style: AppTextStyles.bodyMedium(),
          ),
      ],
    );
  }
}

class _VocabularyTab extends ConsumerWidget {
  final String sectionId;
  final String language;

  const _VocabularyTab({required this.sectionId, required this.language});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vocabAsync = ref.watch(vocabularyProvider(sectionId));

    return vocabAsync.when(
      data: (vocabulary) {
        if (vocabulary.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.translate, size: 64, color: AppColors.textHintLight),
                const SizedBox(height: 16),
                Text(
                  l10n.comingSoon,
                  style: AppTextStyles.bodyLarge(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${vocabulary.length} ${l10n.vocabulary.toLowerCase()}',
                    style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/section/$sectionId/vocabulary');
                    },
                    icon: const Icon(Icons.style, size: 18),
                    label: Text(l10n.flashcards),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: vocabulary.length,
                itemBuilder: (context, index) {
                  final vocab = vocabulary[index];
                  return _VocabularyCard(vocab: vocab, language: language);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(l10n.error)),
    );
  }
}

class _VocabularyCard extends StatefulWidget {
  final VocabularyModel vocab;
  final String language;

  const _VocabularyCard({required this.vocab, required this.language});

  @override
  State<_VocabularyCard> createState() => _VocabularyCardState();
}

class _VocabularyCardState extends State<_VocabularyCard> {
  bool _isPlaying = false;

  void _playAudio() async {
    if (widget.vocab.audioUrl.isEmpty) return;
    
    setState(() => _isPlaying = true);
    await _audioService.playAudio(widget.vocab.audioUrl);
    
    // Reset playing state after a delay (audio typically short)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vocab.fullGermanTerm,
                      style: AppTextStyles.germanWord(),
                    ),
                    if (widget.vocab.pronunciation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.vocab.pronunciation,
                        style: AppTextStyles.pronunciation(),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.vocab.audioUrl.isNotEmpty)
                IconButton(
                  onPressed: _isPlaying ? null : _playAudio,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.volume_up_outlined),
                  color: _isPlaying ? AppColors.success : AppColors.primary,
                ),
            ],
          ),
          const Divider(height: 24),
          Text(
            widget.vocab.getTranslation(widget.language),
            style: AppTextStyles.bodyLarge(),
          ),
          if (widget.vocab.exampleSentence.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vocab.exampleSentence,
                    style: AppTextStyles.germanPhrase().copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.vocab.getExampleTranslation(widget.language),
                    style: AppTextStyles.bodySmall(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DialogueTab extends ConsumerWidget {
  final String sectionId;
  final String language;

  const _DialogueTab({required this.sectionId, required this.language});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dialoguesAsync = ref.watch(dialoguesProvider(sectionId));

    return dialoguesAsync.when(
      data: (dialogues) {
        if (dialogues.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textHintLight),
                const SizedBox(height: 16),
                Text(
                  l10n.comingSoon,
                  style: AppTextStyles.bodyLarge(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dialogues.length,
          itemBuilder: (context, index) {
            final dialogue = dialogues[index];
            return _DialogueCard(dialogue: dialogue, language: language);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(l10n.error)),
    );
  }
}

class _DialogueCard extends StatefulWidget {
  final DialogueModel dialogue;
  final String language;

  const _DialogueCard({required this.dialogue, required this.language});

  @override
  State<_DialogueCard> createState() => _DialogueCardState();
}

class _DialogueCardState extends State<_DialogueCard> {
  bool _isPlaying = false;

  void _playDialogueAudio() async {
    if (widget.dialogue.audioUrl.isEmpty) return;
    
    setState(() => _isPlaying = true);
    await _audioService.playAudio(widget.dialogue.audioUrl);
    
    // Reset after estimated duration
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.forum, color: AppColors.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dialogue.getTitle(widget.language),
                        style: AppTextStyles.heading4(),
                      ),
                      Text(
                        widget.dialogue.getContext(widget.language),
                        style: AppTextStyles.bodySmall(),
                      ),
                    ],
                  ),
                ),
                if (widget.dialogue.audioUrl.isNotEmpty)
                  IconButton(
                    onPressed: _isPlaying ? null : _playDialogueAudio,
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    color: _isPlaying ? AppColors.success : AppColors.secondary,
                    iconSize: 32,
                  ),
              ],
            ),
          ),
          
          // Dialogue lines
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: widget.dialogue.lines.map((line) {
                final isDoctor = line.speaker.toLowerCase().contains('doctor') ||
                    line.speaker.toLowerCase().contains('arzt');
                return _DialogueLine(line: line, language: widget.language, isDoctor: isDoctor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogueLine extends StatefulWidget {
  final DialogueLine line;
  final String language;
  final bool isDoctor;

  const _DialogueLine({
    required this.line,
    required this.language,
    required this.isDoctor,
  });

  @override
  State<_DialogueLine> createState() => _DialogueLineState();
}

class _DialogueLineState extends State<_DialogueLine> {
  bool _isPlaying = false;

  void _playLineAudio() async {
    final audioUrl = widget.line.audioUrl;
    if (audioUrl == null || audioUrl.isEmpty) return;
    
    setState(() => _isPlaying = true);
    await _audioService.playAudio(audioUrl);
    
    // Reset after estimated duration
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: widget.isDoctor ? AppColors.primary : AppColors.secondary,
            child: Icon(
              widget.isDoctor ? Icons.medical_services : Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.line.speaker,
                        style: AppTextStyles.labelMedium(
                          color: widget.isDoctor ? AppColors.primary : AppColors.secondary,
                        ),
                      ),
                    ),
                    if (widget.line.audioUrl != null && widget.line.audioUrl!.isNotEmpty)
                      GestureDetector(
                        onTap: _isPlaying ? null : _playLineAudio,
                        child: Icon(
                          _isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
                          size: 20,
                          color: _isPlaying ? AppColors.success : AppColors.textHintLight,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.line.germanText,
                  style: AppTextStyles.germanPhrase().copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.line.getTranslation(widget.language),
                  style: AppTextStyles.bodySmall(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTab extends ConsumerWidget {
  final String sectionId;

  const _ExerciseTab({required this.sectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final exercisesAsync = ref.watch(exercisesProvider(sectionId));

    return exercisesAsync.when(
      data: (exercises) {
        if (exercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_outlined, size: 64, color: AppColors.textHintLight),
                const SizedBox(height: 16),
                Text(
                  l10n.comingSoon,
                  style: AppTextStyles.bodyLarge(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.quiz,
                    size: 64,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${exercises.length} ${l10n.exercises}',
                  style: AppTextStyles.heading3(),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.practice,
                  style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/section/$sectionId/exercises');
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.startPractice),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(l10n.error)),
    );
  }
}
