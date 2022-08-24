import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttering/demos/habit_tracker/util/add_habit.dart';
import 'package:fluttering/demos/habit_tracker/util/habit_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({Key? key}) : super(key: key);

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  List habitList = [
    //[habitName,habitStarted,timeSpent(sec),timeGoal(min)]
  ];

  var timerRef;

  void addHabitCallback(String name, int time) {
    setState(() {
      habitList.insert(0, [name, false, 0, time]);
      Navigator.of(context).pop();
    });
  }

  void editHabitCallback(int currentIndex, String name, int time) {
    setState(() {
      habitList[currentIndex][0] = name;
      habitList[currentIndex][3] = time;
      Navigator.of(context).pop();
    });
  }

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
      timerRef = Timer.periodic(Duration(seconds: 1), (timer) {
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
                title: Text(
                  "Delete ${habitList[index][0]}?",
                  style: TextStyle(color: Colors.white),
                ),
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
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: Colors.grey[200],
                      child: AddHabit(
                        addHabitCallback: addHabitCallback,
                        editHabitCallback: editHabitCallback,
                        editMode: true,
                        currentIndex: index,
                        currentHabit: habitList[index],
                      ),
                    )
                  ],
                )),
              );
            });
        break;
      default:
    }
  }

  void _loadSavedList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedhabitList = prefs.getString('habitList');

    setState(() {
      if (savedhabitList != null) {
        habitList = json.decode(savedhabitList);
      } else {
        habitList = [
          ['Excercise', false, 0, 1],
          ['Read', false, 2, 5],
          ['Code', false, 0, 10],
          ['Meditate', false, 0, 2]
        ];
      }
    });
  }

  void _saveList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('habitList', json.encode(habitList));
  }

  @override
  void initState() {
    super.initState();
    _loadSavedList();
  }

  @override
  void dispose() async {
    super.dispose();
    _saveList();
    if (timerRef != null) {
      timerRef.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(child: Text("Habit Tracker")),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  backgroundColor: Colors.grey[200],
                  context: context,
                  builder: (context) {
                    return AnimatedPadding(
                      padding: MediaQuery.of(context).viewInsets,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            color: Colors.grey[200],
                            child: AddHabit(
                                addHabitCallback: addHabitCallback,
                                editMode: false),
                          )
                        ],
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: habitList.length > 0
          ? ListView.builder(
              itemCount: habitList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: index == habitList.length - 1
                      ? EdgeInsets.only(bottom: 20)
                      : null,
                  child: HabitTile(
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
                  ),
                );
              })
          : Center(
              child: Text("Click + to add a habit."),
            ),
    );
  }
}
