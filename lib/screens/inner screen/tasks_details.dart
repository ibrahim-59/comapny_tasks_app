import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/services/global_methods.dart';
import 'package:ecommerce/widgets/comment_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  final String uploadedby;

  TaskDetailsPage({required this.taskId, required this.uploadedby});
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  bool isComminting = false;
  String? _authorName;
  String? _authorPosition;
  String? _authorImageurl;
  String? _taskTitle;
  String? _taskDescrption;
  bool? _isDone;
  Timestamp? PostedDatetimestamp;
  Timestamp? DeadlineDatetimestamp;
  String? deadlineDate;
  String? postedDate;
  bool? _isDeadlineavilable = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool? _isLoading = false;
  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedby)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('Position');
          _authorImageurl = userDoc.get('userImageurl');
        });
        final DocumentSnapshot TaskDoc = await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .get();
        if (TaskDoc == null) {
          return;
        } else {
          setState(() {
            _taskDescrption = TaskDoc.get('taskDescription');
            _taskTitle = TaskDoc.get('taskTitle');
            _isDone = TaskDoc.get('isDone');
            deadlineDate = TaskDoc.get('taskDeadlineDate');
            DeadlineDatetimestamp = TaskDoc.get('deadlibeDatetimestamp');
            PostedDatetimestamp = TaskDoc.get('createdAt');
            var postdate = PostedDatetimestamp!.toDate();
            postedDate =
                '${postdate.year} -${postdate.month} - ${postdate.day} ';
            var date = DeadlineDatetimestamp!.toDate();
            _isDeadlineavilable = date.isAfter(DateTime.now());
          });
        }
      }
    } catch (error) {
      GlobalMethods.showErrorDialog(
          error: 'An error occured', context: context);
    } finally {
      _isLoading = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Back",
            style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      body: _isLoading == false
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      _taskTitle == null ? '' : _taskTitle!,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Uploaded by : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.pink.shade800,
                                          width: 3),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(_authorImageurl ==
                                                null
                                            ? 'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png'
                                            : _authorImageurl!),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _authorName == null ? '' : _authorName!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Constants.darkBlue),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        _authorPosition == null
                                            ? ''
                                            : _authorPosition!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Constants.darkBlue),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Uploaded on : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  Text(
                                    postedDate == null ? '' : postedDate!,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.pink.shade800),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deadline date : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue),
                                  ),
                                  Text(
                                    deadlineDate == null ? '' : deadlineDate!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  _isDeadlineavilable!
                                      ? 'Still have enough time'
                                      : 'no time left',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: _isDeadlineavilable!
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Done State : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.darkBlue),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      String _Uid = user!.uid;
                                      if (_Uid == widget.uploadedby) {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskId)
                                            .update({
                                          'isDone': true,
                                        });
                                        getData();
                                      } else {
                                        GlobalMethods.showErrorDialog(
                                            error:
                                                "you can\'t perform this section",
                                            context: context);
                                      }
                                    },
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                          decoration: _isDone == true
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Constants.darkBlue),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _isDone == true ? 1 : 0,
                                    child: Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      String _Uid = user!.uid;
                                      if (_Uid == widget.uploadedby) {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskId)
                                            .update({
                                          'isDone': false,
                                        });
                                        getData();
                                      } else {
                                        GlobalMethods.showErrorDialog(
                                            error:
                                                "you can\'t perform this section",
                                            context: context);
                                      }
                                    },
                                    child: Text(
                                      'Not Done',
                                      style: TextStyle(
                                          decoration: _isDone == false
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Constants.darkBlue),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _isDone == false ? 1 : 0,
                                    child: Icon(
                                      Icons.check_box,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Task Description : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.darkBlue),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _taskDescrption == null
                                    ? 'null'
                                    : _taskDescrption!,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Constants.darkBlue),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: isComminting
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: TextField(
                                              maxLength: 200,
                                              maxLines: 6,
                                              controller: _commentController,
                                              style: TextStyle(
                                                  color: Constants.darkBlue),
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.pink),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        if (_commentController
                                                                .text.length <
                                                            7) {
                                                          GlobalMethods
                                                              .showErrorDialog(
                                                                  error:
                                                                      "Comment can't be less than 7 characters",
                                                                  context:
                                                                      context);
                                                        } else {
                                                          final _generatedId =
                                                              Uuid().v4();
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'tasks')
                                                              .doc(
                                                                  widget.taskId)
                                                              .update({
                                                            'taskComments':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              {
                                                                'userId': widget
                                                                    .uploadedby,
                                                                'commentId':
                                                                    _generatedId,
                                                                'userName':
                                                                    _authorName,
                                                                "commentBody":
                                                                    _commentController
                                                                        .text,
                                                                'commentTime':
                                                                    Timestamp
                                                                        .now(),
                                                                'userImage':
                                                                    _authorImageurl,
                                                              }
                                                            ])
                                                          });
                                                          await Fluttertoast.showToast(
                                                              msg:
                                                                  "Task has been uploaded successfully",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              fontSize: 16.0,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM);
                                                          _commentController
                                                              .clear();
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Post',
                                                      ),
                                                      textColor: Colors.white,
                                                      color:
                                                          Colors.pink.shade800,
                                                      elevation: 10,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13)),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            isComminting =
                                                                !isComminting;
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      )
                                    : Center(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              isComminting = !isComminting;
                                            });
                                          },
                                          child: const Text(
                                            'Add a Comment',
                                          ),
                                          textColor: Colors.white,
                                          color: Colors.pink.shade800,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.data == null) {
                                      return Container();
                                    }
                                    return ListView.separated(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, index) {
                                          return CommentWidget(
                                            commentBody:
                                                snapshot.data!['taskComments']
                                                    [index]['commentBody'],
                                            commentId:
                                                snapshot.data!['taskComments']
                                                    [index]['commentId'],
                                            commenterId:
                                                snapshot.data!['taskComments']
                                                    [index]['userId'],
                                            commenterImageurl:
                                                snapshot.data!['taskComments']
                                                    [index]['userImage'],
                                            commenterName:
                                                snapshot.data!['taskComments']
                                                    [index]['userName'],
                                          );
                                        },
                                        separatorBuilder: (ctx, index) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                        itemCount: snapshot
                                            .data!['taskComments'].length);
                                  }),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
