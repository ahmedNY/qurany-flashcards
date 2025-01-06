import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../translations.dart' as translations;

class TutorialPage extends StatefulWidget {
  final AppLanguage selectedLanguage;

  const TutorialPage({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translations.getTranslation('app_tutorial_title',
                            language: widget.selectedLanguage),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4141),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Video placeholder
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/tutorial.gif',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildFeatureSection(
                        icon: Icons.menu_book,
                        title: 'browse_pages_title',
                        description: 'browse_pages_description',
                      ),
                      _buildFeatureSection(
                        icon: Icons.record_voice_over,
                        title: 'listen_memorize_title',
                        description: 'listen_memorize_description',
                      ),
                      _buildFeatureSection(
                        icon: Icons.repeat,
                        title: 'srs_title',
                        description: _buildSRSDescription(),
                      ),
                      _buildFeatureSection(
                        icon: Icons.auto_awesome,
                        title: 'special_features_title',
                        description: _buildSpecialFeaturesList(),
                      ),
                      _buildFeatureSection(
                        icon: Icons.flag,
                        title: 'review_system_title',
                        description: 'review_system_description',
                      ),
                      _buildFeatureSection(
                        icon: Icons.celebration,
                        title: 'achievements_title',
                        description: 'achievements_description',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF417D7A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('has_seen_tutorial', true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            toolbarHeight: kToolbarHeight,
                            title: const Text('Qurany'),
                          ),
                          body: SimpleList(
                            selectedLanguage: widget.selectedLanguage,
                            isGroupReading: false,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required IconData icon,
    required String title,
    required dynamic description,
  }) {
    bool isRTL = widget.selectedLanguage == AppLanguage.arabic ||
        widget.selectedLanguage == AppLanguage.urdu;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFF417D7A).withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF417D7A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: const Color(0xFF417D7A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      translations.getTranslation(title,
                              language: widget.selectedLanguage) ??
                          title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B4141),
                      ),
                      textDirection:
                          isRTL ? TextDirection.rtl : TextDirection.ltr,
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (description is String)
                Text(
                  translations.getTranslation(description,
                          language: widget.selectedLanguage) ??
                      description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                )
              else
                description,
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for SRS description
  Widget _buildSRSDescription() {
    bool isRTL = widget.selectedLanguage == AppLanguage.arabic ||
        widget.selectedLanguage == AppLanguage.urdu;

    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          translations.getTranslation('srs_intro',
              language: widget.selectedLanguage),
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),
        ...[
          // List of levels
          [
            '0',
            '5 ${translations.getTranslation('minutes', language: widget.selectedLanguage)}'
          ],
          [
            '1',
            '30 ${translations.getTranslation('minutes', language: widget.selectedLanguage)}'
          ],
          [
            '2',
            '2 ${translations.getTranslation('hours', language: widget.selectedLanguage)}'
          ],
          [
            '3',
            '8 ${translations.getTranslation('hours', language: widget.selectedLanguage)}'
          ],
          [
            '4',
            '24 ${translations.getTranslation('hours', language: widget.selectedLanguage)}'
          ],
          [
            '5',
            '3 ${translations.getTranslation('days', language: widget.selectedLanguage)}'
          ],
          [
            '6',
            '7 ${translations.getTranslation('days', language: widget.selectedLanguage)}'
          ],
          [
            '10',
            '1 ${translations.getTranslation('year', language: widget.selectedLanguage)}'
          ],
        ]
            .map((level) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    textDirection:
                        isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text(
                        '• ${translations.getTranslation('level', language: widget.selectedLanguage)} ${level[0]}: ',
                        textDirection:
                            isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      Text(
                        level[1],
                        textDirection:
                            isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ))
            .toList(),
        const SizedBox(height: 12),
        Text(
          translations.getTranslation('srs_explanation',
                  language: widget.selectedLanguage) ??
              '• Correct answers advance the level\n• Incorrect answers return to previous level\n• This scientifically-proven method ensures long-term retention.',
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  // Helper method for special features list
  Widget _buildSpecialFeaturesList() {
    bool isRTL = widget.selectedLanguage == AppLanguage.arabic ||
        widget.selectedLanguage == AppLanguage.urdu;

    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ...['autoplay', 'first_word', 'progress', 'priority']
            .map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Text('• ',
                        textDirection:
                            isRTL ? TextDirection.rtl : TextDirection.ltr),
                    Expanded(
                      child: Text(
                        translations.getTranslation('feature_$feature',
                            language: widget.selectedLanguage),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textDirection:
                            isRTL ? TextDirection.rtl : TextDirection.ltr,
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
