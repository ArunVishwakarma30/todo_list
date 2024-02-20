import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/constants/constants.dart';
import 'package:todo_list/controller/create_task_provider.dart';
import 'package:todo_list/views/common/custom_text_style.dart';
import 'package:todo_list/views/common/fliter_container.dart';

import 'common/task_card.dart';
import 'create_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTaskProvider>(
      builder: (context, createTaskProvider, child) {
        createTaskProvider.getPreference();
        createTaskProvider.initialiseDB();
        createTaskProvider.updateListView();
        return Scaffold(
          appBar: createTaskProvider.taskList.isNotEmpty
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(gradient: backgroundColor()),
                  ),
                  title: Text(
                      "Your \nTasks (${createTaskProvider.taskList.length})",
                      style: appStyle(32, darkHeading, FontWeight.bold)))
              : null,
          body: Container(
            decoration: BoxDecoration(gradient: backgroundColor()),
            padding: const EdgeInsets.all(15),
            child: createTaskProvider.taskList.isNotEmpty && createTaskProvider.isTaskCreated
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FilterContainer(
                              filterKey: "Type :",
                              filterValue: "All",
                              onValueChanged: (value) {
                                switch (value) {
                                  case "Completed":
                                    // do something
                                    createTaskProvider
                                        .getCompletedTaskList(true);
                                    break;
                                  case "Pending":
                                    createTaskProvider
                                        .getCompletedTaskList(false);
                                    break;
                                  default:
                                    createTaskProvider.updateListView(
                                        refresh: true);
                                }
                              }),
                          const SizedBox(
                            width: 20,
                          ),
                          FilterContainer(
                              filterKey: "Sort by :",
                              filterValue: "Default",
                              onValueChanged: (value) {
                                switch (value) {
                                  case "Due Date":
                                    // do something
                                    createTaskProvider.getTaskByDueDate();
                                    break;
                                  case "Priority":
                                    createTaskProvider.getTaskByPriority();
                                    break;
                                  default:
                                    createTaskProvider.updateListView(
                                        refresh: true);
                                }
                              }),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: createTaskProvider.taskList.length,
                          itemBuilder: (context, index) {
                            var taskAtCurrentIndex =
                                createTaskProvider.taskList[index];
                            return TaskCard(
                              onTaskTap: () {
                                DateTime dateTime =
                                    DateTime.parse(taskAtCurrentIndex.dueDate!);
                                createTaskProvider.updateDueDate(dateTime,
                                    refresh: false);
                                String priority = "Low";
                                print(taskAtCurrentIndex.priority);
                                if (taskAtCurrentIndex.priority == 3) {
                                  priority = "High";
                                } else if (taskAtCurrentIndex.priority == 2) {
                                  priority = "Medium";
                                }
                                createTaskProvider.updatePriority(priority,
                                    refresh: false);
                                Get.to(
                                  () => CreateTask(
                                    title: taskAtCurrentIndex.title,
                                    description: taskAtCurrentIndex.description,
                                    id: taskAtCurrentIndex.id,
                                  ),
                                  arguments: "Update",
                                );
                              },
                              onOptionSelected: (String value) {
                                if (value == "delete") {
                                  createTaskProvider
                                      .deleteTask(taskAtCurrentIndex);
                                } else if (value == "markAsComplete") {
                                  // Toggle the completion status
                                  if (taskAtCurrentIndex.isCompleted == 0) {
                                    taskAtCurrentIndex.isCompleted = 1;
                                  } else {
                                    taskAtCurrentIndex.isCompleted = 0;
                                  }
                                  // Update the task in the database
                                  createTaskProvider
                                      .updateTask(taskAtCurrentIndex);
                                }
                              },
                              taskDetails: taskAtCurrentIndex,
                            );
                          },
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'No tasks available. Tap the + button to add a new task!',
                      style: appStyle(20, Colors.black, FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: const Color(0xffebdebb),
              onPressed: () {
                Get.to(() => const CreateTask());
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
