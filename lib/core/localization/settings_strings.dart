/// Localized strings for Settings screen
/// Supports: English (en), Bangla (bn), Hindi (hi), Urdu (ur), Turkish (tr)

class SettingsStrings {
  final String languageCode;

  SettingsStrings(this.languageCode);

  // App Bar
  String get settings => _translate({
    'en': 'Settings',
    'bn': 'সেটিংস',
    'hi': 'सेटिंग्स',
    'ur': 'ترتیبات',
    'tr': 'Ayarlar',
  });

  // Profile Section
  String get level => _translate({
    'en': 'Level',
    'bn': 'স্তর',
    'hi': 'स्तर',
    'ur': 'سطح',
    'tr': 'Seviye',
  });

  String get doctor => _translate({
    'en': 'Doctor',
    'bn': 'ডাক্তার',
    'hi': 'डॉक्टर',
    'ur': 'ڈاکٹر',
    'tr': 'Doktor',
  });

  // Premium Section
  String get premiumActive => _translate({
    'en': 'Premium Active',
    'bn': 'প্রিমিয়াম সক্রিয়',
    'hi': 'प्रीमियम सक्रिय',
    'ur': 'پریمیم فعال',
    'tr': 'Premium Aktif',
  });

  String get becomePremium => _translate({
    'en': 'Become Premium',
    'bn': 'প্রিমিয়াম হোন',
    'hi': 'प्रीमियम बनें',
    'ur': 'پریمیم بنیں',
    'tr': 'Premium Ol',
  });

  String get enjoyPremiumFeatures => _translate({
    'en': 'Enjoy all Premium features',
    'bn': 'সব প্রিমিয়াম সুবিধা উপভোগ করুন',
    'hi': 'सभी प्रीमियम सुविधाओं का आनंद लें',
    'ur': 'تمام پریمیم سہولیات سے لطف اٹھائیں',
    'tr': 'Tüm Premium özelliklerinin keyfini çıkarın',
  });

  String get unlockAllFeatures => _translate({
    'en': 'Unlock all features',
    'bn': 'সব সুবিধা আনলক করুন',
    'hi': 'सभी सुविधाएं अनलॉक करें',
    'ur': 'تمام سہولیات ان لاک کریں',
    'tr': 'Tüm özelliklerin kilidini açın',
  });

  // Language Section
  String get language => _translate({
    'en': 'Language',
    'bn': 'ভাষা',
    'hi': 'भाषा',
    'ur': 'زبان',
    'tr': 'Dil',
  });

  String get sourceLanguage => _translate({
    'en': 'Source Language',
    'bn': 'উৎস ভাষা',
    'hi': 'स्रोत भाषा',
    'ur': 'ماخذ زبان',
    'tr': 'Kaynak Dil',
  });

  String get selectLanguage => _translate({
    'en': 'Select Language',
    'bn': 'ভাষা নির্বাচন করুন',
    'hi': 'भाषा चुनें',
    'ur': 'زبان منتخب کریں',
    'tr': 'Dil Seçin',
  });

  // Appearance Section
  String get appearance => _translate({
    'en': 'Appearance',
    'bn': 'চেহারা',
    'hi': 'दिखावट',
    'ur': 'ظاہری شکل',
    'tr': 'Görünüm',
  });

  String get darkMode => _translate({
    'en': 'Dark Mode',
    'bn': 'ডার্ক মোড',
    'hi': 'डार्क मोड',
    'ur': 'ڈارک موڈ',
    'tr': 'Karanlık Mod',
  });

  // App Section
  String get app => _translate({
    'en': 'App',
    'bn': 'অ্যাপ',
    'hi': 'ऐप',
    'ur': 'ایپ',
    'tr': 'Uygulama',
  });

  String get notifications => _translate({
    'en': 'Notifications',
    'bn': 'বিজ্ঞপ্তি',
    'hi': 'सूचनाएं',
    'ur': 'اطلاعات',
    'tr': 'Bildirimler',
  });

  String get offlineMode => _translate({
    'en': 'Offline Mode',
    'bn': 'অফলাইন মোড',
    'hi': 'ऑफलाइन मोड',
    'ur': 'آف لائن موڈ',
    'tr': 'Çevrimdışı Mod',
  });

  String get offlineModeSubtitle => _translate({
    'en': 'Download content for offline use',
    'bn': 'অফলাইন ব্যবহারের জন্য কন্টেন্ট ডাউনলোড করুন',
    'hi': 'ऑफलाइन उपयोग के लिए सामग्री डाउनलोड करें',
    'ur': 'آف لائن استعمال کے لیے مواد ڈاؤن لوڈ کریں',
    'tr': 'Çevrimdışı kullanım için içerik indirin',
  });

  String get offlineModeEnabled => _translate({
    'en': 'Offline mode enabled. Content will be cached.',
    'bn': 'অফলাইন মোড সক্রিয়। কন্টেন্ট ক্যাশ করা হবে।',
    'hi': 'ऑफलाइन मोड सक्षम। सामग्री कैश की जाएगी।',
    'ur': 'آف لائن موڈ فعال۔ مواد کیش ہو جائے گا۔',
    'tr': 'Çevrimdışı mod etkin. İçerik önbelleğe alınacak.',
  });

  String get downloads => _translate({
    'en': 'Downloads',
    'bn': 'ডাউনলোডস',
    'hi': 'डाउनलोड',
    'ur': 'ڈاؤن لوڈز',
    'tr': 'İndirmeler',
  });

  String get manageOfflineContent => _translate({
    'en': 'Manage offline content',
    'bn': 'অফলাইন কন্টেন্ট পরিচালনা করুন',
    'hi': 'ऑफलाइन सामग्री प्रबंधित करें',
    'ur': 'آف لائن مواد کا نظم کریں',
    'tr': 'Çevrimdışı içeriği yönetin',
  });

