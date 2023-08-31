import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sentry_flutter/sentry_flutter.dart';

class Misc {
  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  static void unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> clearFiles(String folder, [Set<String> newRelFilePaths = const <String>{}]) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$folder';
    final pathDirectory = await Directory(path).create(recursive: true);
    final filePaths = (pathDirectory.listSync()).map((e) => e.path).toSet();
    final newFilePaths = newRelFilePaths.map((e) => p.join(directory.path, e)).toSet();

    for (var filePath in filePaths.difference(newFilePaths)) {
      await File(filePath).delete();
    }
  }
}
