import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef void CallbackWithAction(String action);

class HabitTile extends StatefulWidget {
  final String habitName;
  final VoidCallback onTap;
  final CallbackWithAction settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile(
      {Key? key,
      required this.habitName,
      required this.onTap,
      required this.settingsTapped,
      required this.timeSpent,
      required this.timeGoal,
      required this.habitStarted})
      : super(key: key);

  @override
  State<HabitTile> createState() =>
      _HabitTileState(onTap: onTap, habitStarted: habitStarted);
}

class _HabitTileState extends State<HabitTile> {
  final VoidCallback onTap;
  final bool habitStarted;

  _HabitTileState({Key? key, required this.onTap, required this.habitStarted});

  @override
  void initState() {
    print(habitStarted);
    if (habitStarted) {
      Future.delayed(Duration.zero, () async {
        onTap();
        onTap();
      });
    }
  }

//convert seconds to mins:62 seconds = 1:02 min
  String formatToMinSecString(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    //if secs is 1 digit number, place 0 in front

    if (secs.length == 1) {
      secs = '0' + secs;
    }

    //if mins is 1 digit number
    if (mins[1] == ".") {
      mins = mins.substring(0, 1);
    }

    return int.tryParse(mins).toString() + ':' + int.tryParse(secs).toString();
  }

  double percentCompleted() {
    return widget.timeSpent / (widget.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Stack(children: [
                          //progress circle
                          CircularPercentIndicator(
                            radius: 30,
                            percent:
                                percentCompleted() < 1 ? percentCompleted() : 1,
                            progressColor: percentCompleted() > 0.5
                                ? (percentCompleted() > 0.75
                                    ? Colors.green
                                    : Colors.orange)
                                : Colors.red,
                          ),
                          //play pause button
                          Center(
                              child: Icon(
                            widget.habitStarted
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.grey[900],
                          )),
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //habit name
                            Text(
                              widget.habitName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[900],
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),
                            //progress
                            Text(
                              formatToMinSecString(widget.timeSpent) +
                                  " / " +
                                  widget.timeGoal.toString() +
                                  " = " +
                                  (percentCompleted() * 100)
                                      .toStringAsFixed(0) +
                                  "%",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                HabitSettingMenu(settingsTapped: widget.settingsTapped)
              ],
            )),
      ),
    );
  }
}

class HabitSettingMenu extends StatelessWidget {
  const HabitSettingMenu({
    Key? key,
    required this.settingsTapped,
  }) : super(key: key);

  final CallbackWithAction settingsTapped;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (String action) {
          settingsTapped(action);
        },
        icon: Icon(
          Icons.settings,
          color: Colors.grey[900],
        ),
        color: Colors.white,
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
                value: 'edit',
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.grey[900]),
                )),
            PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.grey[900]),
                ))
          ];
        });
  }
}
