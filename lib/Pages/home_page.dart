import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Pages/add_page.dart';
import 'package:todo_app/database/task_controller.dart';
import 'package:todo_app/widget/task_tile.dart';

import '../database/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();

  final taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "TODO",
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 25)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Get.to(const AddPage());
              taskController.getTasks();
            },
            icon: const Icon(Icons.add),
            tooltip: "Add your tasks",
            color: Colors.black,
            iconSize: 40,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          datebar(),
          const SizedBox(
            height: 10,
          ),
          showtask()
        ],
      ),
    );
  }

  Expanded showtask() {
    //taskController.getTasks();
    //  _selectedDate = DateTime.now();
    print(_selectedDate);
    taskController.findByDate(DateFormat.yMd().format(_selectedDate));

    return Expanded(
      child: Obx(() {
        if (taskController.DateList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/EmptyData.png"),
              TextButton(
                child: Text(
                  "Add your task +",
                  style: GoogleFonts.barlow(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20)),
                ),
                onPressed: () async {
                  await Get.to(const AddPage());
                  taskController.getTasks();
                },
              ),
            ],
          );
        } else {
          taskController.getTasks();
          return ListView.builder(
              itemCount: taskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = taskController.taskList[index];
                if (task.repeat == "Daily") {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        }
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task is completed",
                  onTap: () {
                    taskController.markTaskisCompleted(task.id!);
                    Get.back();
                  },
                  color: Color.fromARGB(255, 66, 194, 70),
                  context: context,
                ),
          _bottomSheetButton(
            label: "Delete task",
            onTap: () {
              taskController.delete(task);
              taskController.findByDate(DateFormat.yMd().format(_selectedDate));
              Get.back();
            },
            color: const Color.fromARGB(255, 228, 73, 61),
            context: context,
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            color: const Color.fromARGB(255, 214, 214, 214),
            isClose: true,
            context: context,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? GoogleFonts.barlow(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20))
              : GoogleFonts.barlow(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20)),
        )),
      ),
    );
  }

  Container datebar() {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      //Date bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: GoogleFonts.barlow(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20)),
          ),
          Text(
            "Today",
            style: GoogleFonts.barlow(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.barlow(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                  print(DateFormat.yMd().format(_selectedDate));
                  Get.back();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
