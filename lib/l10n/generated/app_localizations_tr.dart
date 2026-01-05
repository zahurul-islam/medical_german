// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'MedDeutsch';

  @override
  String get welcomeBack => 'Tekrar Hoş Geldiniz';

  @override
  String get signInToContinue => 'Öğrenmeye devam etmek için giriş yapın';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get forgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get orContinueWith => 'veya şununla devam edin';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu?';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get startJourney => 'Tıbbi Almanca yolculuğunuza başlayın';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get learn => 'Öğren';

  @override
  String get practice => 'Pratik';

  @override
  String get progress => 'İlerleme';

  @override
  String get settings => 'Ayarlar';

  @override
  String get continueLeaning => 'Öğrenmeye Devam Et';

  @override
  String get yourProgress => 'İlerlemeniz';

  @override
  String sectionsCompleted(int count) {
    return '$count bölüm tamamlandı';
  }

  @override
  String level(String level) {
    return 'Seviye $level';
  }

  @override
  String get dayStreak => 'Gün Serisi';

  @override
  String get points => 'Puan';

  @override
  String get learningPhases => 'Öğrenme Aşamaları';

  @override
  String get phase1Title => 'Temel Bilgiler ve Hastane Temelleri';

  @override
  String get phase1Desc =>
      'Yeni başlayanlar için temel selamlaşmalar, anatomi ve hastane navigasyonu.';

  @override
  String get phase2Title => 'Klinik İletişim';

  @override
  String get phase2Desc =>
      'Hasta geçmişi, muayeneler ve tıbbi sistem kelime bilgisi.';

  @override
  String get phase3Title => 'Profesyonel Uzmanlık ve FSP';

  @override
  String get phase3Desc =>
      'İleri düzey dokümantasyon, uzmanlıklar ve sınav hazırlığı.';

  @override
  String get sections => 'Bölümler';

  @override
  String get section => 'Bölüm';

  @override
  String get vocabulary => 'Kelime Bilgisi';

  @override
  String get dialogue => 'Diyalog';

  @override
  String get exercises => 'Alıştırmalar';

  @override
  String minutes(int min) {
    return '$min dakika';
  }

  @override
  String get introduction => 'Giriş';

  @override
  String get grammarFocus => 'Gramer Odağı';

  @override
  String get culturalNotes => 'Kültürel Notlar';

  @override
  String get summary => 'Özet';

  @override
  String get learningObjectives => 'Öğrenme Hedefleri';

  @override
  String get flashcards => 'Bilgi Kartları';

  @override
  String get tapToSeeTranslation => 'Çeviriyi görmek için dokunun';

  @override
  String get tapToSeeGerman => 'Almanca\'yı görmek için dokunun';

  @override
  String get next => 'İleri';

  @override
  String get previous => 'Geri';

  @override
  String get done => 'Bitti';

  @override
  String get startPractice => 'Pratiğe Başla';

  @override
  String get checkAnswer => 'Cevabı Kontrol Et';

  @override
  String get correct => 'Doğru!';

  @override
  String get incorrect => 'Yanlış';

  @override
  String get explanation => 'Açıklama';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String questionsCompleted(int current, int total) {
    return '$total üzerinden $current';
  }

  @override
  String get greatJob => 'Harika!';

  @override
  String get keepPracticing => 'Pratik Yapmaya Devam Et!';

  @override
  String score(int correct, int total) {
    return '$total üzerinden $correct doğru';
  }

  @override
  String get levelProgress => 'Seviye İlerlemesi';

  @override
  String get recentActivity => 'Son Aktivite';

  @override
  String get sourceLanguage => 'Kaynak Dil';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get downloads => 'İndirmeler';

  @override
  String get manageOfflineContent => 'Çevrimdışı içeriği yönet';

  @override
  String get helpFaq => 'Yardım ve SSS';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutConfirm => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get close => 'Kapat';

  @override
  String get error => 'Hata';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get noInternetConnection => 'İnternet bağlantısı yok';

  @override
  String get comingSoon => 'Yakında';
}
