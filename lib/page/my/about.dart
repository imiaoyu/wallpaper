import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:test/model/toast.dart';
import 'package:test/model/updata.dart';

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> with SingleTickerProviderStateMixin {

  String _message = '';
  String _customJson = '';



//  初始化
//   void initXUpdate() {
//     if (Platform.isAndroid) {
//       FlutterXUpdate.init(
//         ///是否输出日志
//           debug: true,
//           ///是否使用post请求
//           isPost: false,
//           ///post请求是否是上传json
//           isPostJson: false,
//           ///是否开启自动模式
//           isWifiOnly: false,
//           ///是否开启自动模式
//           isAutoMode: false,
//           ///需要设置的公共参数
//           supportSilentInstall: false,
//           ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
//           enableRetry: false
//       ).then((value) {
//         SQToast.show("初始化成功: $value");
//       }).catchError((error) {
//         print(error);
//       });
//
//       FlutterXUpdate.setErrorHandler(
//           onUpdateError: (Map<String, dynamic> message) async {
//             print(message);
//             setState(() {
//               _message = "$message";
//             });
//           });
//
//     } else {
//       SQToast.show("ios暂不支持XUpdate更新");
//     }
//   }

  // void checkUpdateDefault() {
  //   FlutterXUpdate.checkUpdate(url: '_updateUrl');
  // }

  @override
  void initState() {
    super.initState();
    // checkUpdateDefault();
    // print('appName:'+appName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('111'),
      ),
    );
  }
}
