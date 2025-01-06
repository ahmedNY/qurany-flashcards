import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../pages/tutorial_page.dart';

class ModeSelectionPage extends StatefulWidget {
  final AppLanguage selectedLanguage;

  const ModeSelectionPage({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  State<ModeSelectionPage> createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Learning Mode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B4141),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/modes.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildModeButton(
                context,
                title: 'Adult Mode',
                description:
                    'Standard learning experience with focus on memorization and review.',
                icon: Icons.person,
                isKidsMode: false,
              ),
              const SizedBox(height: 20),
              _buildModeButton(
                context,
                title: 'Children Mode',
                description:
                    'Interactive learning with sounds, animations, and celebrations.',
                icon: Icons.child_care,
                isKidsMode: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isKidsMode,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF417D7A),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF417D7A), width: 2),
        ),
      ),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('kids_mode', isKidsMode);
        await prefs.setBool('has_selected_mode', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialPage(
              selectedLanguage: widget.selectedLanguage,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B4141),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
