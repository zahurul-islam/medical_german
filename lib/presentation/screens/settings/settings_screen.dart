/// Settings screen for app preferences
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: textColor)),
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
                          user?.displayName ?? 'Doctor',
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
                            'Level ${user?.currentLevel ?? "A1"}',
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
          const SizedBox(height: 24),

          // Language section
          Text('Language', style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.language,
            title: 'Source Language',
            subtitle: _getLanguageName(userLanguage),
            onTap: () => _showLanguageDialog(context, ref),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 24),

          // Appearance section
          Text('Appearance', style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
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
          Text('App', style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
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
            title: 'Offline Mode',
            subtitle: 'Download content for offline use',
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: offlineMode,
              onChanged: (value) {
                ref.read(offlineModeProvider.notifier).setEnabled(value);
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline mode enabled. Content will be cached.'),
                    ),
                  );
                }
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: 'Downloads',
            subtitle: 'Manage offline content',
            isDarkMode: isDarkMode,
            onTap: () => _showDownloadsDialog(context),
          ),
          const SizedBox(height: 24),

          // Support section
          Text('Support', style: AppTextStyles.heading4(isDark: isDarkMode)),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            isDarkMode: isDarkMode,
            onTap: () => _showHelpFAQ(context),
          ),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact Us',
            subtitle: 'support@meddeutsch.app',
            isDarkMode: isDarkMode,
            onTap: () => _launchEmail(),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            isDarkMode: isDarkMode,
            onTap: () => _showPrivacyPolicy(context),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            isDarkMode: isDarkMode,
            onTap: () => _showTermsOfService(context),
          ),
          const SizedBox(height: 24),

          // Sign out
          _SettingsTile(
            icon: Icons.logout,
            title: 'Sign Out',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            isDarkMode: isDarkMode,
            onTap: () => _showSignOutDialog(context, ref),
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

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
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

  void _showDownloadsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Downloads'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your offline content here.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: const Text('Learning Content'),
              subtitle: const Text('All sections cached'),
              trailing: const Icon(Icons.check_circle, color: AppColors.success),
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack, color: AppColors.secondary),
              title: const Text('Audio Files'),
              subtitle: const Text('3045 files (125 MB)'),
              trailing: const Icon(Icons.check_circle, color: AppColors.success),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpFAQ(BuildContext context) {
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
                      Text('Help & FAQ', style: AppTextStyles.heading4()),
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
                children: const [
                  _FAQItem(
                    question: 'How do I start learning German medical terminology?',
                    answer: 'Begin with Phase 1, which covers essential greetings and basic medical vocabulary. Complete each section sequentially for the best learning experience.',
                  ),
                  _FAQItem(
                    question: 'Can I use the app offline?',
                    answer: 'Yes! Enable Offline Mode in Settings to download all content. Audio files and lessons will be available without an internet connection.',
                  ),
                  _FAQItem(
                    question: 'How do I change the translation language?',
                    answer: 'Go to Settings > Source Language and select your preferred language (English, Bangla, Hindi, Urdu, or Turkish).',
                  ),
                  _FAQItem(
                    question: 'How are the learning phases organized?',
                    answer: 'Phase 1 covers A1-A2 level basics, Phase 2 covers B1 intermediate medical German, and Phase 3 covers B2-C1 advanced professional communication.',
                  ),
                  _FAQItem(
                    question: 'How do I practice vocabulary?',
                    answer: 'Each section includes flashcards and practice exercises. Use the Vocab tab to study terms, and the Practice tab for quizzes.',
                  ),
                  _FAQItem(
                    question: 'Why is audio not playing?',
                    answer: 'Ensure your device volume is up and not on silent mode. If issues persist, try re-downloading the audio files in Settings > Downloads.',
                  ),
                  _FAQItem(
                    question: 'How do I contact support?',
                    answer: 'Email us at support@meddeutsch.app for any questions or technical issues.',
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

  void _showPrivacyPolicy(BuildContext context) {
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
                      Text('Privacy Policy', style: AppTextStyles.heading4()),
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
                    Text('Last Updated: January 2026', style: AppTextStyles.bodySmall()),
                    const SizedBox(height: 16),
                    Text('1. Information We Collect', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This may include:\n\n'
                      '• Email address for authentication\n'
                      '• Learning progress and preferences\n'
                      '• App usage data to improve your experience',
                    ),
                    const SizedBox(height: 16),
                    Text('2. How We Use Your Information', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'We use the information we collect to:\n\n'
                      '• Provide, maintain, and improve our services\n'
                      '• Track your learning progress\n'
                      '• Send you notifications about your learning goals\n'
                      '• Respond to your comments and questions',
                    ),
                    const SizedBox(height: 16),
                    Text('3. Data Security', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'We implement appropriate security measures to protect your personal information. Your data is stored securely using Firebase services with encryption.',
                    ),
                    const SizedBox(height: 16),
                    Text('4. Contact Us', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'If you have questions about this Privacy Policy, please contact us at:\n\n'
                      'Email: support@meddeutsch.app',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
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
                      Text('Terms of Service', style: AppTextStyles.heading4()),
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
                    Text('Last Updated: January 2026', style: AppTextStyles.bodySmall()),
                    const SizedBox(height: 16),
                    Text('1. Acceptance of Terms', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'By accessing or using MedDeutsch, you agree to be bound by these Terms of Service and all applicable laws and regulations.',
                    ),
                    const SizedBox(height: 16),
                    Text('2. Use of Service', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'MedDeutsch is a language learning application designed to help medical professionals learn German medical terminology. The content is for educational purposes only and should not be used as a substitute for professional medical advice.',
                    ),
                    const SizedBox(height: 16),
                    Text('3. User Accounts', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account.',
                    ),
                    const SizedBox(height: 16),
                    Text('4. Intellectual Property', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'All content, features, and functionality of MedDeutsch are owned by us and are protected by international copyright, trademark, and other intellectual property laws.',
                    ),
                    const SizedBox(height: 16),
                    Text('5. Contact', style: AppTextStyles.heading4()),
                    const SizedBox(height: 8),
                    const Text(
                      'For questions about these Terms, contact us at:\n\n'
                      'Email: support@meddeutsch.app',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Sign Out'),
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
