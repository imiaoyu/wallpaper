import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test/http/http_url.dart';
// import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:test/model/toast.dart';
import 'package:test/model/updata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:test/model/updateDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class about extends StatefulWidget {
  String version;
  about({Key? key,required this.version}) : super(key: key);


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
  // var user_token;
  // var version=null;

  // void _version() async{
  //   //获取版本
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String appName = packageInfo.appName;
  //   String packageName = packageInfo.packageName;
  //   version = packageInfo.version;
  //   String buildNumber = packageInfo.buildNumber;
  //   // SQToast.show(version);
  // }
  late bool flags;
  void _initPackageInfo() async {
    //获取版本
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   String appName = packageInfo.appName;
    //   String packageName = packageInfo.packageName;
    //   String version = packageInfo.version;
    //   String buildNumber = packageInfo.buildNumber;
    //   SQToast.show(version);


    //获取token
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   user_token =prefs.getString('user_token');
    //   // user_uid =prefs.getInt('user_uid');
    //   // user_follow =prefs.getString('user_follow');
    //   // user_integral =prefs.getString('user_integral');
    //   // user_thumbs =prefs.getString('user_thumbs');
    // });

    //请求更新数据
    var url = Uri.parse('$http_url/app/update');
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final jsons = json['data'][0];
    var versions = jsons['version'];
    var title = jsons['title'];
    var appUrl =jsons['appUrl'];
    var flag = jsons['flag'];

    if(flag == 0){
      flags = false;
    }else{
      flags = true;
    }

    // print(flag);

    // String version = version.toString();
    // print(versions);

    // haveNewVersion(versions, version);
    print(haveNewVersion(versions, widget.version, title, appUrl,flags));
    // if(versions > int.parse(version)){
    //   UpdateDialog.showUpdateDialog(context, "1.优化用户体验\n2.增加上传功能\n3.修复已知bug\n迭代版本0.0.2", false);
    // }else{
    //   SQToast.show('版本已是最新');
    // }



    // UpdateDialog.showUpdateDialog(context, "1.优化用户体验\n2.增加上传功能\n3.修复已知bug\n迭代版本0.0.2", false);
  }

  //判断版本号是否升级
  bool haveNewVersion(String newVersion, String old,title,appUrl,bool flag) {
    if (newVersion == null || newVersion.isEmpty || old == null || old.isEmpty)
      return false;
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.length == 0 || oldList.length == 0) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        print(newVersion);
        UpdateDialog.showUpdateDialog(context, title, newVersion, appUrl, flag);
        return true;
      } else if (newVersionInt < oldVersion) {
        SQToast.show('版本已是最新');
        return false;
      }
    }
    SQToast.show('版本已是最新');
    return false;
  }



  @override
  void initState() {
    // _version();
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
    // 获取屏幕宽度
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,15),//x,y轴
                      color: Colors.black12,//投影颜色
                      blurRadius: 10.0,//投影距离
                      spreadRadius: -3.0
                  )
                ]
            ),
            margin: EdgeInsets.only(top: 20),
            height: height/1.5,
            width: width/1.2,
            // color: Color.fromARGB(255, 207, 211, 217),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    // color: Color.fromARGB(255, 165, 177, 206),
                    padding: EdgeInsets.only(bottom: 10),
                    // height: height/5,
                    child: Image.asset(
                      'images/update.png',
                      fit: BoxFit.cover,
                    ),
                    // width: 100,
                    // child: CircleAvatar(
                    //   //头像半径
                    //   radius: 60,
                    //   //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                    //   backgroundImage: NetworkImage(
                    //       'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'
                    //   ),
                    // )
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('纸映',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600
                          // color: Colors.black45,
                          // color: Colors.black45
                        ),
                      ),
                      Text(widget.version.toString(),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600
                          // color: Colors.black45,
                          // color: Colors.black45
                        ),
                      ),
                    ],
                  )
                ),
                // Container(
                //   padding: EdgeInsets.only(right: 15),
                //   child: Divider(
                //     height: 0.5,
                //     indent: 16.0,
                //     color: Color.fromARGB(255, 207, 211, 217),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text('当前版本： ',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         // color: Color.fromARGB(255, 207, 211, 217),
                      //       ),
                      //     ),
                      //     Text('1.0.0',
                      //       style: TextStyle(
                      //           fontSize: 16,
                      //         // color: Color.fromARGB(255, 207, 211, 217),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text('Bug反馈： ',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: Colors.black45,
                      //       ),
                      //     ),
                      //     Text('imiaoyu00@gmail.com',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: Colors.black45,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(top: height/25),
                        child: InkWell(
                          onTap: (){
                            // SQToast.show('已是最新版');
                            _initPackageInfo();
                          },
                          child: Container(
                              color: Color.fromARGB(255, 165, 177, 206),
                              width: 100,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text('更新',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                          ),
                        )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text('  用户协议',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text('隐私政策  ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
                              ),
                            )
                          ],
                        ),
                      )

                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
