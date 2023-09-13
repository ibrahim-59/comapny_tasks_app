import 'package:ecommerce/screens/inner%20screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userId;
  final String userImage;
  final String userPosition;
  final String userPhone;

  AllWorkersWidget(
      {required this.userName,
      required this.userEmail,
      required this.userId,
      required this.userImage,
      required this.userPosition,
      required this.userPhone});
  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
          onTap: () {
            NavigateToProfileScreen(context);
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
            child: widget.userImage == null
                ? Icon(
                    Icons.person_2_outlined,
                    color: Colors.pink.shade800,
                    size: 30,
                  )
                : Image.network(
                    widget.userImage,
                    width: 30,
                    height: 40,
                  ),
          ),
          title: Text(
            widget.userName,
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
                  '${widget.userPosition} / ${widget.userPhone}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                )
              ]),
          trailing: IconButton(
            icon: Icon(
              Icons.mail_outline_outlined,
              size: 30,
              color: Colors.pink.shade800,
            ),
            onPressed: () {
              mailTo();
            },
          )),
    );
  }

  Future<void> mailTo() async {
    var url = 'mailto:$widget.userEmail';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  void NavigateToProfileScreen(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  UserId: widget.userId,
                )));
  }
}