  String get manageDownloads => _translate({
    'en': 'Manage your offline content here.',
    'bn': 'এখানে আপনার অফলাইন কন্টেন্ট পরিচালনা করুন।',
    'hi': 'यहां अपनी ऑफलाइन सामग्री प्रबंधित करें।',
    'ur': 'یہاں اپنا آف لائن مواد منظم کریں۔',
    'tr': 'Çevrimdışı içeriğinizi buradan yönetin.',
  });

  String get learningContent => _translate({
    'en': 'Learning Content',
    'bn': 'শেখার কন্টেন্ট',
    'hi': 'सीखने की सामग्री',
    'ur': 'سیکھنے کا مواد',
    'tr': 'Öğrenme İçeriği',
  });

  String get allSectionsCached => _translate({
    'en': 'All sections cached',
    'bn': 'সব সেকশন ক্যাশ করা হয়েছে',
    'hi': 'सभी अनुभाग कैश किए गए',
    'ur': 'تمام سیکشنز کیش ہیں',
    'tr': 'Tüm bölümler önbelleğe alındı',
  });

  String get audioFiles => _translate({
    'en': 'Audio Files',
    'bn': 'অডিও ফাইল',
    'hi': 'ऑडियो फाइलें',
    'ur': 'آڈیو فائلیں',
    'tr': 'Ses Dosyaları',
  });

  // Support Section
  String get support => _translate({
    'en': 'Support',
    'bn': 'সাহায্য',
    'hi': 'सहायता',
    'ur': 'مدد',
    'tr': 'Destek',
  });

  String get helpAndFAQ => _translate({
    'en': 'Help & FAQ',
    'bn': 'সাহায্য এবং প্রশ্নাবলী',
    'hi': 'सहायता और अक्सर पूछे जाने वाले प्रश्न',
    'ur': 'مدد اور سوالات',
    'tr': 'Yardım ve SSS',
  });

  String get contactUs => _translate({
    'en': 'Contact Us',
    'bn': 'যোগাযোগ করুন',
    'hi': 'संपर्क करें',
    'ur': 'ہم سے رابطہ کریں',
    'tr': 'Bize Ulaşın',
  });

  String get privacyPolicy => _translate({
    'en': 'Privacy Policy',
    'bn': 'গোপনীয়তা নীতি',
    'hi': 'गोपनीयता नीति',
    'ur': 'رازداری کی پالیسی',
    'tr': 'Gizlilik Politikası',
  });

  String get termsOfService => _translate({
    'en': 'Terms of Service',
    'bn': 'সেবার শর্তাবলী',
    'hi': 'सेवा की शर्तें',
    'ur': 'سروس کی شرائط',
    'tr': 'Hizmet Şartları',
  });

  // Sign Out
  String get signOut => _translate({
    'en': 'Sign Out',
    'bn': 'সাইন আউট',
    'hi': 'साइन आउट',
    'ur': 'سائن آؤٹ',
    'tr': 'Çıkış Yap',
  });

  String get signOutConfirmation => _translate({
    'en': 'Are you sure you want to sign out?',
    'bn': 'আপনি কি সাইন আউট করতে চান?',
    'hi': 'क्या आप वाकई साइन आउट करना चाहते हैं?',
    'ur': 'کیا آپ واقعی سائن آؤٹ کرنا چاہتے ہیں؟',
    'tr': 'Çıkış yapmak istediğinizden emin misiniz?',
  });

  String get cancel => _translate({
    'en': 'Cancel',
    'bn': 'বাতিল',
    'hi': 'रद्द करें',
    'ur': 'منسوخ',
    'tr': 'İptal',
  });

  String get close => _translate({
    'en': 'Close',
    'bn': 'বন্ধ',
    'hi': 'बंद करें',
    'ur': 'بند کریں',
    'tr': 'Kapat',
  });

  // FAQ Questions
  String get faqStartLearning => _translate({
    'en': 'How do I start learning German medical terminology?',
    'bn': 'আমি কীভাবে জার্মান চিকিৎসা পরিভাষা শিখতে শুরু করব?',
    'hi': 'मैं जर्मन चिकित्सा शब्दावली सीखना कैसे शुरू करूं?',
    'ur': 'میں جرمن طبی اصطلاحات سیکھنا کیسے شروع کروں؟',
    'tr': 'Almanca tıbbi terminolojiyi öğrenmeye nasıl başlarım?',
  });

  String get faqStartLearningAnswer => _translate({
    'en': 'Begin with Phase 1, which covers essential greetings and basic medical vocabulary. Complete each section sequentially for the best learning experience.',
    'bn': 'ফেজ ১ দিয়ে শুরু করুন, যা প্রয়োজনীয় অভিবাদন এবং মৌলিক চিকিৎসা শব্দভান্ডার কভার করে। সেরা শেখার অভিজ্ঞতার জন্য প্রতিটি সেকশন ধারাবাহিকভাবে সম্পূর্ণ করুন।',
    'hi': 'चरण 1 से शुरू करें, जिसमें आवश्यक अभिवादन और बुनियादी चिकित्सा शब्दावली शामिल है। सर्वोत्तम सीखने के अनुभव के लिए प्रत्येक खंड को क्रमिक रूप से पूरा करें।',
    'ur': 'مرحلہ 1 سے شروع کریں، جو ضروری سلام اور بنیادی طبی الفاظ کا احاطہ کرتا ہے۔ بہترین سیکھنے کے تجربے کے لیے ہر سیکشن کو ترتیب سے مکمل کریں۔',
    'tr': 'Temel selamlamaları ve temel tıbbi kelime bilgisini kapsayan Faz 1 ile başlayın. En iyi öğrenme deneyimi için her bölümü sırayla tamamlayın.',
  });

