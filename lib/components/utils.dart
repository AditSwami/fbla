import 'package:flutter/cupertino.dart';

void showAlert(String content, String title, BuildContext context) {
  showCupertinoModalPopup(context: context,
  builder: (BuildContext context) => CupertinoAlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        },
        child: Text('OK'),
      )
    ],
  ));
}
