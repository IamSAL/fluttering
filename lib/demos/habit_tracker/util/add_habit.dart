import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void CallbackWithParams(String name, int time);
typedef void EditCallBackType(int currentIndex, String name, int time);

class AddHabit extends StatefulWidget {
  final CallbackWithParams addHabitCallback;
  final EditCallBackType? editHabitCallback;
  final bool editMode;
  final int? currentIndex;
  final List? currentHabit;
  const AddHabit(
      {Key? key,
      required this.addHabitCallback,
      required this.editMode,
      this.editHabitCallback,
      this.currentIndex,
      this.currentHabit})
      : super(key: key);

  @override
  State<AddHabit> createState() => _AddHabitState(
        addHabitCallback: addHabitCallback,
        editMode: editMode,
        editHabitCallback: editHabitCallback,
        currentIndex: currentIndex,
        currentHabit: currentHabit,
      );
}

class _AddHabitState extends State<AddHabit> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _hours;
  int? _minutes;
  final int? currentIndex;
  final CallbackWithParams addHabitCallback;
  final EditCallBackType? editHabitCallback;
  final bool editMode;
  final List? currentHabit;
  _AddHabitState(
      {Key? key,
      required this.addHabitCallback,
      required this.editMode,
      this.editHabitCallback,
      this.currentIndex,
      this.currentHabit});

  Widget _buildNameField() {
    return Container(
      child: TextFormField(
        initialValue: editMode ? currentHabit![0] : "",
        style: TextStyle(color: Colors.grey[900]),
        decoration:
            _getInputDecoration(labelText: "Habit name", prefixIcon: Icons.abc),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name is required";
          }
          return null;
        },
        onSaved: (newValue) {
          _name = newValue;
        },
      ),
    );
  }

  Widget _buildNameHoursField() {
    return TextFormField(
      initialValue: editMode ? currentHabit![3].toString() : null,
      style: TextStyle(color: Colors.grey[900]),
      decoration: _getInputDecoration(
          labelText: "Target Time",
          prefixIcon: Icons.timelapse,
          suffixText: "Minutes"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Time hours is required";
        }
        return null;
      },
      onSaved: (newValue) {
        _hours = int.tryParse(newValue!);
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        editMode
            ? SizedBox(
                height: 5,
              )
            : Dragger(),
        SizedBox(
          height: 40,
        ),
        Title(
            color: Colors.grey,
            child: Text(
              editMode ? "Edit " + currentHabit![0] : "Add new habit",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
              textAlign: TextAlign.center,
            )),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameField(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildNameHoursField(),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          if (editMode) {
                            editHabitCallback!(currentIndex!, _name!, _hours!);
                          } else {
                            addHabitCallback(_name!, _hours!);
                          }
                        },
                        child: Text(editMode ? "Update" : "Add"))
                  ],
                )),
          ),
        )
      ]),
    );
  }
}

_getInputDecoration({
  IconData? prefixIcon,
  required String labelText,
  String? suffixText,
}) {
  return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
          borderRadius: const BorderRadius.all(const Radius.circular(15))),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[900]),
      suffixText: suffixText != null ? suffixText : null);
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
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
