/// Main app configuration for MedDeutsch
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/themes/app_theme.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/providers.dart';
import 'l10n/generated/app_localizations.dart';

class MedDeutschApp extends ConsumerWidget {
  const MedDeutschApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userLanguage = ref.watch(userLanguageProvider);
    
    return MaterialApp.router(
      title: 'MedDeutsch',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Router
      routerConfig: router,
      
      // Localization
      locale: Locale(userLanguage),
      supportedLocales: const [
        Locale('en'), // English
        Locale('bn'), // Bangla
        Locale('hi'), // Hindi
        Locale('ur'), // Urdu
        Locale('tr'), // Turkish
        Locale('de'), // German
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
