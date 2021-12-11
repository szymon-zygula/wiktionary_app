import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'article_screen.dart';
import 'language_screen.dart';
import 'search_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp() : super(key: const Key(""));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: SafeArea(
          child: LanguageScreen('en', 'spaghetti'),
        ),
      ),
    );
  }
}
