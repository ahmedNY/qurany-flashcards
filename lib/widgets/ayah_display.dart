import 'package:flutter/material.dart';

class AyahDisplay extends StatelessWidget {
  final Map<String, dynamic> ayahData;
  final bool isFullyRevealed;
  final bool isPartiallyRevealed;
  final bool showFirstWordOnly;
  final VoidCallback onTap;

  const AyahDisplay({
    Key? key,
    required this.ayahData,
    required this.isFullyRevealed,
    required this.isPartiallyRevealed,
    required this.showFirstWordOnly,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            ayahData['verse'],
            style: const TextStyle(fontSize: 24),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
