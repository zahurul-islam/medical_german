/// Preferences service for persisting user settings
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _darkModeKey = 'dark_mode';
  static const String _languageKey = 'user_language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _offlineModeKey = 'offline_mode';

  static PreferencesService? _instance;
  late SharedPreferences _prefs;

  PreferencesService._();

  static Future<PreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = PreferencesService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Dark mode
  bool get isDarkMode => _prefs.getBool(_darkModeKey) ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_darkModeKey, value);

  // Language
  String get language => _prefs.getString(_languageKey) ?? 'en';
  Future<void> setLanguage(String value) => _prefs.setString(_languageKey, value);

  // Notifications
  bool get notificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  Future<void> setNotificationsEnabled(bool value) => _prefs.setBool(_notificationsKey, value);

  // Offline mode
  bool get offlineModeEnabled => _prefs.getBool(_offlineModeKey) ?? false;
  Future<void> setOfflineModeEnabled(bool value) => _prefs.setBool(_offlineModeKey, value);
}

