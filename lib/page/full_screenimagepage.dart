import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:test/model/crop.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:test/model/toast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/page/my/update_images.dart';

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

    bool offstage = true;

  //获取储存权限
  setPermission() async {
    if (await Permission.storage.request().isGranted) {   //判断是否授权,没有授权会发起授权
      print("获得了储存授权");
    }else{
      // print("没有获得储存授权");
      SQToast.show("保存需要储存授权");
    }
  }

  Future requstPermission() async {       //授权多个权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }


   late List  colors;

   //提取图片颜色
  _updatePalettes() async {
    print(widget.imageurl.img);
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.imageurl.img),
      size: Size(200, 100)
    );
    setState(() {
      colors.add(generator.lightMutedColor != null ? generator.lightMutedColor : PaletteColor(Colors.white54,1));
      // colors.add(PaletteColor(Color.fromARGB(255, 165, 177, 206),3));
    });
  }

  //保存图片在图库
   Future<void> _save(url) async {
     var response = await Dio().get(
         url,
         options: Options(responseType: ResponseType.bytes));
     final result = await ImageGallerySaver.saveImage(
         Uint8List.fromList(response.data),
         quality: 100,
         // name: "hello"
     );
     print(result);

     // try {
     //   // Saved with this method.
     //   var imageId = await ImageDownloader.downloadImage(url);
     //   if (imageId == null) {
     //     return;
     //   }
     //
     //   // Below is a method of obtaining saved image information.
     //   var fileName = await ImageDownloader.findName(imageId);
     //   var path = await ImageDownloader.findPath(imageId);
     //   var size = await ImageDownloader.findByteSize(imageId);
     //   var mimeType = await ImageDownloader.findMimeType(imageId);
     // } on PlatformException catch (error) {
     //   print(error);
     // }
   }


  @override
  void initState() {
    // print(widget.imageurl.preview);
    colors = [];
    // colors.add(PaletteColor(Colors.redAccent,3));
    super.initState();
    setPermission();
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
    bool _isDisable = true;


    Future<void> dowloadImage(BuildContext context) async {
      progressString = Wallpaper.imageDownloadProgress(
          images[0]

      );
      progressString.listen((data) {
        setState(() {
          res = data;
          downloading = true;
        });
        // print("DataReceived: " + data);
      }, onDone: () async {
        setState(() {
          downloading = false;
          _isDisable = false;
        });
        // SQToast.show('初始化成功');
      }, onError: (error) {
        setState(() {
          downloading = false;
          _isDisable = true;
        });
        // SQToast.show('初始化失败');
      });
    }

    void dowload() async {
      return await dowloadImage(context);
    }



    void homes ()async {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      home = await Wallpaper.homeScreen(
          options: RequestSizeOptions.RESIZE_FIT,
          width: width,
          height: height
      );
      setState(() {
        downloading = false;
        home = home;
      });
      SQToast.show('设置成功');
    }

    void locks ()async {
      lock = await Wallpaper.lockScreen();
      setState(() {
        downloading = false;
        lock = lock;
      });
      SQToast.show('设置成功');
    }

    void boths ()async {
      both = await Wallpaper.bothScreen();
      setState(() {
        downloading = false;
        both = both;
      });
      SQToast.show('设置成功');
    }


    _simpleDialog() async{
      var result = await showDialog(
          barrierDismissible: true,  // 表示点击灰色背景的时候是否消失弹出框
          context: context,
          builder: (context) {
            return SimpleDialog(
              // title: Text(" 设置选项:",
              // style: TextStyle(
              //     fontSize: 18
              // ),
              // ),
              // titlePadding:EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              children: <Widget>[
                Center(
                  child: SimpleDialogOption(
                    child: Text("桌面"),
                    onPressed:  () async  {
                      homes();
                      // Navigator.pop(context,"A");
                    },
                  ),
                ),
                // Divider(height: 1.0,indent: 10.0,endIndent: 10,color: Colors.black26,),
                Center(
                  child: SimpleDialogOption(
                    child: Text("锁屏"),
                    onPressed: () async {
                      locks();
                      // Navigator.pop(context,"B");
                    },
                  ),
                ),
                // Divider(height: 1.0,indent: 10.0,endIndent: 10,color: Colors.black26,),
                Center(
                  child: SimpleDialogOption(
                    child: Text("全部"),
                    onPressed: () async {
                      boths();
                      // Navigator.pop(context,"C");
                    },
                  ),
                )
              ],
            );
          }
      );
      print(result);
    }


    /*替换颜色api*/
    var color = '255,47, 23, 17';
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(LineAwesomeIcons.angle_left),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   title: Text("详情",
      //   style: TextStyle(
      //     fontSize: 18
      //   ),
      //   ),
      //   // backgroundColor: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
      //   backgroundColor: Color.fromARGB(255, 165, 177, 206),
      //   centerTitle: true,
      // ),
      body:Column(
        // margin: EdgeInsets.all(20.0),
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children:  <Widget>[
          Expanded(
            child:InkWell(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
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
                    ),
                    Positioned(
                      top: 70,
                      right: 30,
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.black54,
                          child: Offstage(
                            offstage: false,
                            child: Container(
                                child: Icon(
                                  Icons.close_sharp,
                                  size: 20,
                                  color: Colors.white,
                                )),

                          ),
                        ),
                        onTap: (){
                          //返回上一个页面
                          Navigator.of(context)..pop();
                        },
                      )
                    ),
                    Offstage(
                      offstage: offstage,
                      child: Stack(
                        // alignment: const FractionalOffset(0.5, 0.9),
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  // flex: 1,
                                  // color: Color.fromRGBO(255, 255, 255, .7),
                                  color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.fromLTRB(20,5,20,5),
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
                                                LineAwesomeIcons.star_1,
                                                color:Color.fromARGB(255, 165, 177, 206),
                                                size: 20,
                                                // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                '${widget.imageurl.favs}收藏',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
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
                                                LineAwesomeIcons.heart_1,
                                                color:Color.fromARGB(255, 165, 177, 206),
                                                size: 20,
                                                // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                '${widget.imageurl.rank}点赞',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        // color: Colors.pink,
                                        child: InkWell(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    LineAwesomeIcons.alternate_cloud_download,
                                                    color:Color.fromARGB(255, 165, 177, 206),
                                                    size: 20,
                                                    // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    '下载',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap:(){
                                              // SQToast.show('正在保存至相册...');
                                              _save(widget.imageurl.preview);
                                              SQToast.show('已保存至相册');
                                              // vibrate();
                                            }
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                          height: 50,
                                          // color: Colors.pink,
                                          child: InkWell(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Container(
                                                      child: Icon(
                                                        LineAwesomeIcons.mobile_phone,
                                                        color:Color.fromARGB(255, 165, 177, 206),
                                                        size: 20,
                                                        // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
                                                      )
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '壁纸',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap:() async{
                                                dowload();
                                                _simpleDialog();}
                                          )
                                      ),
                                    ],
                                    // child: Text('data',
                                    // style: TextStyle(fontSize: 20),//字体样式
                                    // ),
                                  ),
                                ),
                              ],
                            )
                          ]
                      )
                    ),




                  ],
                ),
                onLongPress:(){
                  print('111');
                },
                onTap:(){
                  setState(() {
                      offstage = !offstage;
                  });
                }
            )
          ),
          // Expanded 好像可以自适应高度
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Container(
          //       // flex: 1,
          //       margin: EdgeInsets.fromLTRB(20,5,20,5),
          //       child: new Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           // Text('data'),Text('data'),
          //           Container(
          //             // width: 95,
          //             height: 50,
          //             // color: Colors.pink,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: <Widget>[
          //                 Container(
          //                   child: Icon(
          //                     LineAwesomeIcons.star_1,
          //                     color:Color.fromARGB(255, 165, 177, 206),
          //                     size: 20,
          //                     // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          //                   ),
          //                 ),
          //                 Container(
          //                   child: Text(
          //                       '${widget.imageurl.favs}收藏',
          //                     style: TextStyle(
          //                       fontSize: 12,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           Container(
          //             // width: 100,
          //             height: 50,
          //             // color: Colors.pink,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: <Widget>[
          //                 Container(
          //                   child: Icon(
          //                     LineAwesomeIcons.heart_1,
          //                     color:Color.fromARGB(255, 165, 177, 206),
          //                     size: 20,
          //                     // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          //                   ),
          //                 ),
          //                 Container(
          //                   child: Text(
          //                       '${widget.imageurl.rank}点赞',
          //                     style: TextStyle(
          //                       fontSize: 12,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           Container(
          //             // width: 100,
          //             height: 50,
          //             // color: Colors.pink,
          //             child: InkWell(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: <Widget>[
          //                   Container(
          //                         child: Icon(
          //                           LineAwesomeIcons.alternate_cloud_download,
          //                           color:Color.fromARGB(255, 165, 177, 206),
          //                           size: 20,
          //                           // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          //                         ),
          //                   ),
          //                   Container(
          //                     child: Text(
          //                       '下载',
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //                 onTap:(){
          //                   // SQToast.show('正在保存至相册...');
          //                   _save(widget.imageurl.preview);
          //                   SQToast.show('已保存至相册');
          //                   // vibrate();
          //                 }
          //             ),
          //           ),
          //           Container(
          //             // width: 100,
          //             height: 50,
          //             // color: Colors.pink,
          //             child: InkWell(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: <Widget>[
          //                   Container(
          //                         child: Icon(
          //                           LineAwesomeIcons.mobile_phone,
          //                           color:Color.fromARGB(255, 165, 177, 206),
          //                           size: 20,
          //                           // color: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          //                         )
          //                   ),
          //                   Container(
          //                     child: Text(
          //                       '壁纸',
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //                 onTap:() async{
          //                   _simpleDialog();}
          //             )
          //           ),
          //         ],
          //         // child: Text('data',
          //         // style: TextStyle(fontSize: 20),//字体样式
          //         // ),
          //       ),
          //     ),
          //   ],
          // )
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
