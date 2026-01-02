/// Section list screen showing sections within a phase
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class SectionListScreen extends ConsumerWidget {
  final String phaseId;

  const SectionListScreen({super.key, required this.phaseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(sectionsByPhaseProvider(phaseId));
    final userLanguage = ref.watch(userLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/phases'),
        ),
      ),
      body: sectionsAsync.when(
        data: (sections) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            final progressAsync = ref.watch(sectionProgressProvider(section.id));

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SectionCard(
                number: index + 1,
                title: section.getTitle(userLanguage),
                titleDe: section.titleDe,
                level: section.level,
                estimatedMinutes: section.estimatedMinutes,
                progress: progressAsync.when(
                  data: (p) => p?.percentComplete ?? 0,
                  loading: () => 0,
                  error: (_, __) => 0,
                ),
                isCompleted: progressAsync.when(
                  data: (p) => p?.completed ?? false,
                  loading: () => false,
                  error: (_, __) => false,
                ),
                onTap: () => context.go('/section/${section.id}'),
              ),
            );
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error loading sections', style: AppTextStyles.heading4()),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(sectionsByPhaseProvider(phaseId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final int number;
  final String title;
  final String titleDe;
  final String level;
  final int estimatedMinutes;
  final double progress;
  final bool isCompleted;
  final VoidCallback onTap;

  const _SectionCard({
    required this.number,
    required this.title,
    required this.titleDe,
    required this.level,
    required this.estimatedMinutes,
    required this.progress,
    required this.isCompleted,
    required this.onTap,
  });

  Color get _levelColor {
    switch (level) {
      case 'A1':
        return AppColors.levelA1;
      case 'A2':
        return AppColors.levelA2;
      case 'B1':
        return AppColors.levelB1;
      case 'B2':
        return AppColors.levelB2;
      case 'C1':
        return AppColors.levelC1;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isCompleted
              ? Border.all(color: AppColors.success, width: 2)
              : null,
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
            // Section number
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withOpacity(0.1)
                    : _levelColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: AppColors.success)
                    : Text(
                        '$number',
                        style: AppTextStyles.heading4(color: _levelColor),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _levelColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          level,
                          style: AppTextStyles.labelSmall(color: _levelColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: AppColors.textHintLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$estimatedMinutes min',
                        style: AppTextStyles.labelSmall(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titleDe,
                    style: AppTextStyles.germanPhrase().copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 12),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 6,
                      percent: progress / 100,
                      backgroundColor: AppColors.dividerLight,
                      progressColor: isCompleted ? AppColors.success : _levelColor,
                      barRadius: const Radius.circular(3),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textHintLight),
          ],
        ),
      ),
    );
  }
}
