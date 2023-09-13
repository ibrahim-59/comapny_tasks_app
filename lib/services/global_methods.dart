import 'package:ecommerce/constants/constant.dart';
import 'package:flutter/material.dart';

class GlobalMethods {
  static void showErrorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.error_outline),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Error Occured'),
              )
            ]),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
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
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
