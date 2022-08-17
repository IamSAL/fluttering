import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final Function changeTheme;
  final ThemeMode themeMode;
  const ThemeSwitcher(
      {Key? key, required this.changeTheme, required this.themeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: themeMode == ThemeMode.dark,
      activeColor: Color(0xFF6200EE),
      onChanged: (bool value) {
        changeTheme(
            themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
      },
    );
  }
}
