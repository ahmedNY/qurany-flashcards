import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class AudioService {
  static const String BASE_URL = 'https://everyayah.com/data/Hudhaify_32kbps/';

  static Future<String> getAudioPath(String surah, String ayah) async {
    final fileName = '${surah.padLeft(3, '0')}${ayah.padLeft(3, '0')}.mp3';
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/audio_files_Hudhaify/$fileName';

    // If file doesn't exist, try to download it
    if (!await File(filePath).exists()) {
      try {
        final response = await http.get(Uri.parse('$BASE_URL$fileName'));
        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes);
          print('Downloaded audio file: $fileName');
        } else {
          print('Failed to download audio: ${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading audio: $e');
      }
    }

    return filePath;
  }

  static Future<bool> isAudioFileExists(String surah, String ayah) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${surah.padLeft(3, '0')}${ayah.padLeft(3, '0')}.mp3';
    final filePath = '${dir.path}/audio_files_Hudhaify/$fileName';
    return File(filePath).exists();
  }
}
