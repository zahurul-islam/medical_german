/// Lesson screen with tabs for text, audio, and video content
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';

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
            if (section.textContent!.learningObjectives.isNotEmpty) ...[
              Text(
                l10n.learningObjectives,
                style: AppTextStyles.heading4(),
              ),
              const SizedBox(height: 12),
              ...section.textContent!.learningObjectives.map(
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

            // Grammar Focus
            _ContentSection(
              title: l10n.grammarFocus,
              content: section.textContent!.getGrammarFocus(language),
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

  const _ContentSection({
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
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

class _VocabularyCard extends StatelessWidget {
  final VocabularyModel vocab;
  final String language;

  const _VocabularyCard({required this.vocab, required this.language});

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
                      vocab.fullGermanTerm,
                      style: AppTextStyles.germanWord(),
                    ),
                    if (vocab.pronunciation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        vocab.pronunciation,
                        style: AppTextStyles.pronunciation(),
                      ),
                    ],
                  ],
                ),
              ),
              if (vocab.audioUrl.isNotEmpty)
                IconButton(
                  onPressed: () {
                    // TODO: Play audio
                  },
                  icon: const Icon(Icons.volume_up),
                  color: AppColors.primary,
                ),
            ],
          ),
          const Divider(height: 24),
          Text(
            vocab.getTranslation(language),
            style: AppTextStyles.bodyLarge(),
          ),
          if (vocab.exampleSentence.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vocab.exampleSentence,
                    style: AppTextStyles.germanPhrase().copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vocab.getExampleTranslation(language),
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

class _DialogueCard extends StatelessWidget {
  final DialogueModel dialogue;
  final String language;

  const _DialogueCard({required this.dialogue, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.secondary.withOpacity(0.1),
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
                        dialogue.getTitle(language),
                        style: AppTextStyles.heading4(),
                      ),
                      Text(
                        dialogue.getContext(language),
                        style: AppTextStyles.bodySmall(),
                      ),
                    ],
                  ),
                ),
                if (dialogue.audioUrl.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      // TODO: Play dialogue audio
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    color: AppColors.secondary,
                    iconSize: 32,
                  ),
              ],
            ),
          ),
          
          // Dialogue lines
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: dialogue.lines.map((line) {
                final isDoctor = line.speaker.toLowerCase().contains('doctor') ||
                    line.speaker.toLowerCase().contains('arzt');
                return _DialogueLine(line: line, language: language, isDoctor: isDoctor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogueLine extends StatelessWidget {
  final DialogueLine line;
  final String language;
  final bool isDoctor;

  const _DialogueLine({
    required this.line,
    required this.language,
    required this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDoctor ? AppColors.primary : AppColors.secondary,
            child: Icon(
              isDoctor ? Icons.medical_services : Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.speaker,
                  style: AppTextStyles.labelMedium(
                    color: isDoctor ? AppColors.primary : AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  line.germanText,
                  style: AppTextStyles.germanPhrase().copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  line.getTranslation(language),
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
