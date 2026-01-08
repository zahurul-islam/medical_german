/// Onboarding screen for language selection and introduction
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'en';

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.medical_services,
      title: 'Welcome to MedDeutsch',
      titleDe: 'Willkommen bei MedDeutsch',
      description: 'Your comprehensive guide to medical German for healthcare professionals preparing to work in Germany.',
      useLogo: true,
    ),
    OnboardingPage(
      icon: Icons.school,
      title: 'Learn at Your Pace',
      titleDe: 'Lernen Sie in Ihrem Tempo',
      description: 'From A1 to C1 level, master medical vocabulary, clinical communication, and FSP exam preparation.',
    ),
    OnboardingPage(
      icon: Icons.language,
      title: 'Choose Your Language',
      titleDe: 'Wählen Sie Ihre Sprache',
      description: 'Select your native language for translations and explanations.',
      showLanguageSelector: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save language selection and navigate to login
      ref.read(userLanguageProvider.notifier).state = _selectedLanguage;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Skip',
                  style: AppTextStyles.buttonMedium(color: AppColors.primary),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),
            
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.dividerLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            
            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Logo
          if (page.useLogo)
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/med_deutsch_logo.jpg',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: 56,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 40),
          
          // Title
          Text(
            page.title,
            style: AppTextStyles.heading2(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            page.titleDe,
            style: AppTextStyles.germanPhrase(color: AppColors.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondaryLight),
            textAlign: TextAlign.center,
          ),
          
          // Language selector (only on last page)
          if (page.showLanguageSelector) ...[
            const SizedBox(height: 32),
            _buildLanguageSelector(),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languages = [
      LanguageOption('en', 'English', '🇬🇧'),
      LanguageOption('bn', 'বাংলা', '🇧🇩'),
      LanguageOption('hi', 'हिंदी', '🇮🇳'),
      LanguageOption('ur', 'اردو', '🇵🇰'),
      LanguageOption('tr', 'Türkçe', '🇹🇷'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: languages.map((lang) {
        final isSelected = _selectedLanguage == lang.code;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedLanguage = lang.code);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.dividerLight,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  lang.name,
                  style: AppTextStyles.bodyMedium(
                    color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String titleDe;
  final String description;
  final bool showLanguageSelector;
  final bool useLogo;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.titleDe,
    required this.description,
    this.showLanguageSelector = false,
    this.useLogo = false,
  });
}

class LanguageOption {
  final String code;
  final String name;
  final String flag;

  LanguageOption(this.code, this.name, this.flag);
}
