/// Mock Test Screen for FSP and KP exams
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/mock_test_model.dart';
import '../../providers/providers.dart';

class MockTestScreen extends ConsumerStatefulWidget {
  final String testId;

  const MockTestScreen({super.key, required this.testId});

  @override
  ConsumerState<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends ConsumerState<MockTestScreen> {
  int _currentQuestionIndex = 0;
  Map<String, String> _answers = {};
  bool _showResults = false;
  bool _isLoading = true;
  MockTestModel? _mockTest;

  @override
  void initState() {
    super.initState();
    _loadMockTest();
  }

  Future<void> _loadMockTest() async {
    final contentRepo = ref.read(contentRepositoryProvider);
    final test = await contentRepo.getMockTest(widget.testId);
    setState(() {
      _mockTest = test;
      _isLoading = false;
    });
  }

  void _selectAnswer(String questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < (_mockTest?.questions.length ?? 1) - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitTest() async {
    final score = _calculateScore();
    final points = score * 10; // 10 points per correct answer
    
    // Add points to user's total
    final authState = ref.read(authStateProvider);
    final progressRepo = ref.read(progressRepositoryProvider);
    
    authState.whenData((user) async {
      if (user != null) {
        await progressRepo.addPoints(user.uid, points);
      }
    });
    
    // Refresh stats
    ref.invalidate(userStatsProvider);
    
    setState(() {
      _showResults = true;
    });
  }

  int _calculateScore() {
    if (_mockTest == null) return 0;
    int correct = 0;
    for (final question in _mockTest!.questions) {
      if (_answers[question.id] == question.correctAnswer) {
        correct++;
      }
    }
    return correct;
  }

  double _calculatePercentage() {
    if (_mockTest == null || _mockTest!.questions.isEmpty) return 0;
    return (_calculateScore() / _mockTest!.questions.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final userLanguage = ref.watch(userLanguageProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...', style: TextStyle(color: textColor))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_mockTest == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mock Test', style: TextStyle(color: textColor)),
          leading: IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: isDarkMode ? Colors.white54 : Colors.grey),
              const SizedBox(height: 16),
              Text('Test not found', style: AppTextStyles.heading4(isDark: isDarkMode)),
            ],
          ),
        ),
      );
    }

    if (_showResults) {
      return _buildResultsScreen(isDarkMode, textColor, userLanguage);
    }

    return _buildQuestionScreen(isDarkMode, textColor, userLanguage);
  }

  Widget _buildQuestionScreen(bool isDarkMode, Color textColor, String userLanguage) {
    final question = _mockTest!.questions[_currentQuestionIndex];
    final selectedAnswer = _answers[question.id];
    final progress = (_currentQuestionIndex + 1) / _mockTest!.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _mockTest!.typeShortName,
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Test beenden?'),
                content: const Text('Ihr Fortschritt geht verloren.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Beenden'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${_mockTest!.questions.length}',
                style: AppTextStyles.bodyMedium(isDark: isDarkMode),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: isDarkMode ? Colors.white24 : Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question number badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Frage ${_currentQuestionIndex + 1}',
                      style: AppTextStyles.bodySmall(
                        color: _mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Question text - Always in German
                  Text(
                    question.getQuestion('de'),
                    style: AppTextStyles.heading3(isDark: isDarkMode),
                  ),
                  const SizedBox(height: 24),
                  // Options
                  if (question.options != null)
                    ...question.options!.map((option) {
                      final isSelected = selectedAnswer == option;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _selectAnswer(question.id, option),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary).withOpacity(0.1)
                                  : isDarkMode ? Colors.white10 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary)
                                    : isDarkMode ? Colors.white24 : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary)
                                          : isDarkMode ? Colors.white54 : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: AppTextStyles.bodyLarge(
                                      isDark: isDarkMode,
                                      color: isSelected
                                          ? (_mockTest!.type == MockTestType.fsp ? AppColors.primary : AppColors.secondary)
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Zurück'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: selectedAnswer != null
                        ? (_currentQuestionIndex == _mockTest!.questions.length - 1
                            ? _submitTest
                            : _nextQuestion)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _mockTest!.type == MockTestType.fsp
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                    child: Text(
                      _currentQuestionIndex == _mockTest!.questions.length - 1
                          ? 'Abschicken'
                          : 'Weiter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(bool isDarkMode, Color textColor, String userLanguage) {
    final score = _calculateScore();
    final percentage = _calculatePercentage();
    final passed = percentage >= _mockTest!.passingScore;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ergebnis', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Result summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.red.shade400, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    passed ? Icons.check_circle : Icons.cancel,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    passed ? 'Herzlichen Glückwunsch!' : 'Weiter üben!',
                    style: AppTextStyles.heading2(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passed
                        ? 'Sie haben die ${_mockTest!.typeShortName} Probeprüfung bestanden'
                        : 'Sie benötigen ${_mockTest!.passingScore}% zum Bestehen',
                    style: AppTextStyles.bodyMedium(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ResultStat(
                        label: 'Punkte',
                        value: '$score/${_mockTest!.questions.length}',
                      ),
                      const SizedBox(width: 32),
                      _ResultStat(
                        label: 'Prozent',
                        value: '${percentage.toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Question review
            Text(
              'Antworten überprüfen',
              style: AppTextStyles.heading4(isDark: isDarkMode),
            ),
            const SizedBox(height: 16),
            ...List.generate(_mockTest!.questions.length, (index) {
              final question = _mockTest!.questions[index];
              final userAnswer = _answers[question.id];
              final isCorrect = userAnswer == question.correctAnswer;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white10 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Frage ${index + 1}',
                          style: AppTextStyles.bodyMedium(
                            isDark: isDarkMode,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.getQuestion('de'),
                      style: AppTextStyles.bodyMedium(isDark: isDarkMode),
                    ),
                    const SizedBox(height: 8),
                    if (userAnswer != null)
                      Text(
                        'Ihre Antwort: $userAnswer',
                        style: AppTextStyles.bodySmall(
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Richtige Antwort: ${question.correctAnswer}',
                        style: AppTextStyles.bodySmall(color: Colors.green),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        question.getExplanation('de'),
                        style: AppTextStyles.bodySmall(isDark: isDarkMode),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zurück zum Lernen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;

  const _ResultStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall(color: Colors.white70),
        ),
      ],
    );
  }
}

