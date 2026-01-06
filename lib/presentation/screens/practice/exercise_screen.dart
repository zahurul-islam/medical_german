/// Exercise screen for practice questions
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final String sectionId;

  const ExerciseScreen({super.key, required this.sectionId});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctCount = 0;
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer(ExerciseModel exercise) {
    setState(() {
      _showResult = true;
      if (exercise.type == ExerciseType.multipleChoice) {
        if (_selectedAnswer == exercise.correctAnswer) {
          _correctCount++;
        }
      } else {
        if (_answerController.text.toLowerCase().trim() ==
            exercise.correctAnswer.toLowerCase().trim()) {
          _correctCount++;
        }
      }
    });
  }

  void _nextQuestion(List<ExerciseModel> exercises) {
    if (_currentIndex < exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
        _answerController.clear();
      });
    } else {
      _showResults(exercises.length);
    }
  }

  void _showResults(int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _correctCount >= total * 0.7
                  ? Icons.emoji_events
                  : Icons.school,
              size: 64,
              color: _correctCount >= total * 0.7
                  ? AppColors.accent
                  : AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _correctCount >= total * 0.7 ? 'Great Job!' : 'Keep Practicing!',
              style: AppTextStyles.heading3(),
            ),
            const SizedBox(height: 8),
            Text(
              'You got $_correctCount out of $total correct',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 8),
            Text(
              '${((_correctCount / total) * 100).toInt()}%',
              style: AppTextStyles.heading2(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _selectedAnswer = null;
                _showResult = false;
                _correctCount = 0;
                _answerController.clear();
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider(widget.sectionId));
    final userLanguage = ref.watch(userLanguageProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final secondaryColor = isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: exercisesAsync.when(
        data: (exercises) {
          if (exercises.isEmpty) {
            return const Center(child: Text('No exercises available'));
          }

          final exercise = exercises[_currentIndex];

          return Column(
            children: [
              // Progress
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Question ${_currentIndex + 1}/${exercises.length}',
                      style: AppTextStyles.bodyMedium(color: secondaryColor),
                    ),
                    const Spacer(),
                    Text(
                      '$_correctCount correct',
                      style: AppTextStyles.bodyMedium(color: AppColors.success),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / exercises.length,
                backgroundColor: dividerColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),

              // Question content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(isDarkMode ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getExerciseIcon(exercise.type),
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _getExerciseTypeName(exercise.type),
                                  style: AppTextStyles.labelMedium(color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              exercise.getQuestion(userLanguage),
                              style: AppTextStyles.heading4(isDark: isDarkMode),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Answer options
                      if (exercise.type == ExerciseType.multipleChoice &&
                          exercise.options != null)
                        ...exercise.options!.map((option) {
                          final isCorrect = option == exercise.correctAnswer;
                          final isSelected = option == _selectedAnswer;
                          Color? backgroundColor;
                          Color? borderColor;

                          if (_showResult) {
                            if (isCorrect) {
                              backgroundColor = AppColors.success.withOpacity(0.1);
                              borderColor = AppColors.success;
                            } else if (isSelected && !isCorrect) {
                              backgroundColor = AppColors.error.withOpacity(0.1);
                              borderColor = AppColors.error;
                            }
                          } else if (isSelected) {
                            backgroundColor = AppColors.primary.withOpacity(0.1);
                            borderColor = AppColors.primary;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: _showResult
                                  ? null
                                  : () {
                                      setState(() => _selectedAnswer = option);
                                    },
                                child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: backgroundColor ?? (isDarkMode ? Colors.grey[800] : null),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: borderColor ?? dividerColor,
                                    width: isSelected || (_showResult && isCorrect) ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: AppTextStyles.bodyLarge(isDark: isDarkMode),
                                      ),
                                    ),
                                    if (_showResult && isCorrect)
                                      const Icon(Icons.check_circle, color: AppColors.success),
                                    if (_showResult && isSelected && !isCorrect)
                                      const Icon(Icons.cancel, color: AppColors.error),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      else if (exercise.type == ExerciseType.fillBlank ||
                          exercise.type == ExerciseType.translation)
                        TextField(
                          controller: _answerController,
                          enabled: !_showResult,
                          decoration: InputDecoration(
                            hintText: 'Type your answer...',
                            suffixIcon: _showResult
                                ? Icon(
                                    _answerController.text.toLowerCase().trim() ==
                                            exercise.correctAnswer.toLowerCase().trim()
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: _answerController.text.toLowerCase().trim() ==
                                            exercise.correctAnswer.toLowerCase().trim()
                                        ? AppColors.success
                                        : AppColors.error,
                                  )
                                : null,
                          ),
                        ),

                      // Result feedback
                      if (_showResult) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline, 
                                    color: AppColors.info, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Explanation',
                                    style: AppTextStyles.labelLarge(color: AppColors.info),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                exercise.getExplanation(userLanguage),
                                style: AppTextStyles.bodyMedium(isDark: isDarkMode),
                              ),
                              if (exercise.type != ExerciseType.multipleChoice) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Correct answer: ${exercise.correctAnswer}',
                                  style: AppTextStyles.bodyMedium(color: AppColors.success),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Action button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_showResult) {
                        if (_selectedAnswer != null || 
                            _answerController.text.isNotEmpty) {
                          _checkAnswer(exercise);
                        }
                      } else {
                        _nextQuestion(exercises);
                      }
                    },
                    child: Text(_showResult
                        ? (_currentIndex < exercises.length - 1 ? 'Next' : 'See Results')
                        : 'Check Answer'),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Error loading exercises', style: TextStyle(color: textColor))),
      ),
    );
  }

  IconData _getExerciseIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice:
        return Icons.radio_button_checked;
      case ExerciseType.fillBlank:
        return Icons.text_fields;
      case ExerciseType.translation:
        return Icons.translate;
      case ExerciseType.matching:
        return Icons.compare_arrows;
      case ExerciseType.listening:
        return Icons.headphones;
      case ExerciseType.ordering:
        return Icons.sort;
    }
  }

  String _getExerciseTypeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice:
        return 'Multiple Choice';
      case ExerciseType.fillBlank:
        return 'Fill in the Blank';
      case ExerciseType.translation:
        return 'Translation';
      case ExerciseType.matching:
        return 'Matching';
      case ExerciseType.listening:
        return 'Listening';
      case ExerciseType.ordering:
        return 'Ordering';
    }
  }
}
