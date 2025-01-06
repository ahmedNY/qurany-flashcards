import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false;

  void _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) return;

    setState(() => _isSending = true);

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'quran.flashcards.dev@gmail.com',
      queryParameters: {
        'subject': 'Qurany Cards Pro Feedback',
        'body': _feedbackController.text,
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        Navigator.of(context).pop(); // Close dialog after sending
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending feedback')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Help us improve by sharing your thoughts:'),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Your feedback here...',
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSending ? null : _sendFeedback,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF417D7A),
          ),
          child: _isSending
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send'),
        ),
      ],
    );
  }
}