  String get faqOffline => _translate({
    'en': 'Can I use the app offline?',
    'bn': 'আমি কি অফলাইনে অ্যাপ ব্যবহার করতে পারি?',
    'hi': 'क्या मैं ऐप को ऑफलाइन उपयोग कर सकता हूं?',
    'ur': 'کیا میں ایپ آف لائن استعمال کر سکتا ہوں؟',
    'tr': 'Uygulamayı çevrimdışı kullanabilir miyim?',
  });

  String get faqOfflineAnswer => _translate({
    'en': 'Yes! Enable Offline Mode in Settings to download all content. Audio files and lessons will be available without an internet connection.',
    'bn': 'হ্যাঁ! সব কন্টেন্ট ডাউনলোড করতে সেটিংসে অফলাইন মোড সক্রিয় করুন। ইন্টারনেট সংযোগ ছাড়াই অডিও ফাইল এবং পাঠ পাওয়া যাবে।',
    'hi': 'हाँ! सभी सामग्री डाउनलोड करने के लिए सेटिंग्स में ऑफलाइन मोड सक्षम करें। इंटरनेट कनेक्शन के बिना ऑडियो फ़ाइलें और पाठ उपलब्ध होंगे।',
    'ur': 'ہاں! تمام مواد ڈاؤن لوڈ کرنے کے لیے سیٹنگز میں آف لائن موڈ فعال کریں۔ انٹرنیٹ کنکشن کے بغیر آڈیو فائلیں اور اسباق دستیاب ہوں گے۔',
    'tr': 'Evet! Tüm içeriği indirmek için Ayarlar\'da Çevrimdışı Modu etkinleştirin. Ses dosyaları ve dersler internet bağlantısı olmadan kullanılabilir olacaktır.',
  });

  String get faqChangeLanguage => _translate({
    'en': 'How do I change the translation language?',
    'bn': 'আমি কীভাবে অনুবাদের ভাষা পরিবর্তন করব?',
    'hi': 'मैं अनुवाद की भाषा कैसे बदलूं?',
    'ur': 'میں ترجمے کی زبان کیسے تبدیل کروں؟',
    'tr': 'Çeviri dilini nasıl değiştiririm?',
  });

  String get faqChangeLanguageAnswer => _translate({
    'en': 'Go to Settings > Source Language and select your preferred language (English, Bangla, Hindi, Urdu, or Turkish).',
    'bn': 'সেটিংস > সোর্স ল্যাঙ্গুয়েজ এ যান এবং আপনার পছন্দের ভাষা নির্বাচন করুন (ইংরেজি, বাংলা, হিন্দি, উর্দু, বা তুর্কি)।',
    'hi': 'सेटिंग्स > स्रोत भाषा पर जाएं और अपनी पसंदीदा भाषा चुनें (अंग्रेजी, बांग्ला, हिंदी, उर्दू, या तुर्की)।',
    'ur': 'سیٹنگز > ماخذ زبان پر جائیں اور اپنی پسندیدہ زبان منتخب کریں (انگریزی، بنگلہ، ہندی، اردو، یا ترکی)۔',
    'tr': 'Ayarlar > Kaynak Dil\'e gidin ve tercih ettiğiniz dili seçin (İngilizce, Bangla, Hintçe, Urduca veya Türkçe).',
  });

  String get faqPhases => _translate({
    'en': 'How are the learning phases organized?',
    'bn': 'শেখার ধাপগুলো কীভাবে সংগঠিত?',
    'hi': 'सीखने के चरण कैसे व्यवस्थित हैं?',
    'ur': 'سیکھنے کے مراحل کیسے منظم ہیں؟',
    'tr': 'Öğrenme aşamaları nasıl düzenleniyor?',
  });

  String get faqPhasesAnswer => _translate({
    'en': 'Phase 1 covers A1-A2 level basics, Phase 2 covers B1 intermediate medical German, and Phase 3 covers B2-C1 advanced professional communication.',
    'bn': 'ফেজ ১ এ A1-A2 স্তরের মৌলিক বিষয়, ফেজ ২ এ B1 মধ্যবর্তী মেডিকেল জার্মান এবং ফেজ ৩ এ B2-C1 উন্নত পেশাদার যোগাযোগ কভার করে।',
    'hi': 'चरण 1 में A1-A2 स्तर की मूल बातें, चरण 2 में B1 मध्यवर्ती चिकित्सा जर्मन और चरण 3 में B2-C1 उन्नत पेशेवर संचार शामिल है।',
    'ur': 'مرحلہ 1 میں A1-A2 سطح کی بنیادی باتیں، مرحلہ 2 میں B1 درمیانی طبی جرمن اور مرحلہ 3 میں B2-C1 اعلیٰ پیشہ ورانہ رابطہ شامل ہے۔',
    'tr': 'Faz 1, A1-A2 seviye temelleri kapsar, Faz 2, B1 orta seviye tıbbi Almanca\'yı kapsar ve Faz 3, B2-C1 ileri profesyonel iletişimi kapsar.',
  });

  String get faqPractice => _translate({
    'en': 'How do I practice vocabulary?',
    'bn': 'আমি কীভাবে শব্দভান্ডার অনুশীলন করব?',
    'hi': 'मैं शब्दावली का अभ्यास कैसे करूं?',
    'ur': 'میں الفاظ کی مشق کیسے کروں؟',
    'tr': 'Kelime bilgisi pratik nasıl yapılır?',
  });

  String get faqPracticeAnswer => _translate({
    'en': 'Each section includes flashcards and practice exercises. Use the Vocab tab to study terms, and the Practice tab for quizzes.',
    'bn': 'প্রতিটি সেকশনে ফ্ল্যাশকার্ড এবং অনুশীলন অন্তর্ভুক্ত। শব্দ অধ্যয়নের জন্য ভোকাব ট্যাব এবং কুইজের জন্য প্র্যাকটিস ট্যাব ব্যবহার করুন।',
    'hi': 'प्रत्येक खंड में फ्लैशकार्ड और अभ्यास शामिल हैं। शब्दों का अध्ययन करने के लिए वोकैब टैब और क्विज़ के लिए प्रैक्टिस टैब का उपयोग करें।',
    'ur': 'ہر سیکشن میں فلیش کارڈز اور مشق شامل ہے۔ الفاظ کے مطالعے کے لیے ووکیب ٹیب اور کوئز کے لیے پریکٹس ٹیب استعمال کریں۔',
    'tr': 'Her bölüm bilgi kartları ve pratik alıştırmaları içerir. Terimleri çalışmak için Kelime sekmesini, testler için Pratik sekmesini kullanın.',
  });

