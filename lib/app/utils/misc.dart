import 'package:flutter/material.dart';
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
}
