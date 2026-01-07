/// Settings screen for app preferences
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/settings_strings.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userLanguage = ref.watch(userLanguageProvider);
    final userAsync = ref.watch(currentUserProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final offlineMode = ref.watch(offlineModeProvider);
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final strings = SettingsStrings(userLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings, style: TextStyle(color: textColor)),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile section
          userAsync.when(
            data: (user) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? Text(
                            (user?.displayName ?? 'U')[0].toUpperCase(),
                            style: AppTextStyles.heading3(color: Colors.white),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? strings.doctor,
                          style: AppTextStyles.heading4(isDark: isDarkMode),
                        ),
                        Text(
                          user?.email ?? '',
                          style: AppTextStyles.bodySmall(isDark: isDarkMode),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${strings.level} ${user?.currentLevel ?? "A1"}',
                            style: AppTextStyles.labelSmall(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 80),
            error: (_, __) => const SizedBox(height: 80),
          ),
          const SizedBox(height: 16),
          
          // Premium subscription card
          _PremiumCard(
            isPremium: ref.watch(isPremiumProvider),
            isDarkMode: isDarkMode,
            onTap: () => context.push('/subscription'),
            strings: strings,
          ),
          const SizedBox(height: 24),

          // Language section
          Text(strings.language, style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.language,
            title: strings.sourceLanguage,
            subtitle: _getLanguageName(userLanguage),
            onTap: () => _showLanguageDialog(context, ref, strings),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 24),

          // Appearance section
          Text(strings.appearance, style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: strings.darkMode,
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(isDarkModeProvider.notifier).setDarkMode(value);
              },
            ),
          ),
          const SizedBox(height: 24),

          // App section
          Text(strings.app, style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: strings.notifications,
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).setEnabled(value);
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.offline_bolt_outlined,
            title: strings.offlineMode,
            subtitle: strings.offlineModeSubtitle,
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: offlineMode,
              onChanged: (value) {
                ref.read(offlineModeProvider.notifier).setEnabled(value);
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(strings.offlineModeEnabled),
                    ),
                  );
                }
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: strings.downloads,
            subtitle: strings.manageOfflineContent,
            isDarkMode: isDarkMode,
            onTap: () => _showDownloadsDialog(context, strings),
          ),
          const SizedBox(height: 24),

          // Support section
          Text(strings.support, style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.help_outline,
            title: strings.helpAndFAQ,
            isDarkMode: isDarkMode,
            onTap: () => _showHelpFAQ(context, strings),
          ),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: strings.contactUs,
            subtitle: 'support@meddeutsch.app',
            isDarkMode: isDarkMode,
            onTap: () => _launchEmail(),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: strings.privacyPolicy,
            isDarkMode: isDarkMode,
            onTap: () => _showPrivacyPolicy(context, strings),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: strings.termsOfService,
            isDarkMode: isDarkMode,
            onTap: () => _showTermsOfService(context, strings),
          ),
          const SizedBox(height: 24),

          // Sign out
          _SettingsTile(
            icon: Icons.logout,
            title: strings.signOut,
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            isDarkMode: isDarkMode,
            onTap: () => _showSignOutDialog(context, ref, strings),
          ),
          const SizedBox(height: 24),

          // App version
          Center(
            child: Text(
              'MedDeutsch v1.0.0',
              style: AppTextStyles.bodySmall(
                color: isDarkMode ? AppColors.textHintDark : AppColors.textHintLight,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2026 MedDeutsch',
              style: AppTextStyles.labelSmall(
                color: isDarkMode ? AppColors.textHintDark : AppColors.textHintLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা (Bangla)';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'ur':
        return 'اردو (Urdu)';
      case 'tr':
        return 'Türkçe (Turkish)';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, SettingsStrings strings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              code: 'en',
              name: 'English',
              flag: '🇬🇧',
              onTap: () {
                ref.read(userLanguageProvider.notifier).setLanguage('en');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'bn',
              name: 'বাংলা (Bangla)',
              flag: '🇧🇩',
              onTap: () {
                ref.read(userLanguageProvider.notifier).setLanguage('bn');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'hi',
              name: 'हिंदी (Hindi)',
              flag: '🇮🇳',
              onTap: () {
                ref.read(userLanguageProvider.notifier).setLanguage('hi');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'ur',
              name: 'اردو (Urdu)',
              flag: '🇵🇰',
              onTap: () {
                ref.read(userLanguageProvider.notifier).setLanguage('ur');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'tr',
              name: 'Türkçe (Turkish)',
              flag: '🇹🇷',
              onTap: () {
                ref.read(userLanguageProvider.notifier).setLanguage('tr');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadsDialog(BuildContext context, SettingsStrings strings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.downloads),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.manageDownloads,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: Text(strings.learningContent),
              subtitle: Text(strings.allSectionsCached),
              trailing: const Icon(Icons.check_circle, color: AppColors.success),
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack, color: AppColors.secondary),
              title: Text(strings.audioFiles),
              subtitle: const Text('3045 files (125 MB)'),
              trailing: const Icon(Icons.check_circle, color: AppColors.success),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  void _showHelpFAQ(BuildContext context, SettingsStrings strings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Builder(
              builder: (ctx) {
                final isDarkMode = Theme.of(ctx).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                    )),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.help_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(strings.helpAndFAQ, style: AppTextStyles.heading4()),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _FAQItem(
                    question: strings.faqStartLearning,
                    answer: strings.faqStartLearningAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqOffline,
                    answer: strings.faqOfflineAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqChangeLanguage,
                    answer: strings.faqChangeLanguageAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqPhases,
                    answer: strings.faqPhasesAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqPractice,
                    answer: strings.faqPracticeAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqAudio,
                    answer: strings.faqAudioAnswer,
                  ),
                  _FAQItem(
                    question: strings.faqContact,
                    answer: strings.faqContactAnswer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@meddeutsch.app',
      query: 'subject=MedDeutsch App Support',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _showPrivacyPolicy(BuildContext context, SettingsStrings strings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Builder(
              builder: (ctx) {
                final isDarkMode = Theme.of(ctx).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                    )),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(strings.privacyPolicy, style: AppTextStyles.heading4()),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.lastUpdated, style: AppTextStyles.bodySmall()),
                    const SizedBox(height: 16),
                    Text(strings.infoWeCollect, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.privacyInfoWeCollectContent),
                    const SizedBox(height: 16),
                    Text(strings.howWeUseInfo, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.privacyHowWeUseContent),
                    const SizedBox(height: 16),
                    Text(strings.dataSecurity, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.privacyDataSecurityContent),
                    const SizedBox(height: 16),
                    Text(strings.contact, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.privacyContactContent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context, SettingsStrings strings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Builder(
              builder: (ctx) {
                final isDarkMode = Theme.of(ctx).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                    )),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(strings.termsOfService, style: AppTextStyles.heading4()),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.lastUpdated, style: AppTextStyles.bodySmall()),
                    const SizedBox(height: 16),
                    Text(strings.acceptanceOfTerms, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.termsAcceptanceContent),
                    const SizedBox(height: 16),
                    Text(strings.useOfService, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.termsUseOfServiceContent),
                    const SizedBox(height: 16),
                    Text(strings.userAccounts, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.termsUserAccountsContent),
                    const SizedBox(height: 16),
                    Text(strings.intellectualProperty, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.termsIntellectualPropertyContent),
                    const SizedBox(height: 16),
                    Text(strings.contactTerms, style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    Text(strings.termsContactContent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref, SettingsStrings strings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.signOut),
        content: Text(strings.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final authRepo = ref.read(authRepositoryProvider);
              await authRepo.signOut();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(strings.signOut),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool isDarkMode;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = titleColor ?? (isDarkMode ? Colors.white : AppColors.textPrimaryLight);
    final subtitleColor = isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(isDarkMode ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium(color: textColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodySmall(color: subtitleColor))
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, 
                  color: isDarkMode ? AppColors.textHintDark : AppColors.textHintLight)
              : null),
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String code;
  final String name;
  final String flag;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      onTap: onTap,
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.bodyMedium().copyWith(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: AppTextStyles.bodyMedium()),
        ),
      ],
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final bool isPremium;
  final bool isDarkMode;
  final VoidCallback onTap;
  final SettingsStrings strings;

  const _PremiumCard({
    required this.isPremium,
    required this.isDarkMode,
    required this.onTap,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isPremium
              ? const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isPremium ? const Color(0xFFFFD700) : AppColors.primary).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPremium ? Icons.workspace_premium : Icons.star,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPremium ? strings.premiumActive : strings.becomePremium,
                    style: AppTextStyles.heading4(color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPremium
                        ? strings.enjoyPremiumFeatures
                        : strings.unlockAllFeatures,
                    style: AppTextStyles.bodySmall(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Icon(
              isPremium ? Icons.check_circle : Icons.arrow_forward_ios,
              color: Colors.white,
              size: isPremium ? 28 : 20,
            ),
          ],
        ),
      ),
    );
  }
}
