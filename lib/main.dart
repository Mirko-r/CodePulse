import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'UI/pages/home_page.dart';
import 'resources/theme.dart';

void main() {
  runApp(ProviderScope(child: const CodePulseApp()));
}

class CodePulseApp extends StatelessWidget {
  const CodePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodePulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
