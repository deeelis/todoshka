import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoshka/utils/logger.dart';

import 'core/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    AppLogger.disable();
  }
  AppLogger.info("App started");
  runApp(
    const ToDoApp(),
  );
}
