import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/inner%20screen/tasks_details.dart';
import 'package:ecommerce/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle, taskId, taskDiscription, uploadedBy;
  final bool isDone;

  const TaskWidget(
      {required this.taskTitle,
      required this.taskId,
      required this.taskDiscription,
      required this.isDone,
      required this.uploadedBy});
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                        taskId: widget.taskId,
                        uploadedby: widget.uploadedBy,
                      )));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          User? user = FirebaseAuth.instance.currentUser;
                          String _uid = user!.uid;
                          if (_uid == widget.uploadedBy) {
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(widget.taskId)
                                .delete();
                            Navigator.pop(context);
                          } else {
                            GlobalMethods.showErrorDialog(
                                error:
                                    'You dont have access to delete this task',
                                context: context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ))
                  ],
                );
              }));
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Icon(
              widget.isDone ? Icons.check : Icons.timer_outlined,
              color: Colors.pink.shade800,
              size: 30,
            ),
          ),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.linear_scale,
                color: Colors.pink.shade800,
              ),
              Text(
                widget.taskDiscription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              )
            ]),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }
}
