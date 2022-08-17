import 'package:flutter/material.dart';

class HabitTracker extends StatelessWidget {
  const HabitTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Habit Tracker")),
        backgroundColor: Colors.grey,
      ),
      body: Center(child: Text("Habit-tracker")),
    );
  }
}
