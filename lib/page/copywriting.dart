import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test/http/article.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/Picture_Full.dart';
import 'package:test/model/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/model/toast.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:test/page/article_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test/model/text_view.dart';

/*话题文章*/

class Copywriting extends StatefulWidget {


  var copywriting;
   Copywriting({Key? key, required this.copywriting}) : super(key: key);


  @override
  _CopywritingState createState() => _CopywritingState();
}

class _CopywritingState extends State<Copywriting> with SingleTickerProviderStateMixin {

  //标题透明度
  double _headerOpacity = 0.0;
  //滑动控制器
  ScrollController _scrollController = new ScrollController();
  late TabController _tabController;

  //如果数据不存在就隐藏
  late bool imgvisible; //图片
  late bool titlevisible; //标题
  late bool contentvisible; //内容

  //帖子
  var article_item;
  var article_itemCount;

  var page_num = 1;

  void article() async {
    int cid  = widget.copywriting.id;
    Article article = await Http.article('$http_url/article/list?page_num=1&page_size=5&cid=$cid');
    // Article article = await Http.article('$http_url/article/list');
    setState(() {
      article_itemCount = article.data.length;
      article_item = article.data;
      page_num = 1;
    });
  }



  void articles() async {

    int cid  = widget.copywriting.id;
    Article article = await Http.article('$http_url/article/list?page_num=$page_num&page_size=5&cid=$cid');
    // Article article = await Http.article('$http_url/article/list');
    setState(() {
      article_itemCount = article_itemCount+article.data.length;
      article_item = article_item+article.data;
    });
    if(article.data.length ==0){
      SQToast.show('已经加载完毕');
    }
  }

//检查是否登录
  late File _userImage;
  var user_token;
  var user_uid;
//判断是否重复上传
  var flag;

