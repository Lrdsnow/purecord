// debug.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

Future<void> log(dynamic text) async {
  // Get the documents directory
  final directory = await getApplicationDocumentsDirectory();
  final logFilePath = File('${directory.path}/logs.txt');

  // Format the date and time
  final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final timestamp = dateFormatter.format(DateTime.now());

  // Convert the input to a string
  final logContent = text is List ? text.map((e) => e.toString()).join(' ') : text.toString();
  final logEntry = '$timestamp: $logContent\n';

  // Print the log entry to console
  print(logContent);

  // Append the log entry to the file
  try {
    await logFilePath.writeAsString(logEntry, mode: FileMode.append);
  } catch (e) {
    print('Failed to write log: $e');
  }
}
