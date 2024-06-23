import 'package:flutter/material.dart';

import '../../themes/dark_theme.dart';
import '../../themes/light_theme.dart';
import '../../ui/screens/home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,
    );
  }
}