  String get faqAudio => _translate({
    'en': 'Why is audio not playing?',
    'bn': 'অডিও কেন চলছে না?',
    'hi': 'ऑडियो क्यों नहीं चल रहा?',
    'ur': 'آڈیو کیوں نہیں چل رہا؟',
    'tr': 'Ses neden çalmıyor?',
  });

  String get faqAudioAnswer => _translate({
    'en': 'Ensure your device volume is up and not on silent mode. If issues persist, try re-downloading the audio files in Settings > Downloads.',
    'bn': 'নিশ্চিত করুন যে আপনার ডিভাইসের ভলিউম বাড়ানো আছে এবং সাইলেন্ট মোডে নেই। সমস্যা থাকলে, সেটিংস > ডাউনলোডসে অডিও ফাইল পুনরায় ডাউনলোড করুন।',
    'hi': 'सुनिश्चित करें कि आपके डिवाइस का वॉल्यूम चालू है और साइलेंट मोड में नहीं है। समस्या बनी रहे तो सेटिंग्स > डाउनलोड में ऑडियो फ़ाइलें पुनः डाउनलोड करें।',
    'ur': 'یقینی بنائیں کہ آپ کے آلے کا والیوم بڑھا ہوا ہے اور خاموش موڈ میں نہیں ہے۔ مسئلہ برقرار رہے تو سیٹنگز > ڈاؤن لوڈز میں آڈیو فائلیں دوبارہ ڈاؤن لوڈ کریں۔',
    'tr': 'Cihazınızın sesinin açık olduğundan ve sessiz modda olmadığından emin olun. Sorun devam ederse, Ayarlar > İndirmeler\'den ses dosyalarını yeniden indirmeyi deneyin.',
  });

  String get faqContact => _translate({
    'en': 'How do I contact support?',
    'bn': 'আমি কীভাবে সাপোর্টে যোগাযোগ করব?',
    'hi': 'मैं सहायता से कैसे संपर्क करूं?',
    'ur': 'میں سپورٹ سے کیسے رابطہ کروں؟',
    'tr': 'Destekle nasıl iletişime geçebilirim?',
  });

  String get faqContactAnswer => _translate({
    'en': 'Email us at support@meddeutsch.app for any questions or technical issues.',
    'bn': 'যেকোনো প্রশ্ন বা প্রযুক্তিগত সমস্যার জন্য support@meddeutsch.app এ ইমেইল করুন।',
    'hi': 'किसी भी प्रश्न या तकनीकी समस्याओं के लिए support@meddeutsch.app पर ईमेल करें।',
    'ur': 'کسی بھی سوال یا تکنیکی مسائل کے لیے support@meddeutsch.app پر ای میل کریں۔',
    'tr': 'Herhangi bir soru veya teknik sorun için support@meddeutsch.app adresine e-posta gönderin.',
  });

  // Privacy Policy
  String get lastUpdated => _translate({
    'en': 'Last Updated: January 2026',
    'bn': 'সর্বশেষ আপডেট: জানুয়ারি ২০২৬',
    'hi': 'अंतिम अपडेट: जनवरी 2026',
    'ur': 'آخری اپ ڈیٹ: جنوری 2026',
    'tr': 'Son Güncelleme: Ocak 2026',
  });

  String get infoWeCollect => _translate({
    'en': '1. Information We Collect',
    'bn': '১. আমরা যে তথ্য সংগ্রহ করি',
    'hi': '1. हम जो जानकारी एकत्र करते हैं',
    'ur': '1. ہم جو معلومات جمع کرتے ہیں',
    'tr': '1. Topladığımız Bilgiler',
  });

  String get howWeUseInfo => _translate({
    'en': '2. How We Use Your Information',
    'bn': '২. আমরা কীভাবে আপনার তথ্য ব্যবহার করি',
    'hi': '2. हम आपकी जानकारी का उपयोग कैसे करते हैं',
    'ur': '2. ہم آپ کی معلومات کیسے استعمال کرتے ہیں',
    'tr': '2. Bilgilerinizi Nasıl Kullanıyoruz',
  });

  String get dataSecurity => _translate({
    'en': '3. Data Security',
    'bn': '৩. ডেটা নিরাপত্তা',
    'hi': '3. डेटा सुरक्षा',
    'ur': '3. ڈیٹا سیکیورٹی',
    'tr': '3. Veri Güvenliği',
  });

  String get contact => _translate({
    'en': '4. Contact Us',
    'bn': '৪. যোগাযোগ করুন',
    'hi': '4. संपर्क करें',
    'ur': '4. ہم سے رابطہ کریں',
    'tr': '4. Bize Ulaşın',
  });

  // Terms of Service
  String get acceptanceOfTerms => _translate({
    'en': '1. Acceptance of Terms',
    'bn': '১. শর্তাবলী গ্রহণ',
    'hi': '1. शर्तों की स्वीकृति',
    'ur': '1. شرائط کی قبولیت',
    'tr': '1. Şartların Kabulü',
  });

  String get useOfService => _translate({
    'en': '2. Use of Service',
    'bn': '২. সেবার ব্যবহার',
    'hi': '2. सेवा का उपयोग',
    'ur': '2. سروس کا استعمال',
    'tr': '2. Hizmetin Kullanımı',
  });

