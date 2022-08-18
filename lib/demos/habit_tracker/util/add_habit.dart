import 'package:flutter/material.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({Key? key}) : super(key: key);

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Dragger(),
      ]),
    );
  }
}

class Dragger extends StatelessWidget {
  const Dragger({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 5,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.grey[900]?.withAlpha(50),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
