import 'package:ecommerce/screens/inner%20screen/profile_screen.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String commentId;
  final String commentBody;
  final String commenterImageurl;
  final String commenterName;
  final String commenterId;
  final List<Color> _colors = [
    Colors.green,
    Colors.amber,
    Colors.pink,
    Colors.purple,
    Colors.blue
  ];

  CommentWidget(
      {required this.commentId,
      required this.commentBody,
      required this.commenterImageurl,
      required this.commenterName,
      required this.commenterId});
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(UserId: commenterId)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: _colors[0], width: 3),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(commenterImageurl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    commenterName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    commentBody,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