  String get userAccounts => _translate({
    'en': '3. User Accounts',
    'bn': '৩. ব্যবহারকারী অ্যাকাউন্ট',
    'hi': '3. उपयोगकर्ता खाते',
    'ur': '3. صارف اکاؤنٹس',
    'tr': '3. Kullanıcı Hesapları',
  });

  String get intellectualProperty => _translate({
    'en': '4. Intellectual Property',
    'bn': '৪. বুদ্ধিবৃত্তিক সম্পত্তি',
    'hi': '4. बौद्धिक संपदा',
    'ur': '4. دانشورانہ املاک',
    'tr': '4. Fikri Mülkiyet',
  });

  String get contactTerms => _translate({
    'en': '5. Contact',
    'bn': '৫. যোগাযোগ',
    'hi': '5. संपर्क',
    'ur': '5. رابطہ',
    'tr': '5. İletişim',
  });

  // ============== PRIVACY POLICY CONTENT ==============

  String get privacyInfoWeCollectContent => _translate({
    'en': 'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This may include:\n\n'
        '• Email address for authentication\n'
        '• Learning progress and preferences\n'
        '• App usage data to improve your experience',
    'bn': 'আমরা আপনার কাছ থেকে সরাসরি প্রদত্ত তথ্য সংগ্রহ করি, যেমন যখন আপনি একটি অ্যাকাউন্ট তৈরি করেন, আমাদের পরিষেবা ব্যবহার করেন, বা সহায়তার জন্য আমাদের সাথে যোগাযোগ করেন। এতে অন্তর্ভুক্ত থাকতে পারে:\n\n'
        '• প্রমাণীকরণের জন্য ইমেইল ঠিকানা\n'
        '• শেখার অগ্রগতি এবং পছন্দসমূহ\n'
        '• আপনার অভিজ্ঞতা উন্নত করতে অ্যাপ ব্যবহারের ডেটা',
    'hi': 'हम वह जानकारी एकत्र करते हैं जो आप हमें सीधे प्रदान करते हैं, जैसे जब आप खाता बनाते हैं, हमारी सेवाओं का उपयोग करते हैं, या सहायता के लिए हमसे संपर्क करते हैं। इसमें शामिल हो सकते हैं:\n\n'
        '• प्रमाणीकरण के लिए ईमेल पता\n'
        '• सीखने की प्रगति और प्राथमिकताएं\n'
        '• आपके अनुभव को बेहतर बनाने के लिए ऐप उपयोग डेटा',
    'ur': 'ہم وہ معلومات جمع کرتے ہیں جو آپ ہمیں براہ راست فراہم کرتے ہیں، جیسے جب آپ اکاؤنٹ بناتے ہیں، ہماری خدمات استعمال کرتے ہیں، یا مدد کے لیے ہم سے رابطہ کرتے ہیں۔ اس میں شامل ہو سکتے ہیں:\n\n'
        '• تصدیق کے لیے ای میل ایڈریس\n'
        '• سیکھنے کی پیشرفت اور ترجیحات\n'
        '• آپ کے تجربے کو بہتر بنانے کے لیے ایپ کے استعمال کا ڈیٹا',
    'tr': 'Hesap oluşturduğunuzda, hizmetlerimizi kullandığınızda veya destek için bizimle iletişime geçtiğinizde bize doğrudan sağladığınız bilgileri topluyoruz. Bunlar şunları içerebilir:\n\n'
        '• Kimlik doğrulama için e-posta adresi\n'
        '• Öğrenme ilerlemesi ve tercihler\n'
        '• Deneyiminizi iyileştirmek için uygulama kullanım verileri',
  });

  String get privacyHowWeUseContent => _translate({
    'en': 'We use the information we collect to:\n\n'
        '• Provide, maintain, and improve our services\n'
        '• Track your learning progress\n'
        '• Send you notifications about your learning goals\n'
        '• Respond to your comments and questions',
    'bn': 'আমরা সংগৃহীত তথ্য ব্যবহার করি:\n\n'
        '• আমাদের পরিষেবা প্রদান, রক্ষণাবেক্ষণ এবং উন্নত করতে\n'
        '• আপনার শেখার অগ্রগতি ট্র্যাক করতে\n'
        '• আপনার শেখার লক্ষ্য সম্পর্কে বিজ্ঞপ্তি পাঠাতে\n'
        '• আপনার মন্তব্য এবং প্রশ্নের উত্তর দিতে',
    'hi': 'हम एकत्रित जानकारी का उपयोग करते हैं:\n\n'
        '• हमारी सेवाएं प्रदान करने, बनाए रखने और सुधारने के लिए\n'
        '• आपकी सीखने की प्रगति को ट्रैक करने के लिए\n'
        '• आपके सीखने के लक्ष्यों के बारे में सूचनाएं भेजने के लिए\n'
        '• आपकी टिप्पणियों और प्रश्नों का उत्तर देने के लिए',
    'ur': 'ہم جمع کردہ معلومات کا استعمال کرتے ہیں:\n\n'
        '• اپنی خدمات فراہم کرنے، برقرار رکھنے اور بہتر بنانے کے لیے\n'
        '• آپ کی سیکھنے کی پیشرفت کو ٹریک کرنے کے لیے\n'
        '• آپ کے سیکھنے کے اہداف کے بارے میں اطلاعات بھیجنے کے لیے\n'
        '• آپ کے تبصروں اور سوالات کا جواب دینے کے لیے',
    'tr': 'Topladığımız bilgileri şunlar için kullanıyoruz:\n\n'
        '• Hizmetlerimizi sağlamak, sürdürmek ve iyileştirmek\n'
        '• Öğrenme ilerlemenizi takip etmek\n'
        '• Öğrenme hedefleriniz hakkında bildirimler göndermek\n'
        '• Yorumlarınıza ve sorularınıza yanıt vermek',
  });

