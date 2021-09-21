import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test/page/bar.dart';
import 'package:test/page/home.dart';
import 'package:test/page/images.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'package:flutter/services.dart';
void main() {
  // 沉浸式开始
  if(Platform.isAndroid){
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  // 结束

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      debugShowCheckedModeBanner: false,
      // title: 'Bubble Bottom Bar Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      // home: title: '这是一个标题'),
      initialRoute: '/',
      routes: {
        '/': (context) => Bar(),
        '/home': (context) => Home(),
        '/images': (context) => Images(),
        '/detailed': (context,{arguments}) => FullScreenImagePage(imageurl: arguments['imageurl']),
      },
    );
  }
}