  void read() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_token =prefs.getString('user_token');
      user_uid =prefs.getInt('user_uid');
      // user_phone =prefs.getString('user_phone');
      // user_follow =prefs.getString('user_follow');
      // user_integral =prefs.getString('user_integral');
      // user_thumbs =prefs.getString('user_thumbs');
    });
    // print('$user_uid');
  }

  //下拉刷新
  // Future _refresh() async{
  //   article();
  //   SQToast.show('已刷新');
  // }


  var total=0;
  int  datasize=0;

  @override
  void initState(){
    super.initState();
    //检查是否登录
    read();

    _tabController = TabController(vsync: this,length: 2);

    _scrollController.addListener(() {
      //获取滑动距离
      double offset = _scrollController.offset;
      if(offset <= 160){
        // _headerOpacity = offset/160;
        // print(offset);
        setState(() {
          _headerOpacity = offset/160;
        });
      }
    });


    article();


    // _scrollController.addListener(() {
    //   var maxScroll = _scrollController.position.maxScrollExtent;
    //   var pixel = _scrollController.position.pixels;
    //   if (maxScroll == pixel && article_itemCount < total&&datasize<=1) {
    //     setState(() {
    //       SQToast.show('正在加载中...');
    //     });
    //     articles();
    //   } else {
    //     setState(() {
    //       SQToast.show('没有更多数据');
    //     });
    //   }
    // });

    // print(widget.copywriting.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // 获取屏幕宽度
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: NestedScrollView(
        //绑定透明度
        controller: _scrollController,
        // body: bulldBody(),
        body: buildTabBarView(),
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
          return [
            SliverAppBar(
                automaticallyImplyLeading: false,
              //值为true标题会停留
              pinned: true,
              title: Opacity(
                opacity: _headerOpacity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        // padding: EdgeInsets.only(right: 60),
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          // print("点击返回图标");
                          Navigator.pop(context);
                        },
                      ),
                      Center(
                        child: Text(widget.copywriting.title,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                      ),
                      Container(
                        width: 50,
                        child: IconButton(
                          // padding: EdgeInsets.only(right: 60),
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            // print("点击返回图标");
                            // Navigator.pop(context);
                            if(user_uid != null){
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) {
                                    return new Article_edit();
                                  },
                                ),
                              );
                            }else{
                              SQToast.show('未登录');
                            }

                          },
                        ),
                      )
                    ],
                  )
                )),
              //展开的高度
              expandedHeight: height/2.8,
                //背景颜色
                backgroundColor: Colors.blueGrey,
             //可折叠隐藏的部分
             flexibleSpace: FlexibleSpaceBar(
               background: Container(
                 child:
                 // Stack(
                 //   children: <Widget>[
                 //     Container(child: Image.network('https://www.005.tv/uploads/allimg/200401/66-200401163SS19.jpg',fit: BoxFit.cover,height: 250,),),
                 //   ],
                 // ),
                 Stack(children: <Widget>[
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.transparent,
                       image: DecorationImage(
                         fit: BoxFit.cover,
                         image: NetworkImage(
                           widget.copywriting.img,
                         ),
                       ),
                     ),
                     // height: 20.0,
                   ),
                   Container(
                     margin: EdgeInsets.only(right: 15,left: 15),
                     child: Center(
                       child: Container(
                             // height: 200,
                             // width: 200,
                             // color: Colors.white,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Container(margin: EdgeInsets.only(bottom: 10),child: Text(widget.copywriting.title,style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),),
                                 Container(margin: EdgeInsets.only(bottom: 10),child: Text('简介:'+widget.copywriting.introduction,style: TextStyle(fontSize: 14,color: Colors.white),),),
                                 new Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: <Widget>[
                                     Container(child: Text('标语：'+widget.copywriting.slogan,style: TextStyle(fontSize: 14,color: Colors.white),),),
                                     Container(
                                       height: 30,
                                       width: 60,
                                       child: RaisedButton(
                                         child: Text('关注',style: TextStyle(fontSize:12,color: Colors.white,fontWeight: FontWeight.bold),),
                                         color: Colors.white54,
                                         shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(20)
                                         ),
                                         onHighlightChanged:(bool b) {
                                           print(b);
                                         },
                                         onPressed: (){},
                                       ),)
                                   ],
                                 )
                                 // Container(child: Text('这是个标题',style: TextStyle(fontSize: 18),),)
                               ],
                             ),
                           ),

                           // Container(
                           //   height: 30,
                           //     width: 60,
                           //     child: RaisedButton(
                           //   child: Text('关注',style: TextStyle(fontSize:12,color: Colors.white,fontWeight: FontWeight.bold),),
                           //   color: Colors.white54,
                           //   shape: RoundedRectangleBorder(
                           //       borderRadius: BorderRadius.circular(20)
                           //   ),
                           //   onHighlightChanged:(bool b) {
                           //     print(b);
                           //   },
                           //   onPressed: (){},
                           // ),)


                     )
                   ),
                   Container(
                     // height: 300.0,
                     decoration: BoxDecoration(
                         color: Colors.black87,
                         gradient: LinearGradient(
                             begin: FractionalOffset.topCenter,
                             end: FractionalOffset.bottomCenter,
                             colors: [
                               Colors.grey.withOpacity(0.0),
                               Colors.black87,
                             ],
                             stops: [
                               0.1,
                               0.9
                             ])),
                   )
                 ]),
               )
             ),
              shadowColor: Colors.blueGrey,
              bottom: TabBar(
                indicatorWeight: 3.0,

                // tab标题大小
                // unselectedLabelStyle: TextStyle(fontSize: 14), // 未选择样式
                // labelStyle: TextStyle( fontSize: 16,height: 2), // 选择的样式
                labelColor: Color.fromARGB(255, 165, 177, 206),
                indicatorColor: Color.fromARGB(255, 165, 177, 206),
                unselectedLabelColor: Color.fromARGB(255, 207, 211, 217),
                controller: _tabController,
                tabs: <Widget>[
                  new Tab(
                    text: "最新推荐",
                  ),
                  new Tab(
                    text: "最新图集",
                  ),
                  // new Tab(
                  //   text: "标签三",
                  // ),
                ],
              )
            ),
          ];
        },
      )

    );
  }



  TabBarView buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Container(
      child: Center(
        child:  view()
          // child: Container(
          //   color: Colors.pink,
          //   child: Text("这是热门的内容"),
          // )
      ),
    ),
        Center(
            child: Text("暂无最新图集")
        ),
        // Center(
        //     child: Text("这是关注的内容")
        // )
      ],
    );
  }

  Widget huati (){
    if(article_item != null){
      return  ScrollConfiguration(
          behavior: CusBehavior(),
          child: SizedBox(
                  child: Container(
                    decoration: new BoxDecoration(
                      //背景
                      // color: Colors.white,
                      color: Color.fromARGB(255, 242, 241, 246),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      //设置四周边框
                      // border: new Border.all(width: 8, color: Colors.white),
                    ),

                    // color: Color.fromARGB(255, 242, 241, 246),
                    // color: Color.fromARGB(255, 242, 241, 246),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Container(

                        //设置 child 居中
                        alignment: Alignment(0, 0),
                        //边框设置
                        decoration: new BoxDecoration(
                          //背景
                          // color: Colors.white,
                          color: Color.fromARGB(255, 242, 241, 246),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          //设置四周边框
                          // border: new Border.all(width: 8, color: Colors.white),
                        ),

                        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: EasyRefresh.custom(
                          header: MaterialHeader(),
                          footer: MaterialFooter(),
                          onRefresh: () async {
                            // await Future.delayed(Duration(seconds: 2), () {
                            //   if (mounted) {
                            //     setState(() {
                            //       article_itemCount = 10;
                            //     });
                            //   }
                            // });
                            // print('下拉');
                            article();
                          },
                          onLoad: () async {
                            // await Future.delayed(Duration(seconds: 2), () {
                            //   if (mounted) {
                            //     setState(() {
                            //       article_itemCount += 10;
                            //     });
                            //   }
                            // });
                            //     setState(() {
                            //       page_num +=2;
                            //     });
                            //每次上拉加载五条数据
                            page_num +=5;
                            articles();
                            // print('上拉');
                          },
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return SubscribeAccountCard(article_item[index]);
                                },
                                childCount: article_itemCount,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              )
      );
    }else{
      return loadings();
      //下面这个行代码乱写的
      // return itemCount;
    }
  }


  //文章内容
  Widget SubscribeAccountCard (index){
    //用户
    String iconPath = index.icon; //头像
    String namePath = index.username; //名字
    String copyrightPath = index.copyright; //文章版权

    //文章
    var imgPath = index.img; //图片
    List img =  jsonDecode(imgPath);
    // print(img == null);
    // print(img);
    //如果图片存在则显示，不然就隐藏
    if(img[0] != ''){
        imgvisible = false;
    }else{
        imgvisible = true;
    }

    String titlePath = index.title; //标题
    String contentPath = index.content; //内容

    if(titlePath != ''){
      titlevisible = false;
    }else{
      titlevisible = true;
    }


    if(contentPath != ''){
      contentvisible = false;
    }else{
      contentvisible = true;
    }



    String favsPath = index.favs; //喜欢(收藏)
    String rankPath = index.rank; //点赞(点赞)
    String concernsPath = index.rank; //浏览(关注)总数

    var indexPath = index; //全部

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      // height: 200,
      //设置 child 居中
      alignment: Alignment(0, 0),
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.white),
      ),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //用户信息
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          //头像半径
                          radius: 60,
                          //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                          backgroundImage: NetworkImage(
                              iconPath
                          ),
                        )
                    ),
                    Container(
                      // color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(namePath,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(copyrightPath,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          //文案文字内容
          //标题
          Offstage(
            offstage: titlevisible,
            child: Container(
              // margin: EdgeInsets.only(top: 20),
              // color: Colors.red,
              alignment:Alignment.bottomLeft,
              // height: 20,
              child: Text(
                titlePath,
                textAlign:TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          //内容
          Offstage(
            offstage: contentvisible,
            child: Container(
              // color: Colors.red,
              alignment:Alignment.bottomLeft,
              // height: 20,

              // padding: EdgeInsets.symmetric(vertical: 30.0),
              // height: 100.0,
              // color: Colors.white,
              child:
              // TextView(
              //   onTextViewCreated: _onTextViewCreated,
              // ),

              Text(
                contentPath,
                textAlign:TextAlign.left,
                style: TextStyle(
                  // fontSize: 15,
                  color: Colors.black54,
                ),
                maxLines: 6, //最大行数
                // textScaleFactor: 0.5, //字体缩放
              ),
            ),
          ),

          // 图片内容
         Offstage(
           offstage: imgvisible,
           child:  Container(
               height: 110.0,
               margin: EdgeInsets.only(top: 10),
               // color: Colors.red,
               alignment:Alignment.bottomLeft,
               child: Row(
                 children: <Widget>[
                   Expanded(
                       child: SizedBox(
                         child:  ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: img.length,
                           itemBuilder: (context, index) {
                             // return images(data: subscribeAccountList[index]);

                             return images(img[index]);
                             if(img.length != 0){
                               return images(img[index]);
                             }else{
                               return images(img[index]);
                             }
                           },
                         ),
                       ))
                 ],
               )
           ),
         ),


          //文案点赞及功能
          Container(
            padding: EdgeInsets.only(bottom: 10,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.visibility_rounded,
                      color: Color.fromARGB(255, 207, 211, 217),
                      size: 20,
                    ),
                    Text(
                      '浏览 $concernsPath',
                      style: TextStyle(
                          color: Color.fromARGB(255, 207, 211, 217),
                          fontSize: 12
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up_off_alt,
                      color: Color.fromARGB(255, 207, 211, 217),
                      size: 20,
                    ),
                    Text(
                      '点赞 $rankPath',
                      style: TextStyle(
                          color: Color.fromARGB(255, 207, 211, 217),
                          fontSize: 12
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      color: Color.fromARGB(255, 207, 211, 217),
                      size: 20,
                    ),
                    Text(
                      '喜欢 $favsPath',
                      style: TextStyle(
                          color: Color.fromARGB(255, 207, 211, 217),
                          fontSize: 12
                      ),
                    ),
                  ],
                )
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget view(){
    if(article_itemCount != 0){
      return huati();
    }else{
      return loading();
      //下面这个行代码乱写的
      // return itemCount;
    }
  }

  Widget images(index) {
    // 获取屏幕宽度
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // var imgPath = index.img;
    String img = index;
    return InkWell(
        child: Container(
            margin: EdgeInsets.only(right: 2,left: 2),
            // height: 20,
            width: width/3-20.5,
            child:
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),//弧度
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                imageUrl: img,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
        ),
      //点击1图片放大
      onTap: (){
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return new Picture_Full(img:img);
            },
          ),
        );
        print(img);
      },
      );
  }


  Widget loading() {
    return new Material(
        child: Container(
          // height: 100,
          //   color: Color.fromARGB(255, 165, 177, 206),
            // padding: const EdgeInsets.all(50.0),
            child: Center(
              // color: Colors.yellow[300],
              // size: 20.0,
              child: Text('还没有人来过',
                style: TextStyle(
                  color:Colors.grey, // 文字颜色
                ),
              ),
            )
        )
    );
  }

  Widget loadings() {
    return new Material(
        child: Container(
            // color: Color.fromARGB(255, 165, 177, 206),
            // padding: const EdgeInsets.all(50.0),
            child: SpinKitRotatingCircle(
              color: Colors.grey,
              size: 20.0,
            )
        )
    );
  }


}

void _onTextViewCreated(TextViewController controller) {
  controller.setText('Hello from Android!');
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

