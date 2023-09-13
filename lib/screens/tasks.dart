import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/widgets/drawer_widget.dart';
import 'package:ecommerce/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';

class tasksScreen extends StatefulWidget {
  @override
  State<tasksScreen> createState() => _tasksScreenState();
}

class _tasksScreenState extends State<tasksScreen> {
  String? taskCategory;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Constants.darkBlue),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'Tasks',
            style: TextStyle(color: Colors.pink),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showTaskCategoryDialog(context, size);
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  color: Colors.pink,
                )),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshots.connectionState == ConnectionState.active) {
              if (snapshots.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      return TaskWidget(
                        taskTitle: snapshots.data!.docs[index]['taskTitle'],
                        taskDiscription: snapshots.data!.docs[index]
                            ['taskDescription'],
                        taskId: snapshots.data!.docs[index]['taskId'],
                        uploadedBy: snapshots.data!.docs[index]['uploadedBy'],
                        isDone: snapshots.data!.docs[index]['isDone'],
                      );
                    });
              } else {
                return const Center(child: Text("No tasks has been uploaded"));
              }
            }
            return const Center(child: Text("Something went wrong"));
          },
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('taskCategory', isEqualTo: taskCategory)
              .orderBy('createdAt', descending: false)
              .snapshots(),
        ));
  }

  void showTaskCategoryDialog(context, size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task Category',
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  itemCount: Constants.taskGategoryList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          taskCategory = Constants.taskGategoryList[index];
                        });
                        print(
                            'taskGategoryList[index] ${Constants.taskGategoryList[index]}');
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red[200],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.taskGategoryList[index],
                              style: const TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text("close")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      taskCategory = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Cancel Filters'))
            ],
          );
        });
  }
}
