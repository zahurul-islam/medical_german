/// Vocabulary flashcard screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  final String sectionId;

  const VocabularyScreen({super.key, required this.sectionId});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  int _currentIndex = 0;
  bool _showTranslation = false;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard(List<VocabularyModel> vocabulary) {
    if (_currentIndex < vocabulary.length - 1) {
      setState(() {
        _currentIndex++;
        _showTranslation = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showTranslation = false;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocabAsync = ref.watch(vocabularyProvider(widget.sectionId));
    final userLanguage = ref.watch(userLanguageProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final secondaryColor = isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: vocabAsync.when(
        data: (vocabulary) {
          if (vocabulary.isEmpty) {
            return const Center(child: Text('No vocabulary available'));
          }

          return Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currentIndex + 1}',
                      style: AppTextStyles.heading3(color: AppColors.primary),
                    ),
                    Text(
                      ' / ${vocabulary.length}',
                      style: AppTextStyles.bodyLarge(color: secondaryColor),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / vocabulary.length,
                backgroundColor: dividerColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 24),

              // Flashcard
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vocabulary.length,
                  itemBuilder: (context, index) {
                    final vocab = vocabulary[index];
                    return _Flashcard(
                      vocab: vocab,
                      language: userLanguage,
                      showTranslation: _showTranslation && index == _currentIndex,
                      onTap: () {
                        setState(() => _showTranslation = !_showTranslation);
                      },
                    );
                  },
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousCard : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex < vocabulary.length - 1
                            ? () => _nextCard(vocabulary)
                            : () => context.pop(),
                        icon: Icon(_currentIndex < vocabulary.length - 1
                            ? Icons.arrow_forward
                            : Icons.check),
                        label: Text(_currentIndex < vocabulary.length - 1
                            ? 'Next'
                            : 'Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Error loading vocabulary', style: TextStyle(color: textColor))),
      ),
    );
  }
}

class _Flashcard extends StatelessWidget {
  final VocabularyModel vocab;
  final String language;
  final bool showTranslation;
  final VoidCallback onTap;

  const _Flashcard({
    required this.vocab,
    required this.language,
    required this.showTranslation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Container(
            key: ValueKey(showTranslation),
            decoration: BoxDecoration(
              gradient: showTranslation
                  ? AppColors.secondaryGradient
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (showTranslation ? AppColors.secondary : AppColors.primary)
                      .withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!showTranslation) ...[
                      // German side
                      if (vocab.article.isNotEmpty)
                        Text(
                          vocab.article,
                          style: AppTextStyles.bodyLarge(color: Colors.white70),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        vocab.germanTerm,
                        style: AppTextStyles.heading1(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      if (vocab.pronunciation.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          vocab.pronunciation,
                          style: AppTextStyles.bodyLarge(color: Colors.white70),
                        ),
                      ],
                      if (vocab.plural.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Plural: ${vocab.plural}',
                          style: AppTextStyles.bodyMedium(color: Colors.white60),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tap to see translation',
                          style: AppTextStyles.bodySmall(color: Colors.white),
                        ),
                      ),
                    ] else ...[
                      // Translation side
                      Text(
                        vocab.getTranslation(language),
                        style: AppTextStyles.heading2(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      if (vocab.exampleSentence.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                vocab.exampleSentence,
                                style: AppTextStyles.germanPhrase(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                vocab.getExampleTranslation(language),
                                style: AppTextStyles.bodySmall(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tap to see German',
                          style: AppTextStyles.bodySmall(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
