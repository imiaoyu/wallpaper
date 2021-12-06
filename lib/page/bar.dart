import 'package:flutter/material.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/crop.dart';
import 'package:test/model/toast.dart';
// import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:test/page/bar.dart';
import 'package:test/page/contribution.dart';
import 'package:test/page/copywriting.dart';
import 'package:test/page/home.dart';
import 'package:test/page/images.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:test/page/my.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test/page/atlas.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:test/page/my/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/page/my/update_images.dart';
import 'package:test/page/upload_qiniu.dart';
import 'package:test/model/updateDialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(Bar());

class Bar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Bubble Bottom Bar Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: BarPage(title: '这是一个标题'),
    // );
    return BarPage(title: '这是一个标题');
  }
}

class BarPage extends StatefulWidget {

  BarPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _BarPageState createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  final PageController controller = PageController(
    initialPage: 0,
  );

  // setPermission() async {
  //   if (await Permission.storage.request().isGranted) {   //判断是否授权,没有授权会发起授权
  //     print("获得了储存授权");
  //   }else{
  //     print("没有获得储存授权");
  //   }
  // }
  //
  // Future requstPermission() async {       //授权多个权限
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();
  // }

  late bool flags;
  void _initPackageInfo() async {
    //获取版本
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      // SQToast.show(version);


    //请求更新数据
    var url = Uri.parse('$http_url/app/update');
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final jsons = json['data'][0];
    var versions = jsons['version'];
    var title = jsons['title'];
    var appUrl =jsons['appUrl'];
      var flag = jsons['flag'];
    // print(versions);

      if(flag == 0){
        flags = false;
      }else{
        flags = true;
      }
    print(haveNewVersion(versions, version, title, appUrl,flags));

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
        // print(newVersion);
        UpdateDialog.showUpdateDialog(context, title, newVersion, appUrl, flag);
        return true;
      } else if (newVersionInt < oldVersion) {
        // SQToast.show('版本已是最新');
        return false;
      }
    }
    // SQToast.show('版本已是最新');
    return false;
  }

  late int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;

    // 是否升级
    _initPackageInfo();
    // setPermission();
  }

  void changePage(int index) {
    // controller.jumpToPage(index);
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[300],
      // ),
      // body: Row(
      //   children: <Widget>[
      //     Text(currentIndex.toString())
      //   ],
      // ),
      body: IndexedStack(
        children: <Widget>[
            Home(),
          // Login(),


            Update(),

           // Copywriting(),
          //  ImageSizePage(),
          //   Container(color: Colors.green),
            MyHomePage()
          ],
          index:currentIndex,
      ),

      // PageView(
      //   controller: controller,
      //   children: <Widget>[
      //     Home(),
      //     My(),
      //     // TravelPage(),
      //     // MyPage(),
      //   ],
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('add');
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        //底部导航栏的创建需要对应的功能标签作为子项，这里我就写了3个，每个子项包含一个图标和一个title。
        items: [
          BottomNavigationBarItem(
            // backgroundColor: Color.fromARGB(255, 165, 277, 206),
              icon: Icon(
                IconlyBold.home,
                color: Color.fromARGB(255, 207, 211, 217),
                size: 35,
              ),
              activeIcon: Icon(
                IconlyBold.home,
                color: Color.fromARGB(255, 165, 177, 206),
                size: 35,
              ),
              title: new Container(),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                IconlyBold.plus,
                color: Color.fromARGB(255, 207, 211, 217),
                size: 35,
              ),
              activeIcon: Icon(
                IconlyBold.plus,
                color: Color.fromARGB(255, 165, 177, 206),
                size: 35,
              ),
              title: new Container()),
          BottomNavigationBarItem(
              icon: Icon(
                IconlyBold.profile,
                color: Color.fromARGB(255, 207, 211, 217),
                size: 35,
              ),
              activeIcon: Icon(
                IconlyBold.profile,
                color: Color.fromARGB(255, 165, 177, 206),
                size: 35,
              ),
              title: new Container()),
        ],
        //这是底部导航栏自带的位标属性，表示底部导航栏当前处于哪个导航标签。给他一个初始值0，也就是默认第一个标签页面。
        currentIndex: currentIndex,
        //这是点击属性，会执行带有一个int值的回调函数，这个int值是系统自动返回的你点击的那个标签的位标
        onTap: (int i) {
          //进行状态更新，将系统返回的你点击的标签位标赋予当前位标属性，告诉系统当前要显示的导航标签被用户改变了。
          setState(() {
            currentIndex = i;
          });
        },
      ),
    );
  }
}