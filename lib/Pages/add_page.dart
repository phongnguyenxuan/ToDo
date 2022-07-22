import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/task.dart';
import 'package:todo_app/database/task_controller.dart';
import 'package:todo_app/widget/MyInputFiled.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TaskController taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  DateTime _slectedDate = DateTime.now();
  String _time = DateFormat("hh:mm").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  String _selectedRepeat = 'None';
  List<int> reMindList = [5, 10, 15, 20];
  List<String> rePeatList = ["None", "Daily"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _header(),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                MyInputType(
                  title: "Title",
                  hint: "Enter your title",
                  controller: _titleController,
                ),
                //task
                MyInputType(
                  title: "Task",
                  hint: "Enter your task",
                  controller: _taskController,
                ),
                //date
                MyInputType(
                  title: "Date",
                  hint: DateFormat.yMd().format(_slectedDate),
                  widget: IconButton(
                      onPressed: () {
                        _getDateFromUser();
                      },
                      color: Colors.grey,
                      icon: const Icon(Icons.calendar_today_outlined)),
                ),
                //time
                MyInputType(
                    title: "Time",
                    hint: _time,
                    widget: IconButton(
                      icon: Icon(Icons.access_time_rounded),
                      color: Colors.grey,
                      onPressed: () {
                        _getTimeFromUser();
                      },
                    )),
                //remind
                MyInputType(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 16,
                    underline: Container(height: 0),
                    items:
                        reMindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          value.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        value: value.toString(),
                      );
                    }).toList(),
                  ),
                ),
                //repeat
                MyInputType(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 16,
                    underline: Container(height: 0),
                    items: rePeatList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          value!,
                          style: TextStyle(color: Colors.black),
                        ),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

//kiem tra nhap du cac thong tin
  _validateDate() {
    if (_titleController.text.isNotEmpty && _taskController.text.isNotEmpty) {
      //add to database
      _addTaskToDataBase();
      taskController.findByDate(DateFormat.yMd().format(_slectedDate));
      Get.back();
    } else if (_titleController.text.isEmpty || _taskController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDataBase() async {
    int value = await taskController.addTask(
        task: Task(
            title: _titleController.text.toString(),
            task: _taskController.text.toString(),
            date: DateFormat.yMd().format(_slectedDate),
            time: _time,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            isCompleted: 0));
  }

//creat time
  _getTimeFromUser() async {
    var pickerTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              secondary: Colors.black,
              outline: Colors.black,
              primary:
                  Color.fromARGB(255, 39, 39, 39), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickerTime != null) {
      setState(() {
        _time = pickerTime.format(context);
      });
    }
  }

//create calendar
  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2121),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                secondary: Colors.black,
                outline: Colors.black,
                primary:
                    Color.fromARGB(255, 39, 39, 39), // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                primary: Colors.black,
              ))),
          child: child!,
        );
      },
    );

    if (pickerDate != null) {
      setState(() {
        _slectedDate = pickerDate;
      });
    } else {
      print("Something is wrong");
    }
  }

//appbar
  AppBar _header() {
    return AppBar(
      leading: IconButton(
          iconSize: 30,
          color: Colors.black,
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Get.back();
          }),
      centerTitle: false,
      actions: [
        Visibility(
          visible: true,
          child: IconButton(
            onPressed: () {
              _validateDate();
            },
            icon: Icon(Icons.check_rounded),
            color: Colors.black,
          ),
        )
      ],
      title: Text(
        "Add your task",
        style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 25)),
      ),
      backgroundColor: Colors.white,
    );
  }
}
