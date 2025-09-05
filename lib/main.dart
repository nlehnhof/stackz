import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stackz/app_theme.dart';
import 'package:stackz/pages/home_page.dart';
import 'package:stackz/providers/project_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'Stackz',
        theme: AppTheme.themeData,
        home: HomePage(),
      ),
    );
  }
}
