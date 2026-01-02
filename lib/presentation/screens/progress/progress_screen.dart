/// Progress screen showing user learning statistics
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);
    final recentAsync = ref.watch(recentSectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall progress card
            statsAsync.when(
              data: (stats) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 60,
                      lineWidth: 10,
                      percent: stats?.overallProgress ?? 0,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${((stats?.overallProgress ?? 0) * 100).toInt()}%',
                            style: AppTextStyles.heading3(color: Colors.white),
                          ),
                          Text(
                            'Complete',
                            style: AppTextStyles.bodySmall(color: Colors.white70),
                          ),
                        ],
                      ),
                      progressColor: AppColors.accent,
                      backgroundColor: Colors.white24,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level ${stats?.currentLevel ?? "A1"}',
                            style: AppTextStyles.heading2(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${stats?.totalSectionsCompleted ?? 0} of ${stats?.totalSections ?? 55} sections',
                            style: AppTextStyles.bodyMedium(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${stats?.totalPoints ?? 0} points earned',
                            style: AppTextStyles.bodyMedium(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 24),

            // Stats grid
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  _StatCard(
                    icon: Icons.local_fire_department,
                    iconColor: AppColors.accent,
                    value: '${stats?.streak ?? 0}',
                    label: 'Day Streak',
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.timer_outlined,
                    iconColor: AppColors.secondary,
                    value: '${stats?.totalMinutesLearned ?? 0}',
                    label: 'Minutes',
                  ),
                ],
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 32),

            // Level progress
            Text('Level Progress', style: AppTextStyles.heading4()),
            const SizedBox(height: 16),
            _LevelProgressBar(level: 'A1', progress: 1.0, color: AppColors.levelA1),
            const SizedBox(height: 12),
            _LevelProgressBar(level: 'A2', progress: 0.7, color: AppColors.levelA2),
            const SizedBox(height: 12),
            _LevelProgressBar(level: 'B1', progress: 0.3, color: AppColors.levelB1),
            const SizedBox(height: 12),
            _LevelProgressBar(level: 'B2', progress: 0.0, color: AppColors.levelB2),
            const SizedBox(height: 12),
            _LevelProgressBar(level: 'C1', progress: 0.0, color: AppColors.levelC1),
            const SizedBox(height: 32),

            // Recent activity
            Text('Recent Activity', style: AppTextStyles.heading4()),
            const SizedBox(height: 16),
            recentAsync.when(
              data: (recent) {
                if (recent.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Start learning to see your activity here!',
                        style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                      ),
                    ),
                  );
                }
                return Column(
                  children: recent.map((progress) {
                    return _RecentActivityCard(
                      sectionId: progress.sectionId,
                      percentComplete: progress.percentComplete,
                      lastAccessed: progress.lastAccessedAt,
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ],
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

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
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
              color: Colors.black.withOpacity(0.05),
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
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.heading4()),
                Text(label, style: AppTextStyles.bodySmall()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  final String level;
  final double progress;
  final Color color;

  const _LevelProgressBar({
    required this.level,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              level,
              style: AppTextStyles.labelMedium(color: color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.dividerLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(progress * 100).toInt()}%',
          style: AppTextStyles.bodySmall(),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final String sectionId;
  final double percentComplete;
  final DateTime lastAccessed;

  const _RecentActivityCard({
    required this.sectionId,
    required this.percentComplete,
    required this.lastAccessed,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inMinutes}m ago';
    }
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.book, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Section ${sectionId.substring(0, 8)}...',
                  style: AppTextStyles.bodyMedium(),
                ),
                Text(
                  _formatDate(lastAccessed),
                  style: AppTextStyles.bodySmall(),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 20,
            lineWidth: 4,
            percent: percentComplete / 100,
            center: Text(
              '${percentComplete.toInt()}%',
              style: AppTextStyles.labelSmall(),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.dividerLight,
          ),
        ],
      ),
    );
  }
}
