import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/views/common/custom_text_style.dart';
import 'package:todo_list/views/common/reusable_text.dart';
import 'package:todo_list/views/common/reusable_text.dart';

import '../../constants/constants.dart';

class TaskCard extends StatefulWidget {
  const TaskCard(
      {Key? key,
      required this.taskDetails,
      required this.onTaskTap,
      required this.onOptionSelected})
      : super(key: key);

  final Task taskDetails;
  final VoidCallback onTaskTap;
  final Function(String) onOptionSelected;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    String convertDateFormat(String inputDate) {
      DateTime dateTime = DateTime.parse(inputDate);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      return formattedDate;
    }

    String priority = "Low";
    if(widget.taskDetails.priority==3){
      priority = "High";
    }else if(widget.taskDetails.priority==2){
      priority = "Medium";
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: getRandomColor(),
      // color: getRandomColor(),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
            onTap: widget.onTaskTap,
            title: RichText(
              maxLines: 50,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  text: '${widget.taskDetails.title} \n',

                  style: TextStyle(
                    decoration: widget.taskDetails.isCompleted == 0 ?  TextDecoration.none : TextDecoration.lineThrough,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.5),
                  children: [
                    TextSpan(
                      text: widget.taskDetails.description,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 1.5),
                    )
                  ]),
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Due Date ${convertDateFormat(widget.taskDetails.dueDate!)}',
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade800),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      priority,
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800),
                    ),
                  ],
                )),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                widget.onOptionSelected(
                    value); // Callback function to notify the HomePage.dart
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ReusableText(
                      text: 'Delete',
                      style: appStyle(17, Colors.black, FontWeight.normal)),
                ),
                PopupMenuItem<String>(
                  value: 'markAsComplete',
                  child: ReusableText(
                      text: widget.taskDetails.isCompleted == 0 ? 'Mark as Complete' : 'Mark as Incomplete',
                      style: appStyle(17, Colors.black, FontWeight.normal)),
                ),
              ],
            )),
      ),
    );
  }
}
