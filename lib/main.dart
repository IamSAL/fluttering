import 'package:flutter/material.dart';
import 'demo_menu.dart';
import 'demos/habit_tracker/habit_tracker.dart';
import 'demos/wordpair_generator/wordpair_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State {
  ThemeMode _themeMode = ThemeMode.light;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttering',
      theme: ThemeData(primaryColor: Colors.purple[900]),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            DemoMenu(changeTheme: changeTheme, themeMode: _themeMode),
        '/habit-tracker': (context) => HabitTracker(),
        '/wordpair-gen': (context) => WordPairGenerator(),
      },
    );
  }
}
