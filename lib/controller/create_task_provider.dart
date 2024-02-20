import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/views/common/snack_bar.dart';
import 'package:todo_list/views/home_page.dart';

import '../model/task_model.dart';
import '../service/database_helper.dart';

class CreateTaskProvider extends ChangeNotifier {
  String _selectedPriority = 'High';
  DateTime? _selectedDueDate;
  late DatabaseHelper databaseHelper;

  List<Task> taskList = [];
  int? _updateIndex;
  int? count;

  // initialise database
  initialiseDB() {
    databaseHelper = DatabaseHelper.instance;
  }

  int? get updateIndex => _updateIndex;

  set updateIndex(int? value) {
    _updateIndex = value;
    notifyListeners();
  }

  String get selectedPriority => _selectedPriority;

  DateTime? get selectedDueDate => _selectedDueDate;

  void updatePriority(String priority, {bool refresh = true}) {
    _selectedPriority = priority;
    if (refresh) {
      notifyListeners();
    }
  }

  void updateDueDate(DateTime? dueDate, {bool refresh = true}) {
    _selectedDueDate = dueDate;
    if (refresh) {
      notifyListeners();
    }
  }

  // insert task
  insert(Task task) async {
    await databaseHelper.insertTask(task);
    ShowSnackbar(
        title: "Successful", message: "Task Created", icon: Icons.done_outline);
    updateListView();
    Get.offAll(() => const HomePage());
  }

  // update task

  updateTask(Task task) async {
    await databaseHelper.updateTask(task);
    ShowSnackbar(
        title: "Successful", message: "Task Updated", icon: Icons.done_outline);
    updateListView(refresh: true);
  }

  // update list view
  updateListView({bool refresh = false}) async {
    List<Task> updatedList = await databaseHelper.getTaskList();
    taskList = updatedList;
    count = updatedList.length;
    if (refresh) {
      notifyListeners();
    }
  }

  // get tasks by priority
  getTaskByPriority() async {
    List<Task> priorityList = await databaseHelper.getPriorityTaskList();
    taskList = priorityList;
    count = priorityList.length;
    notifyListeners();
  }

// get tasks by due date
  getTaskByDueDate() async {
    List<Task> dueDateList = await databaseHelper.getTaskListSortedByDueDate();
    taskList = dueDateList;
    count = dueDateList.length;
    notifyListeners();
  }

  // get completed OR pending task list
  getCompletedTaskList(bool isCompleted) async {
    List<Task> tasks = await databaseHelper.getCompletedTaskList(isCompleted);
    taskList = tasks;
    count = tasks.length;
    notifyListeners();
  }

  // delete task
  deleteTask(Task task) async {
    int? result = await databaseHelper.deleteTask(task.id);
    updateListView(refresh: true);
    ShowSnackbar(
        title: "Successful",
        message: "Task Deleted",
        icon: Icons.delete_outline);
  }
}
