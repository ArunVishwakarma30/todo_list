import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/controller/create_task_provider.dart';

import '../constants/constants.dart';
import '../model/task_model.dart';
import 'common/custom_text_style.dart';
import 'common/height_spacer.dart';
import 'common/reusable_text.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key, this.title, this.description, this.id}) : super(key: key);
  final String? title;
  final String? description;
  final int? id;


  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  String? args;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    args = Get.arguments;
    if(args == "Update"){
      _taskTitleController.text = widget.title!;
      _taskDescriptionController.text = widget.title!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: backgroundColor()),
            ),
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios)),
            title: ReusableText(
                text: "Create Task",
                style: appStyle(22, Color(darkHeading.value), FontWeight.bold)),
          ),
          body: Consumer<CreateTaskProvider>(
            builder: (context, createTaskProvider, child) {
              createTaskProvider.initialiseDB();
              String formattedDueDate =
                  createTaskProvider.selectedDueDate != null
                      ? DateFormat('dd MMM yyyy')
                          .format(createTaskProvider.selectedDueDate!)
                      : "Due date";
              return ListView(children: [
                Container(
                  padding: const EdgeInsets.only(right: 15.0, left: 20),
                  color: CupertinoColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpacer(height: 10),
                      DropdownButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        borderRadius: BorderRadius.circular(10.0),
                        value: createTaskProvider.selectedPriority ??
                            createTaskProvider.selectedPriority,
                        hint: const Text("Select Priority"),
                        style: appStyle(16, Colors.black, FontWeight.w500),
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? value) {
                          setState(() {
                            createTaskProvider.updatePriority(value!);
                          });
                        },
                        items: ['High', 'Medium', 'Low'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const HeightSpacer(height: 20),
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        controller: _taskTitleController,
                        cursorColor: Colors.black,
                        style: appStyle(18, darkHeading, FontWeight.normal),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(darkHeading.value))),
                          labelText: "Task name",
                          labelStyle:
                              appStyle(16, darkHeading, FontWeight.normal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      const HeightSpacer(height: 20),
                      TextField(
                        minLines: 1,
                        maxLines: 10,
                        controller: _taskDescriptionController,
                        cursorColor: Colors.black,
                        style: appStyle(18, darkHeading, FontWeight.normal),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(darkHeading.value))),
                          labelText: "Task description",
                          labelStyle:
                              appStyle(16, darkHeading, FontWeight.normal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      const HeightSpacer(height: 20),
                      GestureDetector(
                        onTap: () async {
                          // Show date picker
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );

                          createTaskProvider.updateDueDate(pickedDate);
                        },
                        child: Container(
                          width: width - 35,
                          height: height * 0.07,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 18),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ReusableText(
                              text: formattedDueDate,
                              style:
                                  appStyle(17, darkHeading, FontWeight.normal)),
                        ),
                      ),
                      const HeightSpacer(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    int priority = 1;
                                    if (createTaskProvider.selectedPriority ==
                                        'High') {
                                      priority = 3;
                                    } else if (createTaskProvider
                                            .selectedPriority ==
                                        'Medium') {
                                      priority = 2;
                                    }
                                    if(args == "Update"){
                                      Task model = Task.withId(widget.id, _taskTitleController.text, _taskDescriptionController.text, 0, createTaskProvider.selectedDueDate.toString(), priority);
                                      createTaskProvider.updateTask(model);
                                  }else{
                                      Task model = Task(
                                          _taskTitleController.text.trim(),
                                          _taskDescriptionController.text
                                              .trim(),
                                          0,
                                          createTaskProvider.selectedDueDate
                                              .toString(),
                                          priority);
                                      createTaskProvider.setPreference();
                                      createTaskProvider.insert(model);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    backgroundColor: const Color(0xffebdebb),
                                  ),
                                  child: Text(
                                  args == "Update" ? "Update" : "Create",
                                    style: appStyle(
                                        18, darkHeading, FontWeight.normal),
                                  ))),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    backgroundColor: const Color(0xffebdebb),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: appStyle(
                                        18, darkHeading, FontWeight.normal),
                                  )))
                        ],
                      )
                    ],
                  ),
                ),
              ]);
            },
          )),
    );
  }
}
