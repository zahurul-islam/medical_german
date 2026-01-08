/// Home screen with dashboard and navigation
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/models/mock_test_model.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(userStatsProvider);
    final phasesAsync = ref.watch(phasesProvider);
    final userLanguage = ref.watch(userLanguageProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final secondaryColor = isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Willkommen zurück! 👋',
                        style: AppTextStyles.bodyMedium(color: secondaryColor),
                      ),
                      const SizedBox(height: 4),
                      userAsync.when(
                        data: (user) => Text(
                          user?.displayName ?? 'Doctor',
                          style: AppTextStyles.heading3(isDark: isDarkMode),
                        ),
                        loading: () => const SizedBox(
                          height: 24,
                          width: 100,
                          child: LinearProgressIndicator(),
                        ),
                        error: (_, __) => Text(
                          'Doctor',
                          style: AppTextStyles.heading3(isDark: isDarkMode),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/progress'),
                        icon: Icon(Icons.leaderboard_outlined, color: textColor),
                      ),
                      IconButton(
                        onPressed: () => context.go('/settings'),
                        icon: Icon(Icons.settings_outlined, color: textColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ihr Fortschritt',
                            style: AppTextStyles.bodyMedium(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          statsAsync.when(
                            data: (stats) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stufe ${stats?.currentLevel ?? "A1"}',
                                  style: AppTextStyles.heading2(color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${stats?.totalSectionsCompleted ?? 0}/55 Lektionen abgeschlossen',
                                  style: AppTextStyles.bodySmall(color: Colors.white70),
                                ),
                              ],
                            ),
                            loading: () => const SizedBox(
                              height: 60,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                            error: (_, __) => Text(
                              'Level A1',
                              style: AppTextStyles.heading2(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.push('/phases'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text('Weiterlernen'),
                          ),
                        ],
                      ),
                    ),
                    statsAsync.when(
                      data: (stats) => CircularPercentIndicator(
                        radius: 50,
                        lineWidth: 8,
                        percent: stats?.overallProgress ?? 0,
                        center: Text(
                          '${((stats?.overallProgress ?? 0) * 100).toInt()}%',
                          style: AppTextStyles.heading4(color: Colors.white),
                        ),
                        progressColor: AppColors.accent,
                        backgroundColor: Colors.white24,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      loading: () => const SizedBox(width: 100),
                      error: (_, __) => const SizedBox(width: 100),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick stats row
              statsAsync.when(
                data: (stats) => Row(
                  children: [
                    _StatCard(
                      icon: Icons.local_fire_department,
                      iconColor: AppColors.accent,
                      value: '${stats?.streak ?? 0}',
                      label: 'Tage Serie',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      icon: Icons.star,
                      iconColor: AppColors.secondary,
                      value: '${stats?.totalPoints ?? 0}',
                      label: 'Punkte',
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                loading: () => const SizedBox(height: 80),
                error: (_, __) => const SizedBox(height: 80),
              ),
              const SizedBox(height: 32),

              // Learning Phases
              Text(
                'Lernphasen',
                style: AppTextStyles.heading4(isDark: isDarkMode),
              ),
              const SizedBox(height: 16),

              phasesAsync.when(
                data: (phases) => Column(
                  children: phases.expand((phase) {
                    final gradients = [
                      AppColors.phase1Gradient,
                      AppColors.phase2Gradient,
                      AppColors.phase3Gradient,
                    ];
                    final gradient = gradients[(phase.order - 1) % 3];

                    return [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PhaseCard(
                          title: phase.getTitle(userLanguage),
                          titleDe: phase.title['de'] ?? '',
                          level: phase.level,
                          sectionCount: phase.sectionCount,
                          gradient: gradient,
                          onTap: () => context.push('/phase/${phase.id}'),
                        ),
                      ),
                      // Mock Tests card after each phase
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _MockTestsCard(
                          phaseId: phase.id,
                          level: phase.level,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ];
                  }).toList(),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Center(
                  child: Text('Error loading phases: $e', style: TextStyle(color: textColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDarkMode;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.heading4(isDark: isDarkMode)),
                Text(label, style: AppTextStyles.bodySmall(isDark: isDarkMode)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final String title;
  final String titleDe;
  final String level;
  final int sectionCount;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _PhaseCard({
    required this.title,
    required this.titleDe,
    required this.level,
    required this.sectionCount,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      level,
                      style: AppTextStyles.levelBadge(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: AppTextStyles.heading4(color: Colors.white),
                  ),
                  if (titleDe.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      titleDe,
                      style: AppTextStyles.bodySmall(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '$sectionCount Lektionen',
                    style: AppTextStyles.bodySmall(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _MockTestsCard extends StatelessWidget {
  final String phaseId;
  final String level;
  final bool isDarkMode;

  const _MockTestsCard({
    required this.phaseId,
    required this.level,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white24 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.quiz,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$level Mock Tests',
                      style: AppTextStyles.bodyLarge(isDark: isDarkMode),
                    ),
                    Text(
                      'FSP & KP Prüfungsvorbereitung',
                      style: AppTextStyles.bodySmall(isDark: isDarkMode),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MockTestButton(
                  title: 'FSP',
                  subtitle: 'Fachsprachprüfung',
                  type: MockTestType.fsp,
                  testId: '${phaseId}_fsp',
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MockTestButton(
                  title: 'KP',
                  subtitle: 'Kenntnisprüfung',
                  type: MockTestType.kp,
                  testId: '${phaseId}_kp',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockTestButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final MockTestType type;
  final String testId;
  final bool isDarkMode;

  const _MockTestButton({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.testId,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == MockTestType.fsp ? AppColors.primary : AppColors.secondary;
    
    return InkWell(
      onTap: () => context.push('/mock-test/$testId'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge(color: Colors.white),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

