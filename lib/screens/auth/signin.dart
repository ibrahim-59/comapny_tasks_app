import 'dart:io';

import 'package:ecommerce/constants/constant.dart';
import 'package:ecommerce/services/global_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/screens/auth/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _animatedController;
  late Animation<double> _animation;
  late TextEditingController _emailcontroller = TextEditingController();
  late TextEditingController _phonecontroller = TextEditingController();
  late TextEditingController _passcontroller = TextEditingController();
  late TextEditingController _namecontroller = TextEditingController();
  late TextEditingController _positioncontroller = TextEditingController();
  bool _obsecureText = true;
  final _loginFormkey = GlobalKey<FormState>();
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passFocus = FocusNode();
  FocusNode _positionFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? url;

  @override
  void dispose() {
    _animatedController.dispose();
    _emailcontroller.dispose();
    _passcontroller.dispose();
    _namecontroller.dispose();
    _positioncontroller.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _positionFocus.dispose();
    _phoneFocus.dispose();
    _phonecontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animatedController =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animatedController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animatedController.reset();
              _animatedController.forward();
            }
          });
    _animatedController.forward();
    super.initState();
  }

  Future<void> submitForm() async {
    final isValid = _loginFormkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethods.showErrorDialog(
            error: "Pls select an image", context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailcontroller.text.toLowerCase().trim(),
            password: _passcontroller.text.trim());
        final userId = _auth.currentUser!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("UserImages")
            .child(userId + ".jpg");
        await ref.putFile(imageFile!);
        url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          "userId": userId,
          "name": _namecontroller.text,
          'Email': _emailcontroller.text,
          'userImageurl': url,
          'PhoneNumber': _phonecontroller.text,
          "Position": _positioncontroller.text,
          'CreatedAt': Timestamp.now()
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErrorDialog(
            error: error.toString(), context: context);
        print('error ocured$error');
      }
      print("Form Valid");
    } else {
      print("Form not Valid");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://steamuserimages-a.akamaihd.net/ugc/929310409266706768/9D723746DF3846434A4438088247DCFDDB9D4379/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
            placeholder: (context, url) => Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _loginFormkey,
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Already have an account ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    TextSpan(
                        text: "Sign In",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginIn())),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue.shade300)),
                  ])),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "can/'t be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          controller: _namecontroller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red.shade500)),
                            errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.yellow.shade200)),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width * 0.25,
                                height: size.width * 0.25,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile == null
                                      ? Image.network(
                                          'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png',
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          imageFile!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  showImageDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    border:
                                        Border.all(width: 2, color: Colors.red),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    imageFile == null
                                        ? Icons.add_a_photo
                                        : Icons.edit_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passFocus),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "pls enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailcontroller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade500)),
                      errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow.shade200)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _passFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_phoneFocus),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "pls enter a valid Password";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passcontroller,
                    obscureText: _obsecureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(
                          _obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade500)),
                      errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow.shade200)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _phoneFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_positionFocus),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "can/'t be empty";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phonecontroller,
                    onChanged: (v) {
                      print('PhoneControler ${_phonecontroller.text}');
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.shade500)),
                      errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow.shade200)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showJobDialog(size);
                    },
                    child: TextFormField(
                      enabled: false,
                      focusNode: _positionFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: submitForm,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "can/'t be empty";
                        }
                        return null;
                      },
                      controller: _positioncontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Position",
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red.shade500)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red.shade500)),
                        errorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.yellow.shade200)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  _isLoading
                      ? Center(
                          child: Container(child: CircularProgressIndicator()),
                        )
                      : GestureDetector(
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
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select an Option"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                  onTap: pickImageWithCamera,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                        Text("Camera")
                      ],
                    ),
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
                InkWell(
                  onTap: pickImageWithGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                        Text("Gallery")
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  Future<void> cropImage(filePath) async {
    CroppedFile? CcropImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (CcropImage != null) {
      File? cropImage = File(CcropImage.path);
      setState(() {
        imageFile = cropImage;
      });
    }
  }

  Future<void> pickImageWithCamera() async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);

      cropImage(pickedFile!.path);
    } catch (error) {
      GlobalMethods.showErrorDialog(error: '$error', context: context);
    }

    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    Navigator.pop(context);
  }

  Future<void> pickImageWithGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    cropImage(pickedFile!.path);
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    Navigator.pop(context);
  }

  void showJobDialog(size) {
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
                  itemCount: Constants.jobList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _positioncontroller.text = Constants.jobList[index];
                          Navigator.pop(context);
                        });
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
                              Constants.jobList[index],
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
                  child: const Text("ok")),
              TextButton(onPressed: () {}, child: const Text('Cancel Filters'))
            ],
          );
        });
  }
}
