/// Premium Subscription Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/settings_strings.dart';
import '../../../core/services/subscription_service.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  String? _selectedPlanId;
  bool _isLoading = false;
  bool _isPurchasing = false;

  SettingsStrings get _strings => SettingsStrings(ref.read(userLanguageProvider));

  @override
  void initState() {
    super.initState();
    _initSubscription();
  }

  Future<void> _initSubscription() async {
    setState(() => _isLoading = true);
    
    _subscriptionService.onPurchaseSuccess = () {
      setState(() => _isPurchasing = false);
      _showSuccessDialog();
    };
    
    _subscriptionService.onPurchaseError = (error) {
      setState(() => _isPurchasing = false);
      _showErrorDialog(error);
    };
    
    _subscriptionService.onPurchasePending = () {
      setState(() => _isPurchasing = true);
    };
    
    _subscriptionService.onPurchaseRestored = () {
      setState(() => _isPurchasing = false);
      _showRestoredDialog();
    };
    
    await _subscriptionService.initialize();
    
    // Pre-select yearly plan
    final plans = _subscriptionService.getSubscriptionPlans();
    final yearlyPlan = plans.where((p) => p.isPopular).firstOrNull;
    if (yearlyPlan != null) {
      _selectedPlanId = yearlyPlan.id;
    }
    
    setState(() => _isLoading = false);
  }

  void _showSuccessDialog() {
    final strings = _strings;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: AppColors.success),
            const SizedBox(height: 16),
            Text(strings.welcomePremium, style: AppTextStyles.heading3()),
            const SizedBox(height: 8),
            Text(
              strings.subscriptionActivated,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(strings.letsGo),
          ),
        ],
      ),
    );
  }

  void _showRestoredDialog() {
    final strings = _strings;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restore, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(strings.purchasesRestored, style: AppTextStyles.heading3()),
            const SizedBox(height: 8),
            Text(
              strings.premiumRestored,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    final strings = _strings;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(strings.error),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _purchase() async {
    if (_selectedPlanId == null) return;
    
    setState(() => _isPurchasing = true);
    await _subscriptionService.purchase(_selectedPlanId!);
  }

  Future<void> _restore() async {
    setState(() => _isPurchasing = true);
    await _subscriptionService.restorePurchases();
  }

  @override
  Widget build(BuildContext context) {
    final plans = _subscriptionService.getSubscriptionPlans();
    final userLanguage = ref.watch(userLanguageProvider);
    final strings = SettingsStrings(userLanguage);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Background gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        Color(0xFF1a1a2e),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close, color: Colors.white),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _isPurchasing ? null : _restore,
                              child: Text(
                                strings.restore,
                                style: AppTextStyles.bodyMedium(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Premium icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFD700).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.workspace_premium,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Title
                              Text(
                                strings.medDeutschPremium,
                                style: AppTextStyles.heading1(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                strings.unlockYourPotential,
                                style: AppTextStyles.bodyLarge(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              
                              // Features
                              _FeatureItem(
                                icon: Icons.all_inclusive,
                                title: strings.unlimitedAccess,
                                subtitle: strings.unlockAllLessons,
                              ),
                              _FeatureItem(
                                icon: Icons.quiz,
                                title: strings.allMockTests,
                                subtitle: strings.fspKpPreparation,
                              ),
                              _FeatureItem(
                                icon: Icons.headphones,
                                title: strings.audioLessons,
                                subtitle: strings.professionalPronunciation,
                              ),
                              _FeatureItem(
                                icon: Icons.cloud_download,
                                title: strings.offlineModeFeature,
                                subtitle: strings.learnWithoutInternet,
                              ),
                              _FeatureItem(
                                icon: Icons.block,
                                title: strings.noAds,
                                subtitle: strings.adFreeLearning,
                              ),
                              const SizedBox(height: 32),
                              
                              // Subscription plans
                              ...plans.map((plan) => _PlanCard(
                                plan: plan,
                                isSelected: _selectedPlanId == plan.id,
                                onTap: () => setState(() => _selectedPlanId = plan.id),
                                strings: strings,
                              )),
                              
                              const SizedBox(height: 24),
                              
                              // Purchase button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isPurchasing ? null : _purchase,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD700),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isPurchasing
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                          ),
                                        )
                                      : Text(
                                          strings.becomePremiumNow,
                                          style: AppTextStyles.buttonLarge(color: Colors.black),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Terms
                              Text(
                                strings.autoRenewal,
                                style: AppTextStyles.bodySmall(color: Colors.white54),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Open terms
                                    },
                                    child: Text(
                                      strings.termsShort,
                                      style: AppTextStyles.bodySmall(color: Colors.white54),
                                    ),
                                  ),
                                  Text(' • ', style: AppTextStyles.bodySmall(color: Colors.white54)),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Open privacy
                                    },
                                    child: Text(
                                      strings.privacy,
                                      style: AppTextStyles.bodySmall(color: Colors.white54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
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
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFFD700), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: Colors.white54),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 24),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;
  final SettingsStrings strings;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Color(0xFFFFD700),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.title,
                        style: AppTextStyles.bodyLarge(color: Colors.white),
                      ),
                      if (plan.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            strings.popular,
                            style: AppTextStyles.labelSmall(color: Colors.black),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.description,
                    style: AppTextStyles.bodySmall(color: Colors.white54),
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: AppTextStyles.heading4(color: Colors.white),
                ),
                if (plan.savings != null)
                  Text(
                    plan.savings!,
                    style: AppTextStyles.labelSmall(color: const Color(0xFFFFD700)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