  String get privacyDataSecurityContent => _translate({
    'en': 'We implement appropriate security measures to protect your personal information. Your data is stored securely using Firebase services with encryption.',
    'bn': 'আমরা আপনার ব্যক্তিগত তথ্য সুরক্ষিত করতে যথাযথ নিরাপত্তা ব্যবস্থা প্রয়োগ করি। আপনার ডেটা এনক্রিপশন সহ Firebase পরিষেবা ব্যবহার করে নিরাপদে সংরক্ষণ করা হয়।',
    'hi': 'हम आपकी व्यक्तिगत जानकारी की सुरक्षा के लिए उचित सुरक्षा उपाय लागू करते हैं। आपका डेटा एन्क्रिप्शन के साथ Firebase सेवाओं का उपयोग करके सुरक्षित रूप से संग्रहीत किया जाता है।',
    'ur': 'ہم آپ کی ذاتی معلومات کی حفاظت کے لیے مناسب حفاظتی اقدامات نافذ کرتے ہیں۔ آپ کا ڈیٹا انکرپشن کے ساتھ Firebase سروسز کا استعمال کرتے ہوئے محفوظ طریقے سے ذخیرہ کیا جاتا ہے۔',
    'tr': 'Kişisel bilgilerinizi korumak için uygun güvenlik önlemleri uyguluyoruz. Verileriniz, şifreleme ile Firebase hizmetleri kullanılarak güvenli bir şekilde saklanmaktadır.',
  });

  String get privacyContactContent => _translate({
    'en': 'If you have questions about this Privacy Policy, please contact us at:\n\nEmail: support@meddeutsch.app',
    'bn': 'এই গোপনীয়তা নীতি সম্পর্কে আপনার প্রশ্ন থাকলে, অনুগ্রহ করে আমাদের সাথে যোগাযোগ করুন:\n\nইমেইল: support@meddeutsch.app',
    'hi': 'यदि इस गोपनीयता नीति के बारे में आपके कोई प्रश्न हैं, तो कृपया हमसे संपर्क करें:\n\nईमेल: support@meddeutsch.app',
    'ur': 'اگر آپ کے اس رازداری کی پالیسی کے بارے میں سوالات ہیں، تو براہ کرم ہم سے رابطہ کریں:\n\nای میل: support@meddeutsch.app',
    'tr': 'Bu Gizlilik Politikası hakkında sorularınız varsa, lütfen bizimle iletişime geçin:\n\nE-posta: support@meddeutsch.app',
  });

  // ============== TERMS OF SERVICE CONTENT ==============

  String get termsAcceptanceContent => _translate({
    'en': 'By accessing or using MedDeutsch, you agree to be bound by these Terms of Service and all applicable laws and regulations.',
    'bn': 'MedDeutsch অ্যাক্সেস বা ব্যবহার করে, আপনি এই সেবার শর্তাবলী এবং সমস্ত প্রযোজ্য আইন ও প্রবিধান মেনে চলতে সম্মত হন।',
    'hi': 'MedDeutsch तक पहुंचने या उपयोग करने से, आप इन सेवा की शर्तों और सभी लागू कानूनों और विनियमों से बंधे होने के लिए सहमत हैं।',
    'ur': 'MedDeutsch تک رسائی یا استعمال کرکے، آپ ان سروس کی شرائط اور تمام قابل اطلاق قوانین و ضوابط کی پابندی پر رضامند ہیں۔',
    'tr': 'MedDeutsch\'a erişerek veya kullanarak, bu Hizmet Şartlarına ve tüm geçerli yasa ve yönetmeliklere bağlı olmayı kabul edersiniz.',
  });

  String get termsUseOfServiceContent => _translate({
    'en': 'MedDeutsch is a language learning application designed to help medical professionals learn German medical terminology. The content is for educational purposes only and should not be used as a substitute for professional medical advice.',
    'bn': 'MedDeutsch একটি ভাষা শেখার অ্যাপ্লিকেশন যা চিকিৎসা পেশাদারদের জার্মান চিকিৎসা পরিভাষা শিখতে সাহায্য করার জন্য ডিজাইন করা হয়েছে। বিষয়বস্তু শুধুমাত্র শিক্ষামূলক উদ্দেশ্যে এবং পেশাদার চিকিৎসা পরামর্শের বিকল্প হিসাবে ব্যবহার করা উচিত নয়।',
    'hi': 'MedDeutsch एक भाषा सीखने का एप्लिकेशन है जो चिकित्सा पेशेवरों को जर्मन चिकित्सा शब्दावली सीखने में मदद करने के लिए डिज़ाइन किया गया है। सामग्री केवल शैक्षिक उद्देश्यों के लिए है और पेशेवर चिकित्सा सलाह के विकल्प के रूप में उपयोग नहीं की जानी चाहिए।',
    'ur': 'MedDeutsch ایک زبان سیکھنے کی ایپلیکیشن ہے جو طبی پیشہ ور افراد کو جرمن طبی اصطلاحات سیکھنے میں مدد کرنے کے لیے ڈیزائن کی گئی ہے۔ مواد صرف تعلیمی مقاصد کے لیے ہے اور پیشہ ورانہ طبی مشورے کے متبادل کے طور پر استعمال نہیں کیا جانا چاہیے۔',
    'tr': 'MedDeutsch, tıp profesyonellerinin Almanca tıbbi terminolojiyi öğrenmelerine yardımcı olmak için tasarlanmış bir dil öğrenme uygulamasıdır. İçerik yalnızca eğitim amaçlıdır ve profesyonel tıbbi tavsiyenin yerine kullanılmamalıdır.',
  });

