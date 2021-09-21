import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//Toast封装
class SQToast {
  static show(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
    );
  }
}