import 'package:flutter/material.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/toast.dart';
import 'package:test/page/my/about.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test/page/my/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:test/page/my/my_upload.dart';

/**
 *
 * 创建人：xuqing
 * 创建时间：2020年11月14日16:28:54
 * 类说明：我的个人
 *
 *
 */
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}
class _MyHomePageState extends State<MyHomePage> {
  var  user_token;
  var  user_name=null;
  var  user_phone;
  var  user_follow=null;
  var  user_integral=null;
  var  user_thumbs=null;
  var  user_uid=null;

  void read() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_token =prefs.getString('user_token');
      user_uid =prefs.getInt('user_uid');
      // user_name =prefs.getString('user_name');
      // user_phone =prefs.getString('user_phone');
      // user_follow =prefs.getString('user_follow');
      // user_integral =prefs.getString('user_integral');
      // user_thumbs =prefs.getString('user_thumbs');
    });
    // print('$user_uid');
    return user_uid !=null ? loading() : 'null';
  }

  void loading() async{
    print('$user_uid');
    var url = Uri.parse('$http_url/api/info?uid=$user_uid');
    http.Response response = await http.get(url,headers: {'token':'$user_token'});
    final json = jsonDecode(response.body);
    final moviesMap = json['data']['results'][0];

    user_name = moviesMap['username'];
    user_phone = moviesMap['phone'];
    user_follow = moviesMap['follow'];
    user_integral = moviesMap['integral'];
    user_thumbs = moviesMap['thumbs'];

    print(moviesMap);
  }

  @override
  void initState() {
    super.initState();
    read();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        // color: Colors.black26,
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      color: Color.fromARGB(255, 165, 177, 206),
                      height: 250,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            flag()
                          ],
                        )
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                        child: Container(
                          height: 130,
                          // color: Colors.red,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(20, 190, 20, 0),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(30),
                            height: 110,
                            width: 350,
                            // color: Colors.white,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        user_thumbs != null ? user_thumbs: 'null',
                                        style: TextStyle(
                                          fontSize: 18,
                                          /*字体加粗*/
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ),
                                    Container(
                                        child: Text(
                                            '点赞',
                                          style: TextStyle(
                                            color: Colors.black45,
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          user_follow != null ? user_follow : 'null',
                                          style: TextStyle(
                                            fontSize: 18,
                                            /*字体加粗*/
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                    ),
                                    Container(
                                        child: Text(
                                          '粉丝',
                                          style: TextStyle(
                                            color: Colors.black45,
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                          user_integral != null ? user_integral : 'null',
                                          style: TextStyle(
                                            fontSize: 18,
                                            /*字体加粗*/
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                    ),
                                    Container(
                                        child: Text(
                                          '积分',
                                          style: TextStyle(
                                            color: Colors.black45,
                                          ),
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    )
                    // Container(
                    //   color: Color.fromARGB(255, 207, 211, 217),
                    //   alignment: const FractionalOffset(0.5, 0.9),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //         Container(
                    //           width: 200,
                    //           height: 50,
                    //           child: RaisedButton(
                    //             child: Text('立即登录'),
                    //             onPressed: (){},
                    //             textColor: Colors.black,
                    //             color: Colors.yellowAccent,
                    //             elevation: 15,
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    // ),
                    // Stack(
                    //   children: <Widget>[
                    //     Positioned(
                    //         child: Container(
                    //           height: 50,
                    //           color: Colors.red,
                    //         )
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ClipRRect(
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: 500,
                    // color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              color: Color.fromARGB(255, 240, 240, 240),
                              height: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  //动态
                                  InkWell(
                                    onTap: (){
                                      SQToast.show('等待开放');
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Icon(
                                                  LineAwesomeIcons.telegram,
                                                  color: Color.fromARGB(255, 165, 177, 206),
                                                ),
                                              ),
                                              Container(
                                                child: Text('我的动态',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  LineAwesomeIcons.angle_right,
                                                  color: Color.fromARGB(255, 165, 177, 206),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //我的收藏
                                 InkWell(
                                   onTap: (){
                                     SQToast.show('等待开放');
                                   },
                                   child:  Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Container(
                                         child: Row(
                                           children: <Widget>[
                                             Container(
                                               margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                               child: Icon(
                                                 LineAwesomeIcons.star_1,
                                                 color: Color.fromARGB(255, 165, 177, 206),
                                               ),
                                             ),
                                             Container(
                                               child: Text('我的收藏',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 16
                                                 ),
                                               ),
                                             )
                                           ],
                                         ),
                                       ),
                                       Container(
                                         child: Row(
                                           children: <Widget>[
                                             Container(
                                               child: Icon(
                                                 LineAwesomeIcons.angle_right,
                                                 color: Color.fromARGB(255, 165, 177, 206),
                                               ),
                                             )
                                           ],
                                         ),
                                       )
                                     ],
                                   ),
                                 ),

                                  //我的上传
                                  InkWell(
                                    onTap: (){
                                      if(user_uid!=null){
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) {
                                              return new My_upload(title:'我的上传');
                                            },
                                          ),
                                        );
                                      }else{
                                        SQToast.show('请登录');
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Icon(
                                                  LineAwesomeIcons.arrow_up,
                                                  color: Color.fromARGB(255, 165, 177, 206),
                                                ),
                                              ),
                                              Container(
                                                child: Text('我的上传',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  LineAwesomeIcons.angle_right,
                                                  color: Color.fromARGB(255, 165, 177, 206),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        // 关于
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () async {
                                //获取版本
                                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                String version = packageInfo.version;

                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new about(version:version);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Color.fromARGB(255, 240, 240, 240),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Icon(
                                              LineAwesomeIcons.info_circle,
                                              color: Color.fromARGB(255, 165, 177, 206),
                                            ),
                                          ),
                                          Container(
                                            child: Text('关于',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Icon(
                                              LineAwesomeIcons.angle_right,
                                              color: Color.fromARGB(255, 165, 177, 206),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
  Widget flag(){
    return user_uid != null ? loging() : login();
  }

  Widget login(){
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return new Login();
            },
          ),
        );
      },
      child: Container(
          color: Colors.white,
          width: 200,
          height: 50,
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text('登录',
              style: TextStyle(
                  color: Color.fromARGB(255, 165, 177, 206),
                  fontWeight: FontWeight.w600
              ),
            ),
          )
      ),
    );
  }

  Widget loging(){
    return Column(
      children: <Widget>[
        Container(
          color: Color.fromARGB(255, 165, 177, 206),
          height: 100,
          width: 100,
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 165, 177, 206),
            //头像半径
            radius: 60,
            //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
            backgroundImage: NetworkImage(
                'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text( user_name != null ? user_name : 'null',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black45,
            ),
          ),
        )
      ],
    );
  }
}