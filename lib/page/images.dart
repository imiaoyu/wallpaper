import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'full_screenimagepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/http/entity.dart';
import 'package:test/model/color.dart';
import 'package:test/model/toast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
/*主页热门*/

class Images extends StatefulWidget{
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images>{
  @override
  Widget build(BuildContext context){
    //一个App只能拥有一个MaterialApp
    // return MaterialApp(
    //     title: '我的',
    //     theme: ThemeData(
    //     // primarySwatch: Colors.blue,
    //   ),
    //   home: ImagesPage(title: '图酷'),
    // );
    return ImagesPage(title: '热门');
  }

}

class ImagesPage extends StatefulWidget {
  ImagesPage({Key? key,required this.title}) : super(key: key);
  final String title;
  @override
  _ImagesPageState createState() => _ImagesPageState();
}


class _ImagesPageState extends State<ImagesPage> with SingleTickerProviderStateMixin {
  // final imgList = "[" + response.body + "]";
  late AnimationController _controller;
  // late Map<String,dynamic> parsedJson;
  var item ;
  var itemCount;
  Future getData() async{
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse('http://service.picasso.adesk.com/v1/vertical/vertical?limit=30&skip=180&adult=false&first=0&order=hot');
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final moviesMap = json['res']['vertical'];
    // print(json);
    Entity entity = Entity.fromJson(json);
    setState(() {
      itemCount = entity.res.vertical.length;
      item = entity.res.vertical;
      // item = entity.res.vertical;
    });
  }


  // @override
  // void didChangeDependencies() {
  //   Future.delayed(Duration(milliseconds: 3000), () {
  //     for (item in item) {
  //       precacheImage(NetworkImage(item.thumb), context);
  //     }
  //     super.didChangeDependencies();
  //   });
  // }


  @override
  void initState() {
    super.initState();
    // item != null && itemCount != null ? getData() : SQToast.show('.....');
    getData();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 207, 211, 217),
        centerTitle:true,
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: new StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: itemCount,
          itemBuilder: (context, i) {
            // if(item != null && itemCount!=0){
            //   return itemWidget(i);
            // }else{
            //   return loading();
            //   //下面这个行代码乱写的
            //  // return itemCount;
            // }
            return  item != null ? itemWidget(i) : loading();
            // return itemWidget(i);
          },
          //  staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2.5 : 2),    //
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      )
    );
  }

  Widget  itemWidget(int index){
    String imgPath = item[index].thumb;
    // String imgPaths = item[index].preview;
    var colors;
    var imgPaths = item[index];
      return new Material(
        elevation: 8.0,
        color: Color(0x00000000),
        borderRadius: new BorderRadius.all(
          new Radius.circular(8.0),
        ),
        child:Container(
          //设置圆角
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
              color: Colors.white70,
          ),
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
            child: new Hero(
                tag: imgPath,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                  // Image(
                  //   image: NetworkImage(imgPath),
                  //   fit: BoxFit.cover,
                  // )
                  CachedNetworkImage(
                      imageUrl: imgPath,
                      fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter:
                            ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                        ),
                      ),
                    ),
                      // placeholder: (context, url) =>
                      //      Image.asset('assets/wallfy.png'),
                      //有网情况:网络下载图片缓存到本地,当第二次打开时,不下载网络图片,使用缓存到本地的图片,若没有网,没有缓存到本地图片,则使用默认图片.
                      //CachedNetworkImage
                      placeholder: (context,url){
                        return  SpinKitRotatingCircle(
                          color: Color.fromARGB(255, 165, 177, 206),
                          size: 20.0,
                        );
                      },
                      errorWidget: (context, url, android) {
                        print('CachedNetworkImage${imgPath}');
                        return Icon(Icons.refresh);
                      },
                  ),
                )
            ),
          ),
        )
      );
  }

  //以下代码废弃，因为会执行两次请求前的加载动画以及缓存图片后也有加载动画
  Widget loading() {
    return Container(
        color: Color.fromARGB(255, 207, 211, 217),
        child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SpinKitRotatingCircle(
              color: Color.fromARGB(255, 165, 177, 206),
              size: 20.0,
            )
        )
    );
  }
}

