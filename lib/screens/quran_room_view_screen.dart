import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class QuranRoomViewScreen extends StatelessWidget {
  final String groupName;
  final String khatmaName;
  final String userName;

  const QuranRoomViewScreen({
    Key? key,
    required this.groupName,
    required this.khatmaName,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$groupName - $khatmaName'),
      ),
      body: StreamBuilder(
        stream: FirebaseService().getRoomStream(groupName, khatmaName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // TODO: Display room data and reading progress
          return const Center(child: Text('Room View Coming Soon'));
        },
      ),
    );
  }
}
