/// Riverpod providers for app state management
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/preferences_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/models/models.dart';

// Preferences provider
final preferencesServiceProvider = FutureProvider<PreferencesService>((ref) async {
  return await PreferencesService.getInstance();
});

// Repository providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

// Current user provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await authRepo.getUserModel(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// User language provider with persistence
class UserLanguageNotifier extends StateNotifier<String> {
  final Ref ref;
  
  UserLanguageNotifier(this.ref) : super('en') {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await ref.read(preferencesServiceProvider.future);
    state = prefs.language;
  }
  
  Future<void> setLanguage(String language) async {
    state = language;
    final prefs = await ref.read(preferencesServiceProvider.future);
    await prefs.setLanguage(language);
  }
}

final userLanguageProvider = StateNotifierProvider<UserLanguageNotifier, String>((ref) {
  return UserLanguageNotifier(ref);
});

// Theme mode provider with persistence
class DarkModeNotifier extends StateNotifier<bool> {
  final Ref ref;
  
  DarkModeNotifier(this.ref) : super(false) {
    _loadSavedMode();
  }
  
  Future<void> _loadSavedMode() async {
    final prefs = await ref.read(preferencesServiceProvider.future);
    state = prefs.isDarkMode;
  }
  
  Future<void> setDarkMode(bool isDark) async {
    state = isDark;
    final prefs = await ref.read(preferencesServiceProvider.future);
    await prefs.setDarkMode(isDark);
  }
}

final isDarkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref);
});

// Notifications provider
class NotificationsNotifier extends StateNotifier<bool> {
  final Ref ref;
  
  NotificationsNotifier(this.ref) : super(true) {
    _loadSavedState();
  }
  
  Future<void> _loadSavedState() async {
    final prefs = await ref.read(preferencesServiceProvider.future);
    state = prefs.notificationsEnabled;
  }
  
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await ref.read(preferencesServiceProvider.future);
    await prefs.setNotificationsEnabled(enabled);
  }
}

final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  return NotificationsNotifier(ref);
});

// Offline mode provider
class OfflineModeNotifier extends StateNotifier<bool> {
  final Ref ref;
  
  OfflineModeNotifier(this.ref) : super(false) {
    _loadSavedState();
  }
  
  Future<void> _loadSavedState() async {
    final prefs = await ref.read(preferencesServiceProvider.future);
    state = prefs.offlineModeEnabled;
  }
  
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await ref.read(preferencesServiceProvider.future);
    await prefs.setOfflineModeEnabled(enabled);
  }
}

final offlineModeProvider = StateNotifierProvider<OfflineModeNotifier, bool>((ref) {
  return OfflineModeNotifier(ref);
});

// Phases provider
final phasesProvider = FutureProvider<List<PhaseModel>>((ref) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getPhases();
});

// Sections by phase provider
final sectionsByPhaseProvider = FutureProvider.family<List<SectionModel>, String>((ref, phaseId) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getSectionsByPhase(phaseId);
});

// Single section provider
final sectionProvider = FutureProvider.family<SectionModel?, String>((ref, sectionId) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getSection(sectionId);
});

// Vocabulary provider
final vocabularyProvider = FutureProvider.family<List<VocabularyModel>, String>((ref, sectionId) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getVocabulary(sectionId);
});

// Dialogues provider
final dialoguesProvider = FutureProvider.family<List<DialogueModel>, String>((ref, sectionId) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getDialogues(sectionId);
});

// Exercises provider
final exercisesProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, sectionId) async {
  final contentRepo = ref.watch(contentRepositoryProvider);
  return await contentRepo.getExercises(sectionId);
});

// User stats provider
final userStatsProvider = FutureProvider<UserStatsModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await progressRepo.getUserStats(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Recent sections provider
final recentSectionsProvider = FutureProvider<List<ProgressModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await progressRepo.getRecentSections(userId: user.uid);
      }
      return [];
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Section progress provider
final sectionProgressProvider = FutureProvider.family<ProgressModel?, String>((ref, sectionId) async {
  final authState = ref.watch(authStateProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await progressRepo.getSectionProgress(
          userId: user.uid,
          sectionId: sectionId,
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
