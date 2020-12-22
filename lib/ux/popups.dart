import 'package:flutter/material.dart';

bool showAlertDialog({BuildContext context, String title, String text}) {


  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {

      Navigator.of(context, rootNavigator: true)
          .pop();

      return true;

    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return true;
}