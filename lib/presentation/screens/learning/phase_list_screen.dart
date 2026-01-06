/// Phase list screen showing all three learning phases
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class PhaseListScreen extends ConsumerWidget {
  const PhaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phasesProvider);
    final userLanguage = ref.watch(userLanguageProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Phases', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: phasesAsync.when(
        data: (phases) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: phases.length,
          itemBuilder: (context, index) {
            final phase = phases[index];
            final gradients = [
              AppColors.phase1Gradient,
              AppColors.phase2Gradient,
              AppColors.phase3Gradient,
            ];
            final icons = [
              Icons.foundation,
              Icons.medical_information,
              Icons.workspace_premium,
            ];

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _PhaseDetailCard(
                title: phase.getTitle(userLanguage),
                description: phase.getDescription(userLanguage),
                level: phase.level,
                sectionCount: phase.sectionCount,
                icon: icons[index % 3],
                gradient: gradients[index % 3],
                onTap: () => context.go('/phase/${phase.id}'),
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
              Text('Error loading phases', style: AppTextStyles.heading4(isDark: isDarkMode)),
              const SizedBox(height: 8),
              Text(error.toString(), style: AppTextStyles.bodySmall(isDark: isDarkMode)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(phasesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhaseDetailCard extends StatelessWidget {
  final String title;
  final String description;
  final String level;
  final int sectionCount;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _PhaseDetailCard({
    required this.title,
    required this.description,
    required this.level,
    required this.sectionCount,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            level,
                            style: AppTextStyles.levelBadge(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: AppTextStyles.heading3(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.book_outlined,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$sectionCount Sections',
                            style: AppTextStyles.bodyMedium(color: Colors.white70),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Start',
                              style: AppTextStyles.buttonMedium(
                                color: gradient.colors.first,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: gradient.colors.first,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