  String get termsUserAccountsContent => _translate({
    'en': 'You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account.',
    'bn': 'আপনার অ্যাকাউন্টের শংসাপত্রের গোপনীয়তা বজায় রাখার জন্য আপনি দায়ী। আপনি আপনার অ্যাকাউন্টের যেকোনো অননুমোদিত ব্যবহারের বিষয়ে অবিলম্বে আমাদের অবহিত করতে সম্মত হন।',
    'hi': 'आप अपने खाते की क्रेडेंशियल्स की गोपनीयता बनाए रखने के लिए जिम्मेदार हैं। आप अपने खाते के किसी भी अनधिकृत उपयोग के बारे में तुरंत हमें सूचित करने के लिए सहमत हैं।',
    'ur': 'آپ اپنے اکاؤنٹ کی اسناد کی رازداری برقرار رکھنے کے ذمہ دار ہیں۔ آپ اپنے اکاؤنٹ کے کسی بھی غیر مجاز استعمال کے بارے میں فوری طور پر ہمیں مطلع کرنے پر رضامند ہیں۔',
    'tr': 'Hesap kimlik bilgilerinizin gizliliğini korumaktan siz sorumlusunuz. Hesabınızın herhangi bir yetkisiz kullanımını derhal bize bildirmeyi kabul edersiniz.',
  });

  String get termsIntellectualPropertyContent => _translate({
    'en': 'All content, features, and functionality of MedDeutsch are owned by us and are protected by international copyright, trademark, and other intellectual property laws.',
    'bn': 'MedDeutsch-এর সমস্ত বিষয়বস্তু, বৈশিষ্ট্য এবং কার্যকারিতা আমাদের মালিকানাধীন এবং আন্তর্জাতিক কপিরাইট, ট্রেডমার্ক এবং অন্যান্য বুদ্ধিবৃত্তিক সম্পত্তি আইন দ্বারা সুরক্ষিত।',
    'hi': 'MedDeutsch की सभी सामग्री, सुविधाएं और कार्यक्षमता हमारे स्वामित्व में है और अंतर्राष्ट्रीय कॉपीराइट, ट्रेडमार्क और अन्य बौद्धिक संपदा कानूनों द्वारा संरक्षित है।',
    'ur': 'MedDeutsch کا تمام مواد، خصوصیات اور فعالیت ہماری ملکیت ہے اور بین الاقوامی کاپی رائٹ، ٹریڈ مارک اور دیگر دانشورانہ املاک کے قوانین کے ذریعے محفوظ ہے۔',
    'tr': 'MedDeutsch\'un tüm içeriği, özellikleri ve işlevselliği bize aittir ve uluslararası telif hakkı, ticari marka ve diğer fikri mülkiyet yasaları tarafından korunmaktadır.',
  });

  String get termsContactContent => _translate({
    'en': 'For questions about these Terms, contact us at:\n\nEmail: support@meddeutsch.app',
    'bn': 'এই শর্তাবলী সম্পর্কে প্রশ্নের জন্য, আমাদের সাথে যোগাযোগ করুন:\n\nইমেইল: support@meddeutsch.app',
    'hi': 'इन शर्तों के बारे में प्रश्नों के लिए, हमसे संपर्क करें:\n\nईमेल: support@meddeutsch.app',
    'ur': 'ان شرائط کے بارے میں سوالات کے لیے، ہم سے رابطہ کریں:\n\nای میل: support@meddeutsch.app',
    'tr': 'Bu Şartlar hakkında sorularınız için bizimle iletişime geçin:\n\nE-posta: support@meddeutsch.app',
  });

  // ============== SUBSCRIPTION SCREEN ==============

  String get medDeutschPremium => _translate({
    'en': 'MedDeutsch Premium',
    'bn': 'মেডডয়েচ প্রিমিয়াম',
    'hi': 'मेडड्यूश प्रीमियम',
    'ur': 'میڈ ڈوئچ پریمیم',
    'tr': 'MedDeutsch Premium',
  });

  String get unlockYourPotential => _translate({
    'en': 'Unlock your full potential',
    'bn': 'আপনার সম্পূর্ণ সম্ভাবনা আনলক করুন',
    'hi': 'अपनी पूरी क्षमता को अनलॉक करें',
    'ur': 'اپنی مکمل صلاحیت کو کھولیں',
    'tr': 'Tam potansiyelinizi açığa çıkarın',
  });

  String get unlimitedAccess => _translate({
    'en': 'Unlimited Access',
    'bn': 'সীমাহীন অ্যাক্সেস',
    'hi': 'असीमित पहुंच',
    'ur': 'لامحدود رسائی',
    'tr': 'Sınırsız Erişim',
  });

  String get unlockAllLessons => _translate({
    'en': 'Unlock all 55 lessons',
    'bn': 'সব ৫৫টি পাঠ আনলক করুন',
    'hi': 'सभी 55 पाठ अनलॉक करें',
    'ur': 'تمام 55 اسباق ان لاک کریں',
    'tr': 'Tüm 55 dersin kilidini açın',
  });

  String get allMockTests => _translate({
    'en': 'All Mock Tests',
    'bn': 'সব মক টেস্ট',
    'hi': 'सभी मॉक टेस्ट',
    'ur': 'تمام ماک ٹیسٹ',
    'tr': 'Tüm Deneme Sınavları',
  });

  String get fspKpPreparation => _translate({
    'en': 'FSP & KP exam preparation',
    'bn': 'FSP এবং KP পরীক্ষার প্রস্তুতি',
    'hi': 'FSP और KP परीक्षा की तैयारी',
    'ur': 'FSP اور KP امتحان کی تیاری',
    'tr': 'FSP ve KP sınav hazırlığı',
  });

  String get audioLessons => _translate({
    'en': 'Audio Lessons',
    'bn': 'অডিও পাঠ',
    'hi': 'ऑडियो पाठ',
    'ur': 'آڈیو اسباق',
    'tr': 'Sesli Dersler',
  });

  String get professionalPronunciation => _translate({
    'en': 'Professional pronunciation',
    'bn': 'পেশাদার উচ্চারণ',
    'hi': 'पेशेवर उच्चारण',
    'ur': 'پیشہ ورانہ تلفظ',
    'tr': 'Profesyonel telaffuz',
  });

