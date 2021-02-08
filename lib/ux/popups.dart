import 'package:flutter/material.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';

Future <bool> showAlertDialog({BuildContext context, String title, String text, bool firstScreen}) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {

      if (!firstScreen){
        Navigator.pushNamed(context, CaptureScreen.id);
      } else{
        Navigator.pop(context);
      }


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

}