import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/services/global_methods.dart';
import 'package:ecommerce/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _categoryController =
      TextEditingController(text: "Task Category");
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: "Pick up a date");
  final _Formkey = GlobalKey<FormState>();
  DateTime? Picked;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timestamp? deadlibeDatetimestamp;
  bool _isLoading = false;

  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    setState(() {
      _isLoading = true;
    });
    User? user = _auth.currentUser;
    String _Uid = user!.uid;
    final isValid = _Formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final taskId = Uuid().v4();
      print("Form Valid");
      if (_categoryController.text == 'Task Category' ||
          _dateController == 'Pick up a date') {
        GlobalMethods.showErrorDialog(
            error: 'Pls pickup every thing', context: context);
        setState(() {
          _isLoading = false;
        });

        return;
      }
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
          'taskId': taskId,
          'uploadedBy': _Uid,
          'taskTitle': _titleController.text,
          'taskDescription': _descController.text,
          'taskDeadlineDate': _dateController.text,
          'deadlibeDatetimestamp': deadlibeDatetimestamp,
          'taskCategory': _categoryController.text,
          "taskComments": [],
          'isDone': false,
          'createdAt': Timestamp.now()
        });
        Fluttertoast.showToast(
            msg: "Task has been uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0,
            gravity: ToastGravity.BOTTOM);
        setState(() {
          _categoryController.text = "Task Category";
          _titleController.clear();
          _descController.clear();
          _dateController.text = 'Pick up a date';
        });
      } catch (error) {
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Form not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.darkBlue),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'All fields are required',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Constants.darkBlue),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Form(
                key: _Formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget('Task Category'),
                    TxtFormField(
                        valueKey: 'Task Category',
                        controller: _categoryController,
                        enabled: false,
                        fct: () {
                          showTaskCategoryDialog(size);
                        },
                        maxLength: 100),
                    textWidget('Task Title'),
                    TxtFormField(
                        valueKey: "task Title",
                        enabled: true,
                        controller: _titleController,
                        fct: () {},
                        maxLength: 100),
                    textWidget('Task Description'),
                    TxtFormField(
                        valueKey: "TaskDescription",
                        enabled: true,
                        controller: _descController,
                        fct: () {},
                        maxLength: 1000),
                    textWidget('Task DeadLineDate'),
                    TxtFormField(
                        valueKey: "Task DeadLineDate",
                        enabled: false,
                        controller: _dateController,
                        fct: () {
                          pickDate();
                        },
                        maxLength: 1000),
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, right: 50, left: 50),
                            child: GestureDetector(
                              onTap: submitForm,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade300,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Submit",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void showTaskCategoryDialog(size) {
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
                          _categoryController.text =
                              Constants.taskGategoryList[index];
                        });
                        Navigator.pop(context);
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
            ],
          );
        });
  }

  void pickDate() async {
    Picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));

    if (Picked != null) {
      setState(() {
        deadlibeDatetimestamp = Timestamp.fromMicrosecondsSinceEpoch(
            Picked!.microsecondsSinceEpoch);
        _dateController.text =
            '${Picked!.year}-${Picked!.month}-${Picked!.day}';
      });
    }
  }

  textWidget(String txtLabel) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        txtLabel,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade800),
      ),
    );
  }

  TxtFormField({
    required String valueKey,
    required bool enabled,
    required TextEditingController controller,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Field is missing";
            } else {
              return null;
            }
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(color: Constants.darkBlue),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink.shade800),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
