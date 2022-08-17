import 'package:flutter/material.dart';
import 'components/theme_switcher.dart';

class DemoMenu extends StatelessWidget {
  final Function changeTheme;
  final ThemeMode themeMode;
  const DemoMenu(
      {super.key, required this.changeTheme, required this.themeMode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: const Text("Select a demo.")),
        actions: [
          ThemeSwitcher(changeTheme: changeTheme, themeMode: themeMode)
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Center(child: Demos()),
    );
  }
}

class Demos extends StatelessWidget {
  const Demos({Key? key}) : super(key: key);

  Widget _buildMenuItem(
      String route, String title, Color color, BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 10))),
        child: InkWell(
          splashColor: color.withAlpha(50),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          child: SizedBox(
            width: 200,
            height: 200,
            child: Center(
                child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 17),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      crossAxisCount: 2,
      children: <Widget>[
        _buildMenuItem('/habit-tracker', 'Habit Tracker', Colors.grey, context),
        _buildMenuItem(
            '/wordpair-gen', 'Wordpair Generator', Colors.purple, context),
      ],
    );
  }
}
