import 'package:flutter/material.dart';
import 'package:test/page/my/about.dart';
/**
 *
 * 创建人：xuqing
 * 创建时间：2020年11月14日16:28:54
 * 类说明： 普通贝塞尔曲线
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
  @override
  void initState() {
    super.initState();
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
            Stack(
              alignment:Alignment.center ,
              // fit: StackFit.expand,
              children: <Widget>[
                ClipPath(
                    clipper: BottomClippertest(),
                    child: Container(
                      // color: Colors.blueGrey,
                      height: 300,
                      // width: MediaQuery.of(context).size.width * 0.8,
                      // height: MediaQuery.of(context).size.width * 0.8 * 1.33,
                      //背景装饰
                      decoration: BoxDecoration(
                        //线性渐变
                        gradient: LinearGradient(
                          //渐变使用到的颜色
                          colors: [Colors.black87, Colors.black],
                          //开始位置为右上角
                          begin: Alignment.topRight,
                          //结束位置为左下角
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        child: Text('立即登录'),
                        onPressed: (){},
                        textColor: Colors.black,
                        color: Colors.yellowAccent,
                        elevation: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: 500,
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white10,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                              child: Icon(
                                                Icons.grade,
                                                color: Colors.yellowAccent,
                                              ),
                                            ),
                                            Container(
                                              child: Text('我的收藏',
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                Icons.arrow_forward_ios,
                                                color: Colors.yellowAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                              child: Icon(
                                                Icons.arrow_upward,
                                                color: Colors.yellowAccent,
                                              ),
                                            ),
                                            Container(
                                              child: Text('我的上传',
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                Icons.arrow_forward_ios,
                                                color: Colors.yellowAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ),
                        // 关于
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new about();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white10,
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
                                              Icons.info,
                                              color: Colors.yellowAccent,
                                            ),
                                          ),
                                          Container(
                                            child: Text('关于',
                                              style: TextStyle(
                                                  color: Colors.white,
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
                                              Icons.arrow_forward_ios,
                                              color: Colors.yellowAccent,
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
}
class  BottomClippertest extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, 0); //第一个点
    path.lineTo(0, size.height-100);//第二个点
    var firstControlPoint=Offset(size.width/2, size.height);  //曲线开始点
    var firstendPoint=Offset(size.width, size.height-80); // 曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstendPoint.dx, firstendPoint.dy);
    path.lineTo(size.width, size.height-80); //第四个点
    path.lineTo(size.width,0);  // 第五个点
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}