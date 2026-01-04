/// App router configuration using GoRouter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../presentation/screens/auth/terms_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/learning/phase_list_screen.dart';
import '../../presentation/screens/learning/section_list_screen.dart';
import '../../presentation/screens/learning/lesson_screen.dart';
import '../../presentation/screens/learning/vocabulary_screen.dart';
import '../../presentation/screens/practice/exercise_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/phases',
        name: 'phases',
        builder: (context, state) => const PhaseListScreen(),
      ),
      GoRoute(
        path: '/phase/:phaseId',
        name: 'sections',
        builder: (context, state) {
          final phaseId = state.pathParameters['phaseId']!;
          return SectionListScreen(phaseId: phaseId);
        },
      ),
      GoRoute(
        path: '/section/:sectionId',
        name: 'lesson',
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId']!;
          return LessonScreen(sectionId: sectionId);
        },
      ),
      GoRoute(
        path: '/section/:sectionId/vocabulary',
        name: 'vocabulary',
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId']!;
          return VocabularyScreen(sectionId: sectionId);
        },
      ),
      GoRoute(
        path: '/section/:sectionId/exercises',
        name: 'exercises',
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId']!;
          return ExerciseScreen(sectionId: sectionId);
        },
      ),
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) async {
      // Add authentication redirect logic here if needed
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
