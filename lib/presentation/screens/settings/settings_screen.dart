/// Settings screen for app preferences
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
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
                          style: AppTextStyles.heading4(),
                        ),
                        Text(
                          user?.email ?? '',
                          style: AppTextStyles.bodySmall(),
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
          Text('Language', style: AppTextStyles.heading4()),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.language,
            title: 'Source Language',
            subtitle: _getLanguageName(userLanguage),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const SizedBox(height: 24),

          // Appearance section
          Text('Appearance', style: AppTextStyles.heading4()),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(isDarkModeProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 24),

          // App section
          Text('App', style: AppTextStyles.heading4()),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // TODO: Notification settings
            },
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: 'Downloads',
            subtitle: 'Manage offline content',
            onTap: () {
              // TODO: Downloads screen
            },
          ),
          const SizedBox(height: 24),

          // Support section
          Text('Support', style: AppTextStyles.heading4()),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact Us',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Sign out
          _SettingsTile(
            icon: Icons.logout,
            title: 'Sign Out',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            onTap: () => _showSignOutDialog(context, ref),
          ),
          const SizedBox(height: 24),

          // App version
          Center(
            child: Text(
              'MedDeutsch v1.0.0',
              style: AppTextStyles.bodySmall(color: AppColors.textHintLight),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2026 MedDeutsch',
              style: AppTextStyles.labelSmall(color: AppColors.textHintLight),
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
                ref.read(userLanguageProvider.notifier).state = 'en';
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'bn',
              name: 'বাংলা (Bangla)',
              flag: '🇧🇩',
              onTap: () {
                ref.read(userLanguageProvider.notifier).state = 'bn';
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'hi',
              name: 'हिंदी (Hindi)',
              flag: '🇮🇳',
              onTap: () {
                ref.read(userLanguageProvider.notifier).state = 'hi';
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'ur',
              name: 'اردو (Urdu)',
              flag: '🇵🇰',
              onTap: () {
                ref.read(userLanguageProvider.notifier).state = 'ur';
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'tr',
              name: 'Türkçe (Turkish)',
              flag: '🇹🇷',
              onTap: () {
                ref.read(userLanguageProvider.notifier).state = 'tr';
                Navigator.pop(context);
              },
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

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium(color: titleColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodySmall())
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: AppColors.textHintLight)
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
