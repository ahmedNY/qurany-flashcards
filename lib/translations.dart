import '../main.dart';

String getTranslation(String key, {required AppLanguage language}) {
  final languageCode = _getLanguageCode(language);
  return translations[languageCode]?[key] ?? translations['en']?[key] ?? key;
}

String _getLanguageCode(AppLanguage language) {
  switch (language) {
    case AppLanguage.arabic:
      return 'ar';
    case AppLanguage.spanish:
      return 'es';
    case AppLanguage.hindi:
      return 'hi';
    case AppLanguage.urdu:
      return 'ur';
    case AppLanguage.indonesian:
      return 'id';
    case AppLanguage.russian:
      return 'ru';
    case AppLanguage.chinese:
      return 'zh';
    case AppLanguage.turkish:
      return 'tr';
    case AppLanguage.english:
      return 'en';
  }
}

Map<String, Map<String, String>> translations = {
  'en': {
    'app_tutorial_title': 'How to Use Qurany',
    'browse_pages_title': 'Browse Pages',
    'browse_pages_description':
        'Select any surah and page to start memorizing.',
    'listen_memorize_title': 'Listen & Memorize',
    'listen_memorize_description':
        'Tap to reveal ayahs and listen to recitation.',
    'special_features_title': 'Special Features',
    'feature_autoplay': 'Auto-play for continuous recitation',
    'feature_first_word': 'First word mode for advanced memorization',
    'feature_progress': 'Progress tracking and statistics',
    'feature_priority': 'Overdue reviews are prioritized automatically',
    'review_system_title': 'Review System',
    'review_system_description':
        'Pages with review items are marked with a flag.\nReview counts show how many ayahs need attention.',
    'achievements_title': 'Achievements',
    'achievements_description':
        'Celebrate your progress with animations and sounds in kids mode!',
    'srs_title': 'Smart Review System (SRS)',
    'srs_intro': 'Uses spaced repetition to optimize memorization:',
    'srs_levels': 'Review Intervals:',
    'level': 'Level',
    'minutes': 'minutes',
    'hours': 'hours',
    'days': 'days',
    'year': 'year',
    'srs_explanation':
        '• Correct answers advance the level\n• Incorrect answers return to previous level\n• This scientifically-proven method ensures long-term retention.',
  },
  'ar': {
    'app_tutorial_title': 'كيفية استخدام قرآني',
    'browse_pages_title': 'تصفح الصفحات',
    'browse_pages_description': 'اختر أي سورة وصفحة للبدء في الحفظ.',
    'listen_memorize_title': 'استمع واحفظ',
    'listen_memorize_description': 'انقر لكشف الآيات والاستماع إلى التلاوة.',
    'special_features_title': 'مميزات خاصة',
    'feature_autoplay': 'تشغيل تلقائي للتلاوة المستمرة',
    'feature_first_word': 'وضع الكلمة الأولى للحفظ المتقدم',
    'feature_progress': 'تتبع التقدم والإحصائيات',
    'feature_priority': 'تُعطى الأولوية للمراجعات المتأخرة تلقائياً',
    'review_system_title': 'نظام المراجعة',
    'review_system_description':
        'الصفحات التي تحتاج إلى مراجعة معلمة بعلامة.\nتظهر أعداد المراجعات كم آية تحتاج إلى اهتمام.',
    'achievements_title': 'الإنجازات',
    'achievements_description':
        'احتفل بتقدمك مع الرسوم المتحركة والأصوات في وضع الأطفال!',
    'srs_title': 'نظام المراجعة الذكي',
    'srs_intro': 'يستخدم التكرار المتباعد لتحسين الحفظ:',
    'srs_levels': 'فترات المراجعة:',
    'level': 'المستوى',
    'minutes': 'دقائق',
    'hours': 'ساعات',
    'days': 'أيام',
    'year': 'سنة',
    'srs_explanation':
        '• الإجابات الصحيحة تتقدم المستوى\n• الإجابات الخاطئة تعود إلى المستوى السابق\n• هذه الطريقة المثبتة علمياً تضمن الحفظ طويل المدى.',
  },
  'es': {
    'app_tutorial_title': 'Cómo usar Qurany',
    'browse_pages_title': 'Explorar Páginas',
    'browse_pages_description':
        'Seleccione cualquier sura y página para comenzar a memorizar.',
    'listen_memorize_title': 'Escuchar y Memorizar',
    'listen_memorize_description':
        'Toque para revelar aleyas y escuchar la recitación.',
    'special_features_title': 'Características Especiales',
    'feature_autoplay': 'Reproducción automática para recitación continua',
    'feature_first_word': 'Modo primera palabra para memorización avanzada',
    'feature_progress': 'Seguimiento de progreso y estadísticas',
    'feature_priority': 'Las revisiones atrasadas se priorizan automáticamente',
    'review_system_title': 'Sistema de Repaso',
    'review_system_description':
        'Las páginas con elementos para repasar están marcadas con una bandera.\nLos contadores muestran cuántas aleyas necesitan atención.',
    'achievements_title': 'Logros',
    'achievements_description':
        '¡Celebra tu progreso con animaciones y sonidos en modo infantil!',
    'srs_title': 'Sistema de Repaso Inteligente (SRS)',
    'srs_intro': 'Utiliza repetición espaciada para optimizar la memorización:',
    'srs_levels': 'Intervalos de Repaso:',
    'level': 'Nivel',
    'minutes': 'minutos',
    'hours': 'horas',
    'days': 'días',
    'year': 'año',
    'srs_explanation':
        '• Las respuestas correctas avanzan de nivel\n• Las respuestas incorrectas regresan al nivel anterior\n• Este método científicamente probado asegura la retención a largo plazo.',
  },
  'hi': {
    'app_tutorial_title': 'क़ुरानी का उपयोग कैसे करें',
    'browse_pages_title': 'पृष्ठ ब्राउज़ करें',
    'browse_pages_description': 'याद करने के लिए कोई भी सूरह और पृष्ठ चुनें।',
    'listen_memorize_title': 'सुनें और याद करें',
    'listen_memorize_description':
        'आयतें देखने और तिलावत सुनने के लिए टैप करें।',
    'special_features_title': 'विशेष सुविधाएं',
    'feature_autoplay': 'निरंतर तिलावत के लिए ऑटो-प्ले',
    'feature_first_word': 'उन्नत याद करने के लिए पहला शब्द मोड',
    'feature_progress': 'प्रगति ट्रैकिंग और आंकड़े',
    'feature_priority':
        'देरी से समीक्षाओं को स्वचालित रूप से प्राथमिकता दी जाती है',
    'review_system_title': 'समीक्षा प्रणाली',
    'review_system_description':
        'समीक्षा वाले पृष्ठों को झंडे से चिह्नित किया गया है।\nसमीक्षा गणना दिखाती है कि कितनी आयतों को ध्यान की आवश्यकता है।',
    'achievements_title': 'उपलब्धियां',
    'achievements_description':
        'बच्चों के मोड में एनिमेशन और ध्वनियों के साथ अपनी प्रगति का जश्न मनाएं!',
    'srs_title': 'स्मार्ट समीक्षा प्रणाली (SRS)',
    'srs_intro':
        'याद करने को अनुकूलित करने के लिए स्पेस्ड रिपिटीशन का उपयोग करता है:',
    'srs_levels': 'समीक्षा अंतराल:',
    'level': 'स्तर',
    'minutes': 'मिनट',
    'hours': 'घंटे',
    'days': 'दिन',
    'year': 'साल',
    'srs_explanation':
        '• सही उत्तर स्तर बढ़ाते हैं\n• गलत उत्तर पिछले स्तर पर वापस जाते हैं\n• यह वैज्ञानिक रूप से सिद्ध विधि दीर्घकालिक धारण सुनिश्चित करती है।',
  },
  'ur': {
    'app_tutorial_title': 'قرآنی کو کیسے استعمال کریں',
    'browse_pages_title': 'صفحات براؤز کریں',
    'browse_pages_description':
        'حفظ کرنے کے لیے کوئی بھی سورت اور صفحہ منتخب کریں۔',
    'listen_memorize_title': 'سنیں اور حفظ کریں',
    'listen_memorize_description':
        'آیات دیکھنے اور تلاوت سننے کے لیے ٹیپ کریں۔',
    'special_features_title': 'خصوصی خصوصیات',
    'feature_autoplay': 'مسلسل تلاوت کے لیے آٹو پلے',
    'feature_first_word': 'ایڈوانسڈ حفظ کے لیے پہلا لفظ موڈ',
    'feature_progress': 'پیش رفت کی ٹریکنگ اور اعدادوشمار',
    'feature_priority': 'تاخیر شدہ نظرثانی کو خود بخود ترجیح دی جاتی ہے',
    'review_system_title': 'نظرثانی کا نظام',
    'review_system_description':
        'نظرثانی والے صفحات کو پرچم سے نشان زد کیا گیا ہے۔\nنظرثانی کی تعداد دکھاتی ہے کہ کتنی آیات کو توجہ کی ضرورت ہے۔',
    'achievements_title': 'کامیابیاں',
    'achievements_description':
        'بچوں کے موڈ میں اینیمیشن اور آوازوں کے ساتھ اپنی پیش رفت کا جشن منائیں!',
    'srs_title': 'سمارٹ نظرثانی نظام (SRS)',
    'srs_intro': 'حفظ کو بہتر بنانے کے لیے وقفہ دار دہرائی کا استعمال کرتا ہے:',
    'srs_levels': 'نظرثانی کے وقفے:',
    'level': 'سطح',
    'minutes': 'منٹ',
    'hours': 'گھنٹے',
    'days': 'دن',
    'year': 'سال',
    'srs_explanation':
        '• درست جوابات سطح کو آگے بڑھاتے ہیں\n• غلط جوابات پچھلی سطح پر واپس جاتے ہیں\n• یہ سائنسی طور پر ثابت شدہ طریقہ طویل مدتی یاد داشت کو یقینی بناتا ہے۔',
  },
  'id': {
    'app_tutorial_title': 'Cara Menggunakan Qurany',
    'browse_pages_title': 'Jelajahi Halaman',
    'browse_pages_description':
        'Pilih surah dan halaman untuk mulai menghafal.',
    'listen_memorize_title': 'Dengar & Hafal',
    'listen_memorize_description':
        'Ketuk untuk menampilkan ayat dan mendengarkan bacaan.',
    'special_features_title': 'Fitur Khusus',
    'feature_autoplay': 'Putar otomatis untuk bacaan berkelanjutan',
    'feature_first_word': 'Mode kata pertama untuk hafalan tingkat lanjut',
    'feature_progress': 'Pelacakan kemajuan dan statistik',
    'feature_priority': 'Review yang terlambat diprioritaskan secara otomatis',
    'review_system_title': 'Sistem Review',
    'review_system_description':
        'Halaman dengan item review ditandai dengan bendera.\nJumlah review menunjukkan berapa ayat yang perlu perhatian.',
    'achievements_title': 'Pencapaian',
    'achievements_description':
        'Rayakan kemajuan Anda dengan animasi dan suara dalam mode anak-anak!',
    'srs_title': 'Sistem Review Pintar (SRS)',
    'srs_intro':
        'Menggunakan pengulangan berspasi untuk mengoptimalkan hafalan:',
    'srs_levels': 'Interval Review:',
    'level': 'Level',
    'minutes': 'menit',
    'hours': 'jam',
    'days': 'hari',
    'year': 'tahun',
    'srs_explanation':
        '• Jawaban benar meningkatkan level\n• Jawaban salah kembali ke level sebelumnya\n• Metode yang terbukti secara ilmiah ini menjamin retensi jangka panjang.',
  },
  'ru': {
    'app_tutorial_title': 'Как использовать Qurany',
    'browse_pages_title': 'Просмотр страниц',
    'browse_pages_description':
        'Выберите любую суру и страницу, чтобы начать запоминание.',
    'listen_memorize_title': 'Слушайте и запоминайте',
    'listen_memorize_description':
        'Нажмите, чтобы открыть аяты и послушать чтение.',
    'special_features_title': 'Особые функции',
    'feature_autoplay': 'Автовоспроизведение для непрерывного чтения',
    'feature_first_word': 'Режим первого слова для продвинутого запоминания',
    'feature_progress': 'Отслеживание прогресса и статистика',
    'feature_priority':
        'Просроченные повторения автоматически приоритизируются',
    'review_system_title': 'Система повторения',
    'review_system_description':
        'Страницы с элементами для повторения отмечены флажком.\nСчетчики показывают, сколько аятов требуют внимания.',
    'achievements_title': 'Достижения',
    'achievements_description':
        'Празднуйте свой прогресс с анимацией и звуками в детском режиме!',
    'srs_title': 'Умная система повторения (SRS)',
    'srs_intro':
        'Использует интервальное повторение для оптимизации запоминания:',
    'srs_levels': 'Интервалы повторения:',
    'level': 'Уровень',
    'minutes': 'минут',
    'hours': 'часов',
    'days': 'дней',
    'year': 'год',
    'srs_explanation':
        '• Правильные ответы повышают уровень\n• Неправильные ответы возвращают на предыдущий уровень\n• Этот научно доказанный метод обеспечивает долгосрочное запоминание.',
  },
  'zh': {
    'app_tutorial_title': '如何使用古兰经助手',
    'browse_pages_title': '浏览页面',
    'browse_pages_description': '选择任何章节和页面开始记忆。',
    'listen_memorize_title': '听诵与记忆',
    'listen_memorize_description': '点击显示经文并聆听诵读。',
    'special_features_title': '特殊功能',
    'feature_autoplay': '连续诵读自动播放',
    'feature_first_word': '首词模式用于高级记忆',
    'feature_progress': '进度跟踪和统计',
    'feature_priority': '自动优先处理逾期复习',
    'review_system_title': '复习系统',
    'review_system_description': '需要复习的页面会标记旗帜。\n复习计数显示需要关注的经文数量。',
    'achievements_title': '成就',
    'achievements_description': '在儿童模式下用动画和声音庆祝您的进步！',
    'srs_title': '智能复习系统 (SRS)',
    'srs_intro': '使用间隔重复优化记忆：',
    'srs_levels': '复习间隔：',
    'level': '等级',
    'minutes': '分钟',
    'hours': '小时',
    'days': '天',
    'year': '年',
    'srs_explanation': '• 正确答案提升等级\n• 错误答案返回上一等级\n• 这种科学验证的方法确保长期记忆。',
  },
  'tr': {
    'app_tutorial_title': 'Qurany Nasıl Kullanılır',
    'browse_pages_title': 'Sayfaları Görüntüle',
    'browse_pages_description':
        'Ezberlemeye başlamak için herhangi bir sure ve sayfa seçin.',
    'listen_memorize_title': 'Dinle ve Ezberle',
    'listen_memorize_description':
        'Ayetleri görmek ve tilaveti dinlemek için dokunun.',
    'special_features_title': 'Özel Özellikler',
    'feature_autoplay': 'Sürekli tilavet için otomatik oynatma',
    'feature_first_word': 'İleri düzey ezberleme için ilk kelime modu',
    'feature_progress': 'İlerleme takibi ve istatistikler',
    'feature_priority': 'Gecikmiş tekrarlar otomatik olarak önceliklendirilir',
    'review_system_title': 'Tekrar Sistemi',
    'review_system_description':
        'Tekrar gereken sayfalar bayrakla işaretlenir.\nTekrar sayıları kaç ayetin dikkat gerektirdiğini gösterir.',
    'achievements_title': 'Başarılar',
    'achievements_description':
        'Çocuk modunda animasyonlar ve seslerle ilerlemenizi kutlayın!',
    'srs_title': 'Akıllı Tekrar Sistemi (SRS)',
    'srs_intro': 'Ezberlemeyi optimize etmek için aralıklı tekrar kullanır:',
    'srs_levels': 'Tekrar Aralıkları:',
    'level': 'Seviye',
    'minutes': 'dakika',
    'hours': 'saat',
    'days': 'gün',
    'year': 'yıl',
    'srs_explanation':
        '• Doğru cevaplar seviyeyi yükseltir\n• Yanlış cevaplar önceki seviyeye döner\n• Bu bilimsel olarak kanıtlanmış yöntem uzun süreli hafızayı garantiler.',
  },
  // Add other languages as needed
};
