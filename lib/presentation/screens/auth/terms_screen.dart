/// Terms and Conditions acceptance screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _isLoading = false;

  Future<void> _acceptAndContinue() async {
    if (!_acceptedTerms || !_acceptedPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept both Terms of Service and Privacy Policy'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.acceptTermsAndConditions();

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Terms & Conditions',
                style: AppTextStyles.heading2(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please review and accept our terms to continue',
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Terms content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Service',
                          style: AppTextStyles.heading4(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '''By using MedDeutsch, you agree to the following terms:

1. Educational Purpose
MedDeutsch is designed for educational purposes to help medical professionals learn German medical terminology. The content is not a substitute for professional medical training or certification.

2. Account Responsibility
You are responsible for maintaining the security of your account and all activities that occur under your account.

3. Content Usage
All content provided in MedDeutsch is for personal, non-commercial use. You may not reproduce, distribute, or create derivative works without permission.

4. User Conduct
You agree to use the app in compliance with all applicable laws and regulations. Any misuse may result in account termination.

5. Updates and Changes
We may update these terms from time to time. Continued use of the app constitutes acceptance of any changes.''',
                          style: AppTextStyles.bodyMedium(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Privacy Policy',
                          style: AppTextStyles.heading4(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '''Your privacy is important to us:

1. Data Collection
We collect your email address, learning progress, and app usage data to provide and improve our services.

2. Data Security
We use industry-standard security measures to protect your personal information.

3. Third-Party Services
We use Firebase for authentication and data storage. Your data is processed according to Google's privacy policies.

4. Data Retention
Your data is retained as long as your account is active. You may request deletion of your data at any time.

5. Contact
For privacy concerns, please contact us at privacy@meddeutsch.app''',
                          style: AppTextStyles.bodyMedium(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Checkboxes
              _CheckboxTile(
                value: _acceptedTerms,
                onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                title: 'I accept the Terms of Service',
              ),
              const SizedBox(height: 8),
              _CheckboxTile(
                value: _acceptedPrivacy,
                onChanged: (value) => setState(() => _acceptedPrivacy = value ?? false),
                title: 'I accept the Privacy Policy',
              ),
              const SizedBox(height: 24),

              // Accept button
              ElevatedButton(
                onPressed: (_acceptedTerms && _acceptedPrivacy && !_isLoading)
                    ? _acceptAndContinue
                    : null,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Accept & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;

  const _CheckboxTile({
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
