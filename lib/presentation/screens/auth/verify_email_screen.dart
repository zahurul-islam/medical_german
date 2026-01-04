/// Email verification screen
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isLoading = false;
  bool _canResend = true;
  int _resendCooldown = 0;
  Timer? _timer;
  Timer? _checkTimer;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationCheck() {
    // Check every 3 seconds if email is verified
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final authRepo = ref.read(authRepositoryProvider);
      final isVerified = await authRepo.checkEmailVerified();

      if (isVerified && mounted) {
        _checkTimer?.cancel();
        // Navigate to terms screen
        context.go('/terms');
      }
    });
  }

  void _startResendCooldown() {
    setState(() {
      _canResend = false;
      _resendCooldown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.sendEmailVerification();

      _startResendCooldown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            backgroundColor: AppColors.success,
          ),
        );
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

  Future<void> _checkManually() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final isVerified = await authRepo.checkEmailVerified();

      if (isVerified && mounted) {
        _checkTimer?.cancel();
        context.go('/terms');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email not yet verified. Please check your inbox.'),
            backgroundColor: AppColors.warning,
          ),
        );
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

  Future<void> _changeEmail() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.signOut();
    if (mounted) {
      context.go('/register');
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
              const SizedBox(height: 60),

              // Email icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Verify Your Email',
                style: AppTextStyles.heading2(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'We\'ve sent a verification link to:',
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: AppTextStyles.bodyLarge(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(height: 8),
                    Text(
                      'Click the link in the email to verify your account. Once verified, you\'ll be automatically redirected.',
                      style: AppTextStyles.bodySmall(color: AppColors.info),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Check verification button
              ElevatedButton(
                onPressed: _isLoading ? null : _checkManually,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('I\'ve Verified My Email'),
              ),
              const SizedBox(height: 16),

              // Resend button
              OutlinedButton(
                onPressed: (_canResend && !_isLoading) ? _resendVerificationEmail : null,
                child: Text(
                  _canResend
                      ? 'Resend Verification Email'
                      : 'Resend in $_resendCooldown seconds',
                ),
              ),
              const Spacer(),

              // Change email
              TextButton(
                onPressed: _changeEmail,
                child: Text(
                  'Use a different email',
                  style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
