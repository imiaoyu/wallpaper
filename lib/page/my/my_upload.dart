import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/http/http_url.dart';
import 'package:test/http/images_upload.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';



//我的上传中心
class My_upload extends StatefulWidget {
  var title;
   My_upload({Key? key,required this.title}) : super(key: key);

  @override
  _My_uploadState createState() => _My_uploadState();
}

class _My_uploadState extends State<My_upload> {

  var user_token;
  var user_uid;

  void read() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_token =prefs.getString('user_token');
      user_uid =prefs.getInt('user_uid');
      // user_follow =prefs.getString('user_follow');
      // user_integral =prefs.getString('user_integral');
      // user_thumbs =prefs.getString('user_thumbs');
    });
    // print('$user_uid');
    // return user_token !=null ? getData() : 'null';
    getData();
  }

  // late Map<String,dynamic> parsedJson;
  var item ;
  var itemCount;

  Future getData() async{
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse('$http_url/api/list?uid=$user_uid');
    http.Response response = await http.get(url,headers: {'token':'$user_token'});
    final json = jsonDecode(response.body);
    // final moviesMap = json['res']['vertical'];

    // print(json);
    Images_upload images_upload = Images_upload.fromJson(json);
    setState(() {
      itemCount = images_upload.data.results.length;
      item = images_upload.data.results;
      // item = entity.res.vertical;
    });
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title.toString()),
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
          new StaggeredTile.count(2, index.isInfinite ? 3 : 3),    //
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }


  Widget  itemWidget(int index){
    String imgPath = item[index].img;
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
              // var jsonTxt2 = '["小明","韩梅梅","李华"]';
              List nameList =jsonDecode(imgPaths.tag);
              print(nameList);
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
