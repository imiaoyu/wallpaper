import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:test/model/toast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

/**
 *
 * 创建人：xuqing
 * 创建时间:2020年6月26日03:03:05
 * 类说明：图片详情页面
 *
 *
 *
 */


class FullScreenImagePage extends StatefulWidget {
  var  imageurl;
  FullScreenImagePage({Key? key,required this.imageurl}) : super(key: key);
  @override
  _FullScreenImagePageState createState() {
    return _FullScreenImagePageState();
  }
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {

   late List  colors;

   //提取图片颜色
  _updatePalettes() async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.imageurl.thumb),
      size: Size(200, 100)
    );
    setState(() {
      colors.add(generator.lightMutedColor != null ? generator.lightMutedColor : PaletteColor(Colors.redAccent,3));
    });
  }

  //保存图片在图库
   Future<void> _save(url) async {
     try {
       // Saved with this method.
       var imageId = await ImageDownloader.downloadImage(url);
       if (imageId == null) {
         return;
       }

       // Below is a method of obtaining saved image information.
       var fileName = await ImageDownloader.findName(imageId);
       var path = await ImageDownloader.findPath(imageId);
       var size = await ImageDownloader.findByteSize(imageId);
       var mimeType = await ImageDownloader.findMimeType(imageId);
     } on PlatformException catch (error) {
       print(error);
     }
   }


  @override
  void initState() {
    // print(widget.imageurl.preview);
    colors = [];
    // colors.add(PaletteColor(Colors.redAccent,3));
    super.initState();
    _updatePalettes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> vibrate() async {

      bool canVibrate = await Vibrate.canVibrate;
      Vibrate.vibrate();

    }


    /*设置壁纸api*/
    String home = "Home Screen",
        lock = "Lock Screen",
        both = "Both Screen",
        system="System";

    late Stream<String> progressString;
    late String res;
    bool downloading = false;
    List<String> images = [
      "${widget.imageurl.preview}",
      "${widget.imageurl.preview}",
      "${widget.imageurl.preview}",
      "${widget.imageurl.preview}"
    ];
    var result = "Waiting to set wallpaper";

    /*替换颜色api*/
    var color = '255,47, 23, 17';
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("详情",
        style: TextStyle(
          fontSize: 18
        ),
        ),
        backgroundColor: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body:ListView(
        // margin: EdgeInsets.all(20.0),
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children:  <Widget>[
          Container(
            child:InkWell(
                child: CachedNetworkImage(
                  imageUrl: widget.imageurl.img,
                  fit: BoxFit.cover,
                    //有网情况:网络下载图片缓存到本地,当第二次打开时,不下载网络图片,使用缓存到本地的图片,若没有网,没有缓存到本地图片,则使用默认图片.
                    //CachedNetworkImage
                    placeholder: (context,url){
                      return  SpinKitRotatingCircle(
                        color: Colors.black12,
                        size: 20.0,
                      );
                    },
                    errorWidget: (context, url, android) {
                      print('CachedNetworkImage${widget.imageurl.preview}');
                      return Icon(Icons.refresh);
                    }
                ),
                onLongPress:(){
                  // print('111');
                }
            )
          ),
          // Expanded 好像可以自适应高度
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                // flex: 1,
                margin: EdgeInsets.fromLTRB(20,20,20,20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text('data'),Text('data'),
                    Container(
                      // width: 95,
                      height: 50,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.grade,
                              color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Container(
                            child: Text(
                                '${widget.imageurl.favs}收藏'
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      // width: 100,
                      height: 50,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.favorite,
                              color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Container(
                            child: Text(
                                '${widget.imageurl.rank}点赞'
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      // width: 100,
                      height: 50,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child:InkWell(
                                child: Icon(
                                  Icons.downloading,
                                  color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                ),
                                onTap:(){
                                  SQToast.show('正在保存至相册...');
                                  _save(images[0]);
                                  SQToast.show('保存成功');
                                  // vibrate();
                                }
                            ),
                          ),
                          Container(
                            child: Text(
                                '下载'
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      // width: 100,
                      height: 50,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap:() async{
                              //调用toast提示
                              SQToast.show('正在设置...');
                              progressString =
                                  Wallpaper.ImageDownloadProgress(images[0]);
                              progressString.listen((data) {
                                setState(() {
                                  res = data;
                                  downloading = true;
                                });
                                print("DataReceived: " + data);
                              }, onDone: () async {
                                var width=  MediaQuery
                                    .of(context)
                                    .size
                                    .width;
                                var height =  MediaQuery
                                    .of(context)
                                    .size
                                    .height;
                                home = await Wallpaper.homeScreen();
                                setState(() {
                                  downloading = false;
                                  home = home;
                                });
                                print("Task Done");
                                SQToast.show('设置成功啦');
                                // vibrate();
                              }, onError: (error) {
                                setState(() {
                                  downloading = false;
                                });
                                print("Some Error");
                                SQToast.show('二次元崩溃了 设置失败了');
                              });
                            },
                            child:InkWell(
                                child: Icon(
                                  Icons.wallpaper,
                                  color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                )
                            ),
                          ),
                          Container(
                            child: Text(
                                '壁纸'
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  // child: Text('data',
                  // style: TextStyle(fontSize: 20),//字体样式
                  // ),
                ),
              ),
            ],
          )
          // Row(
          //   // padding:EdgeInsets.symmetric(vertical: 60),
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[Text('data'),Text('data')],
          // ),
        ],
      )
    );
  }
}
