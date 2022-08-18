import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/demos/habit_tracker/util/add_habit.dart';
import 'package:fluttering/demos/habit_tracker/util/habit_tile.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({Key? key}) : super(key: key);

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  List habitList = [
    //[habitName,habitStarted,timeSpent(sec),timeGoal(min)]
    ['Excercise', false, 0, 1],
    ['Read', false, 2, 5],
    ['Code', false, 0, 10],
    ['Meditate', false, 0, 2],
    ['Scroll', false, 2, 15],
    ['Run', false, 56, 17],
    ['Swimming', false, 0, 7],
  ];

  void habitStarted(int index) {
    var startTime = DateTime.now();
    //elapes time
    int elapesTime = habitList[index][2];

    //habit play pause
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });
    if (habitList[index][1]) {
      //keep time going
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //calculate time
          if (habitList[index][1] == false) {
            timer.cancel();
          }
          var currentTime = DateTime.now();
          habitList[index][2] = elapesTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index, String action) {
    // habitList[index][1] = !habitList[index][1];
    switch (action) {
      case "delete":
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete ${habitList[index][0]}?"),
                backgroundColor: Colors.grey[900],
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          habitList.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Delete")),
                ],
              );
            });
        break;

      case "edit":
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "edit coming soon",
                  style: TextStyle(color: Colors.grey[900]),
                ),
                backgroundColor: Colors.white,
              );
            });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Center(child: Text("Habit Tracker")),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.grey[200],
                  context: context,
                  builder: (context) {
                    return Container(
                      child: Card(
                        color: Colors.grey[200],
                        child: AddHabit(),
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
              habitName: habitList[index][0],
              habitStarted: habitList[index][1],
              timeSpent: habitList[index][2],
              timeGoal: habitList[index][3],
              onTap: () {
                habitStarted(index);
              },
              settingsTapped: (String action) {
                settingsOpened(index, action);
              },
            );
          }),
    );
  }
}
