import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/services/global_methods.dart';
import 'package:ecommerce/user_state.dart';
import 'package:ecommerce/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String UserId;

  ProfileScreen({required this.UserId});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String name = '';
  String email = '';
  String phone = '';
  String job = '';
  String? imageUrl;
  String joinedAt = '';
  bool _isSameUser = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    _isLoading = true;
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.UserId)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('Email');
          name = userDoc.get('name');
          phone = userDoc.get('PhoneNumber');
          job = userDoc.get('Position');
          imageUrl = userDoc.get('userImageurl');
          Timestamp joinedAttimestamp = userDoc.get('CreatedAt');
          var joinedDate = joinedAttimestamp.toDate();
          joinedAt =
              '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        String _Uid = user!.uid;
        setState(() {
          _isSameUser = _Uid == widget.UserId;
        });
        print('same user $_isSameUser');
      }
    } catch (err) {
      GlobalMethods.showErrorDialog(error: '$err', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Center(
            child: Stack(
              children: [
                Card(
                  margin: EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          Center(
                            child: Text(
                              name == null ? '' : name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              '$job since at $joinedAt',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Constants.darkBlue,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Contact Info',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SocialInfo(label: 'Email : ', content: '$email'),
                          const SizedBox(
                            height: 10,
                          ),
                          SocialInfo(label: 'Phone : ', content: '$phone'),
                          const SizedBox(
                            height: 20,
                          ),
                          _isSameUser
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SocialButtons(
                                        color: Colors.green,
                                        icon: Icons.message_outlined,
                                        ftc: () {
                                          openWhatsappChat();
                                        }),
                                    SocialButtons(
                                        color: Colors.red,
                                        icon: Icons.mail_outlined,
                                        ftc: () {
                                          mailTo();
                                        }),
                                    SocialButtons(
                                        color: Colors.purple,
                                        icon: Icons.call_outlined,
                                        ftc: () {
                                          callTo();
                                        }),
                                  ],
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          _isSameUser
                              ? Container()
                              : const Divider(
                                  thickness: 1,
                                ),
                          const SizedBox(
                            height: 25,
                          ),
                          !_isSameUser
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, right: 70, left: 70),
                                  child: GestureDetector(
                                    onTap: () {
                                      Logout();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade300,
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "LogOut",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                        ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 8),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                imageUrl == null
                                    ? 'https://cdn-icons-png.flaticon.com/512/4128/4128176.png'
                                    : imageUrl!,
                              ),
                              fit: BoxFit.cover)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openWhatsappChat() async {
    var url = 'https://wa.me/$phone?text=hello';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  Future<void> mailTo() async {
    var url = 'mailto:$email';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  Future<void> callTo() async {
    var url = 'tell://+$phone';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Error occured');
    }
  }

  SocialInfo({required String label, required String content}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  SocialButtons(
      {required color, required IconData icon, required Function ftc}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: () {
            ftc();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  void Logout() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout_outlined),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Logout'),
              )
            ]),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Do you want Log out ?',
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.darkBlue,
                    fontStyle: FontStyle.italic),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserState()));
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
