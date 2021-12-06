import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test/model/toast.dart';
// import 'package:xiaopijiang/utils/assets_util.dart';
// import 'package:xiaopijiang/utils/toast_util.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
///created by WGH
///on 2020/7/23
///description:版本更新提示弹窗
class UpdateDialog extends Dialog {
  final String upDateContent;
  var version;
  final String appUrl;
  final bool isForce;
  UpdateDialog({required this.upDateContent,required this.version,required this.appUrl,required this.isForce});

  var _savePath;
  var _value;
  var flag = false;
  _getSavePath() async {
    var directory = await getExternalStorageDirectory();
    String storageDirectory = directory!.path;
    _savePath = storageDirectory;
    print("StorageDirectory:${_savePath}");

    //请求下载
    _download();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
            width: 319,
            height: 390,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'images/up.png',
                  // fit: BoxFit.cover,
                  // height: 200,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height:22,
                        margin: EdgeInsets.only(top: 158),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text('发现新版本',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 165, 177, 206),
                                      decoration: TextDecoration.none)),
                            ),
                            Container(
                              child: Text('V$version',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 162, 174, 203),
                                      decoration: TextDecoration.none)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Text(upDateContent,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                decoration: TextDecoration.none)),
                      ),
                      Container(
                        child: flag == false ? button() : LinearProgress(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Offstage(
              offstage: isForce,
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Icon(
                    Icons.highlight_off,
                    size: 35,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );


  }

  Widget LinearProgress(){
    return Container(
      // width: 250,
      // height: 40,
      margin: EdgeInsets.only(bottom: 30),
      child: new LinearProgressIndicator(
        backgroundColor: Color.fromARGB(255, 207, 211, 217),
        value: _value,
        valueColor: new AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 165, 177, 206)),
      ),
    );
  }

  Widget button(){
    return Container(
      width: 250,
      height: 40,
      margin: EdgeInsets.only(bottom: 15),
      child: RaisedButton(
          color: Color.fromARGB(255, 165, 177, 206),
          shape: StadiumBorder(),
          child: Text(
            '立即更新',
            style:
            TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            // ToastUtil.showTips('下载apk');
            //获取储存地址
            _getSavePath();
            SQToast.show('开始下载');
          }),
    );
  }



  //下载app
  _download() async {

    flag = true;
    // _checkPermission();
    String appName = "纸映";
    String downPath = "$_savePath/$appName";
    String apkUrl = appUrl; //远程应用地址
    Dio dio = new Dio();
    print("$downPath");
    await dio.download(
        apkUrl, downPath, onReceiveProgress: (int count, int total) {
      // print("${(count / total * 100).toStringAsFixed(0)}%");
      SQToast.show("${(count / total * 100).toStringAsFixed(0)}%");
        // _value = double.tryParse((count / total).toStringAsFixed(1));
      // setState(() {
      //   _value = double.tryParse((count / total).toStringAsFixed(1));
      // });
    });
    SQToast.show('下载完成');
    // print("$downPath");
    await OpenFile.open(
        downPath, type: "application/vnd.android.package-archive");
    // await downPath.delete();
  }

  /**
   *  检测存储权限
   * */
  // Future<bool> _checkPermission() async {
  //   if (Theme
  //       .of(context)
  //       .platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     } else {
  //       return true;
  //     }
  //   }
  //   return false;
  // }


  static showUpdateDialog(
      BuildContext context, String mUpdateContent,iversion,iappUrl, bool mIsForce) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: UpdateDialog(
                  upDateContent: mUpdateContent, version: iversion, appUrl: iappUrl, isForce: mIsForce),onWillPop: _onWillPop);
        });
  }

  static Future<bool> _onWillPop() async{
    return false;
  }

}