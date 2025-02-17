import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helper{

  static void showToast(String msg, {bool? isError}) {
    print(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: isError != null ? Colors.redAccent :  Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}