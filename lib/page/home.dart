import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:test/http/a.dart';
import 'package:test/http/conversation.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/toast.dart';
import 'package:test/page/copywriting.dart';
import 'package:test/page/fications.dart';
import 'package:test/page/images.dart';
import 'full_screenimagepage.dart';
import 'package:test/http/entity.dart';
import 'package:test/page/Daily_signature.dart';
import 'package:test/model/http.dart';
import 'package:test/page/images_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return HomePage(title: '首页');
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String Daily_data_image;
  late String Daily_data_title;
  //  日签数据
  void Daily_signature_list() async{

    final entity = await Http.Daily_signature('https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN');
    // Daily_data_image = 'https://cn.bing.com'+entity[0].url;
    // Daily_data_title = entity[0].copyright;
    setState(() {
      Daily_data_image = 'https://cn.bing.com'+entity[0]['url'];
      Daily_data_title = entity[0]['copyright'];
    });
  }

  //  推荐数据
  var recommend_item;
  var recommend_itemCount;
  void recommend() async {
    Entity entity = await Http.imageslist('http://service.picasso.adesk.com/v1/vertical/vertical');
    setState(() {
      recommend_itemCount = entity.res.vertical.length;
      recommend_item = entity.res.vertical;
    });
  }

  //  榜单数据
  var list_item;
  var list_itemCount;
  void List() async {
    Entity entity = await Http.imageslist('https://service.picasso.adesk.com/v1/vertical/vertical?limit=20&skip=180&adult=false&first=0&order=new');
    setState(() {
      list_itemCount = entity.res.vertical.length;
      list_item = entity.res.vertical;
    });
  }

  //精选话题
  var conversation_item;
  var conversation_itemCount;
  void conversation() async {
    Conversation conversation = await Http.conversation('$http_url/api/conversation');
    setState(() {
      conversation_itemCount = conversation.data.length;
      conversation_item = conversation.data;
    });
    // print(conversation_item);
  }



  @override
  void initState() {
    Daily_data_image = 'https://z3.ax1x.com/2021/09/13/4C8RM9.jpg';
    // TODO: implement initState
    super.initState();
    Daily_signature_list();
    recommend();
    List();
    conversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[300],
      // ),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView(
          //使用ListView取消appBar时会出现状态栏空白，使用下行代码取消padding
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            Container(
              // color: Colors.black87,
              child: Column(
                children: <Widget>[
                  //日签
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(Daily_data_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 120,
                        // color: Colors.black87,
                      ),

                      Positioned(
                        left: 10.0,
                        top: 55.0,
                        child: Container(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text("${DateTime.now().day}",
                                textAlign:TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontFamily: 'Roboto-Black',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text("   Day",
                                textAlign:TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Roboto-Black',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        )
                      ),
                      // Positioned(
                      //   left: 95.0,
                      //   top: 82.0,
                      //   //${DateTime.now().year}
                      //   child: Text("  Day",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 18,
                      //       fontFamily: 'Roboto-Black',
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                          right: 25.0,
                          top: 75.0,
                          child: Container(
                            // color: Colors.white,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child:InkWell(
                              child: Text("查看日签",
                                style: TextStyle(
                                  fontSize: 12,
                                  // fontFamily: 'Roboto',
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new Daily_signature(Daily_data_image:Daily_data_image,Daily_data_title:Daily_data_title);
                                    },
                                  ),
                                );
                              },
                            )
                          )
                      ),
                    ],
                  ),
                  //功能栏
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        // margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        decoration: new BoxDecoration(
                          // color: Colors.black87,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Spacer(flex: 1,),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new classification();
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      LineAwesomeIcons.shapes,
                                      // Icons.dashboard,
                                      size: 35,
                                      color: Color.fromARGB(255, 165, 177, 206),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '分类',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 165, 177, 206),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(flex: 1,),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new Images();
                                    },
                                  ),
                                );
                              },
                              // color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      LineAwesomeIcons.chalkboard,
                                      size: 35,
                                      color: Color.fromARGB(255, 165, 177, 206),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '热门',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 165, 177, 206),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(flex: 1,),
                            InkWell(
                              onTap: (){
                                SQToast.show('等待开放');
                              },
                              // color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      LineAwesomeIcons.pen,
                                      size: 35,
                                      color: Color.fromARGB(255, 165, 177, 206),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '话题',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 165, 177, 206),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(flex: 1,),
                            InkWell(
                              onTap: (){
                                SQToast.show('等待开放');
                              },
                              // color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      LineAwesomeIcons.certificate,
                                      size: 35,
                                      color: Color.fromARGB(255, 165, 177, 206),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '专题',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 165, 177, 206),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //最新精选
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        // height: 300.0,
                        // color: Colors.black87,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              height:30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        // Container(
                                        //   child: Icon(
                                        //     Icons.gesture,
                                        //     color: Colors.yellowAccent,
                                        //   ),
                                        // ),
                                        Container(
                                          child: Text('今日精选',
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 18
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) {
                                            return new Images_view(image_list: recommend_item,title_bar:'全部推荐',image_list_count:recommend_itemCount);
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text('全部精选',
                                              style: TextStyle(
                                                  color: Color.fromARGB(255, 165, 177, 206),
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                              LineAwesomeIcons.angle_right,
                                              color: Color.fromARGB(255, 165, 177, 206),
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: new Row(
                                children:<Widget>[
                                  //Row Container嵌套ListView要用 Expanded 和 SizedBox 包裹 不然会报错
                                  Expanded(
                                    child: SizedBox(
                                        height: 230.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context,i){
                                            if(recommend_item != null && recommend_itemCount!=0){
                                              return ImagesListCard(recommend_item[i]);
                                            }else{
                                              return loading();
                                              //下面这个行代码乱写的
                                              // return itemCount;
                                            }

                                          },
                                        )
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      //今日推荐
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        // height: 300.0,
                        // color: Colors.black87,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              height:30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        // Container(
                                        //   child: Icon(
                                        //     Icons.gesture,
                                        //     color: Colors.yellowAccent,
                                        //   ),
                                        // ),
                                        Container(
                                          child: Text('今日推荐',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) {
                                            return new Images_view(image_list: list_item,title_bar:'全部榜单',image_list_count:list_itemCount);
                                          },
                                        ),
                                      );
                                      },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text('全部推荐',
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 165, 177, 206),
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(
                                            LineAwesomeIcons.angle_right,
                                            color: Color.fromARGB(255, 165, 177, 206),
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: new Row(
                                children:<Widget>[
                                  Expanded(
                                    child: SizedBox(
                                        height: 230.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 6,
                                          itemBuilder: (context,i){
                                            if(list_item != null && list_itemCount!=0){
                                              return ImagesListCard(list_item[i]);
                                            }else{
                                              return loading();
                                              //下面这个行代码乱写的
                                              // return itemCount;
                                            }
                                          },
                                        )
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      //精选话题
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        // height: 300.0,
                        // color: Colors.black87,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              height:30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        // Container(
                                        //   child: Icon(
                                        //     Icons.gesture,
                                        //     color: Colors.yellowAccent,
                                        //   ),
                                        // ),
                                        Container(
                                          child: Text('精选话题',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) {
                                            return new Images_view(image_list: list_item,title_bar:'全部专题',image_list_count:list_itemCount);
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text('全部话题',
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 165, 177, 206),
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(
                                            LineAwesomeIcons.angle_right,
                                            color: Color.fromARGB(255, 165, 177, 206),
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: new Row(
                                children:<Widget>[
                                  Expanded(
                                    child: SizedBox(
                                        height: 140.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 6,
                                          itemBuilder: (context,i){
                                            if(conversation_item != null && recommend_itemCount!=0){
                                              return ImagesListCards(conversation_item[i]);
                                            }else{
                                              return loading();
                                              //下面这个行代码乱写的
                                              // return itemCount;
                                            }
                                          },
                                        )
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
                ],
              ),
            )
          ],
        ),
      )

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     Container(
      //       height: 100,
      //       color: Colors.red[300],
      //       child: ListView(
      //         children: <Widget>[
      //         ],
      //       ),
      //     ),
      //   ],
      // )
    );
  }

  //今日精选/推荐 widget
  Widget ImagesListCard(index) {
    String imgPath = index.thumb;
    // String imgPaths = item[index].preview;
    var imgPaths = index;
    return new Material(
        // elevation: 8.0,
        color: Color(0x00000000),
        borderRadius: new BorderRadius.all(
          new Radius.circular(8.0),
        ),
        child:Container(
          margin: EdgeInsets.fromLTRB(0, 0,0, 0),
          // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          //设置圆角
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20),
          //   color: Colors.white,
          // ),
          // color: Colors.white,
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new FullScreenImagePage(imageurl: imgPaths);
                  },
                ),
              );
              // Navigator.of(context).pushNamed('/detailed',arguments:{
              //   'imageurl':imgPaths,
              // });
            },
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    // width:150,
                    // height: 250,
                  padding: EdgeInsets.fromLTRB(10,0,10,0,),
                    // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: new Hero(
                        tag: imgPath,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                              imageUrl: imgPath,
                              fit: BoxFit.cover,
                              // placeholder: (context, url) =>
                              //      Image.asset('assets/wallfy.png'),
                              //有网情况:网络下载图片缓存到本地,当第二次打开时,不下载网络图片,使用缓存到本地的图片,若没有网,没有缓存到本地图片,则使用默认图片.
                              //CachedNetworkImage
                            // imageBuilder: (context, imageProvider) => CircleAvatar(
                            //   radius: 120,
                            //   backgroundImage: imageProvider,
                            // ),
                            // imageBuilder: (context, imageProvider) => Container(
                            //   decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //         image: imageProvider,
                            //         fit: BoxFit.cover,
                            //         colorFilter:
                            //         ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                            //     ),
                            //   ),
                            // ),
                            //   placeholder: (context,url){
                            //     return  SpinKitRotatingCircle(
                            //       color: Colors.yellow,
                            //       size: 20.0,
                            //     );
                            //   },
                             errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        )
                    ),
                  ),
                // Opacity(opacity: 0,
                //   child: Container(
                //     margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                //   ),
                // )
              ],
            ),
          ),
        )
    );
  }

  //精选专题 widget
  Widget ImagesListCards(index) {
    String imgPath = index.img;
    String namePath = index.title;
    String introductionPath = index.introduction;
    // String imgPaths = item[index].preview;
    var imgPaths = index;
    return new Material(
      // elevation: 8.0,
        color: Color(0x00000000),
        borderRadius: new BorderRadius.all(
          new Radius.circular(5.0),
        ),
        child:Container(
          margin: EdgeInsets.fromLTRB(0, 0,0, 0),
          child: new InkWell(
            onTap: () {

              // print(imgPaths.title);

              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new Copywriting(copywriting: imgPaths);
                  },
                ),
              );

              // Navigator.of(context).pushNamed('/detailed',arguments:{
              //   'imageurl':imgPaths,
              // });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                     Container(
                       // width:120,
                       // height: 100,
                       padding: EdgeInsets.fromLTRB(10,0,10,0,),
                       // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisSize: MainAxisSize.max,
                         children: <Widget>[
                           new Container(
                             decoration: BoxDecoration(
                               boxShadow: [//阴影效果
                                 BoxShadow(
                                   offset: Offset(4, 3),//阴影在X轴和Y轴上的偏移
                                   color: Colors.black26,//阴影颜色
                                   blurRadius: 1.0 ,//阴影程v度
                                   spreadRadius: 1, //阴影扩散的程度 取值可以正数,也可以是负数
                                 ),
                               ],
                               // color: Colors.blueGrey,
                               borderRadius: BorderRadius.circular(8.0),
                             ),
                             // color: Colors.red,
                             // height:100,
                             child: Hero(
                                 tag: imgPath,
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(8),
                                   child: CachedNetworkImage(
                                     height: 100,
                                     width: 100,
                                     imageUrl: imgPath,
                                     fit: BoxFit.cover,
                                     errorWidget: (context, url, error) => Icon(Icons.error),
                                   ),
                                 )
                             ),
                           ),
                           Container(
                             padding: EdgeInsets.only(top: 5),
                             height: 40,
                             child: Text('$namePath',
                               style: TextStyle(
                                 fontSize: 12,
                                 color: Colors.grey
                               ),
                             ),
                           )

                         ],
                     ),
                     )
              ]
            ),
          ),
        )
    );
  }


  Widget loading() {
    return new Material(
        child: Container(
          color: Color.fromARGB(255, 165, 177, 206),
            padding: const EdgeInsets.all(50.0),
            child: SpinKitRotatingCircle(
              color: Colors.yellow[300],
              size: 20.0,
            )
        )
    );
  }

}
//阻止listview回弹颜色效果
class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildViewportChrome(context, child, axisDirection);
  }
}