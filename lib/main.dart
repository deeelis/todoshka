import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoshka/core/router.dart';
import 'package:todoshka/themes/dark_theme.dart';
import 'package:todoshka/themes/light_theme.dart';
import 'package:todoshka/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    AppLogger.disable();
  }
  AppLogger.info("App started");
  runApp(
    const ProviderScope(
      child: ToDoApp(),
    ),
  );
}

class ToDoApp extends ConsumerWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
      ],
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.goRouter,
    );
  }
}