  String get offlineModeFeature => _translate({
    'en': 'Offline Mode',
    'bn': 'অফলাইন মোড',
    'hi': 'ऑफलाइन मोड',
    'ur': 'آف لائن موڈ',
    'tr': 'Çevrimdışı Mod',
  });

  String get learnWithoutInternet => _translate({
    'en': 'Learn without internet',
    'bn': 'ইন্টারনেট ছাড়া শিখুন',
    'hi': 'इंटरनेट के बिना सीखें',
    'ur': 'انٹرنیٹ کے بغیر سیکھیں',
    'tr': 'İnternetsiz öğrenin',
  });

  String get noAds => _translate({
    'en': 'No Ads',
    'bn': 'বিজ্ঞাপন নেই',
    'hi': 'कोई विज्ञापन नहीं',
    'ur': 'کوئی اشتہارات نہیں',
    'tr': 'Reklam Yok',
  });

  String get adFreeLearning => _translate({
    'en': 'Ad-free learning',
    'bn': 'বিজ্ঞাপন-মুক্ত শেখা',
    'hi': 'विज्ञापन-मुक्त सीखना',
    'ur': 'اشتہارات کے بغیر سیکھنا',
    'tr': 'Reklamsız öğrenme',
  });

  String get becomePremiumNow => _translate({
    'en': 'Become Premium Now',
    'bn': 'এখনই প্রিমিয়াম হোন',
    'hi': 'अभी प्रीमियम बनें',
    'ur': 'ابھی پریمیم بنیں',
    'tr': 'Şimdi Premium Olun',
  });

  String get autoRenewal => _translate({
    'en': 'Auto-renewal. Cancel anytime.',
    'bn': 'স্বয়ংক্রিয় নবায়ন। যেকোনো সময় বাতিল করুন।',
    'hi': 'स्वचालित नवीनीकरण। कभी भी रद्द करें।',
    'ur': 'خودکار تجدید۔ کسی بھی وقت منسوخ کریں۔',
    'tr': 'Otomatik yenileme. İstediğiniz zaman iptal edin.',
  });

  String get termsShort => _translate({
    'en': 'Terms',
    'bn': 'শর্তাবলী',
    'hi': 'शर्तें',
    'ur': 'شرائط',
    'tr': 'Şartlar',
  });

  String get privacy => _translate({
    'en': 'Privacy',
    'bn': 'গোপনীয়তা',
    'hi': 'गोपनीयता',
    'ur': 'رازداری',
    'tr': 'Gizlilik',
  });

  String get restore => _translate({
    'en': 'Restore',
    'bn': 'পুনরুদ্ধার',
    'hi': 'पुनर्स्थापित करें',
    'ur': 'بحال کریں',
    'tr': 'Geri Yükle',
  });

  String get popular => _translate({
    'en': 'Popular',
    'bn': 'জনপ্রিয়',
    'hi': 'लोकप्रिय',
    'ur': 'مقبول',
    'tr': 'Popüler',
  });

  // Subscription Success Dialog
  String get welcomePremium => _translate({
    'en': 'Welcome Premium!',
    'bn': 'স্বাগতম প্রিমিয়াম!',
    'hi': 'प्रीमियम में आपका स्वागत है!',
    'ur': 'پریمیم میں خوش آمدید!',
    'tr': 'Premium\'a Hoş Geldiniz!',
  });

  String get subscriptionActivated => _translate({
    'en': 'Your subscription has been successfully activated. Enjoy all Premium features!',
    'bn': 'আপনার সাবস্ক্রিপশন সফলভাবে সক্রিয় হয়েছে। সব প্রিমিয়াম সুবিধা উপভোগ করুন!',
    'hi': 'आपकी सदस्यता सफलतापूर्वक सक्रिय हो गई है। सभी प्रीमियम सुविधाओं का आनंद लें!',
    'ur': 'آپ کی سبسکرپشن کامیابی سے فعال ہو گئی ہے۔ تمام پریمیم سہولیات سے لطف اٹھائیں!',
    'tr': 'Aboneliğiniz başarıyla etkinleştirildi. Tüm Premium özelliklerinin keyfini çıkarın!',
  });

  String get letsGo => _translate({
    'en': "Let's Go!",
    'bn': 'চলুন শুরু করি!',
    'hi': 'चलो शुरू करें!',
    'ur': 'چلو شروع کریں!',
    'tr': 'Hadi Başlayalım!',
  });

  // Restore Dialog
  String get purchasesRestored => _translate({
    'en': 'Purchases Restored!',
    'bn': 'কেনাকাটা পুনরুদ্ধার হয়েছে!',
    'hi': 'खरीदारी पुनर्स्थापित!',
    'ur': 'خریداریاں بحال ہو گئیں!',
    'tr': 'Satın Almalar Geri Yüklendi!',
  });

  String get premiumRestored => _translate({
    'en': 'Your Premium membership has been restored.',
    'bn': 'আপনার প্রিমিয়াম সদস্যতা পুনরুদ্ধার হয়েছে।',
    'hi': 'आपकी प्रीमियम सदस्यता पुनर्स्थापित हो गई है।',
    'ur': 'آپ کی پریمیم رکنیت بحال ہو گئی ہے۔',
    'tr': 'Premium üyeliğiniz geri yüklendi.',
  });

  String get ok => _translate({
    'en': 'OK',
    'bn': 'ঠিক আছে',
    'hi': 'ठीक है',
    'ur': 'ٹھیک ہے',
    'tr': 'Tamam',
  });

  String get error => _translate({
    'en': 'Error',
    'bn': 'ত্রুটি',
    'hi': 'त्रुटि',
    'ur': 'خرابی',
    'tr': 'Hata',
  });

  String _translate(Map<String, String> translations) {
    return translations[languageCode] ?? translations['en']!;
  }
}
