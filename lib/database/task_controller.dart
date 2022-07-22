import 'package:get/get.dart';
import 'package:todo_app/database/task.dart';
import 'package:todo_app/database/task_db.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;
  var DateList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await TasksDB.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await TasksDB.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    TasksDB.delete(task);
    getTasks();
  }

  void markTaskisCompleted(int id) async {
    await TasksDB.update(id);
    getTasks();
  }

  void findByDate(String selectedDate) async {
    List<Map<String, dynamic>> dates = await TasksDB.findDate(selectedDate);
    DateList.assignAll(dates.map((data) => new Task.fromJson(data)).toList());
    // getTasks();
  }
}
