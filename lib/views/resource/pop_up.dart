import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopUp {
  celebirate(context, title, content) async {
    showGeneralDialog(
      
        transitionBuilder: (context, a1, a2, widger) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: title,
                content: content,
                actions: [
                  TextButton(
                      onPressed: () async => Navigator.pop(context),
                      child: Text("Close"))
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
