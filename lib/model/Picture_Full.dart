import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:test/model/toast.dart';


//图片全屏浏览模块 （适用于话题帖子浏览）
class Picture_Full extends StatefulWidget {
  var img;
   Picture_Full({Key? key, required this.img}) : super(key: key);

  @override
  _Picture_FullState createState() => _Picture_FullState();
}

class _Picture_FullState extends State<Picture_Full> {

  bool _bigImageVisibility=false;//是否显示预览大图

  //通过双击小图的时候获取当前需要放大预览的图的下标
  void showBigImage(int index){
    setState(() {
      // _bigImageIndex=index;
      _bigImageVisibility=true;
    });
  }
  //通过大图的双击事件 隐藏大图
  void hiddenBigImage(){
    setState(() {
      _bigImageVisibility=false;
    });
  }

  @override
  void initState() {
    super.initState();
    setPermission();
  }

  //展示大图
  Widget? displayBigImage(){
    // if(_imageFileList.length>_bigImageIndex){
      return InkWell(
        child: Container(
          color: Colors.black,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.img,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        //单击返回上一页
        onTap: (){
          Navigator.of(context)..pop();
        },
        //双击弹出菜单
        onLongPress: () async {
          _simpleDialog();
        },
      );
    // }else{
    //   return null;
    // }
  }

//长按图片弹窗
  _simpleDialog() async{
    var result = await showDialog(
        barrierDismissible: true,  // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            // title: Text(" 设置选项:",
            //   style: TextStyle(
            //       fontSize: 18
            //   ),
            // ),
            children: <Widget>[
              Center(
                child: SimpleDialogOption(
                  child: Text("保存"),
                  onPressed: () {
                    _save(widget.img);
                    Navigator.of(context)..pop();
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text("分享"),
                  onPressed: () {
                    SQToast.show('这个还没做。。。');
                  },
                ),
              ),
              // Divider(),
              // Center(
              //   child: SimpleDialogOption(
              //     child: Text("全部设置"),
              //     onPressed: () {
              //       print("Option C");
              //       // boths();
              //       Navigator.pop(context,"C");
              //     },
              //   ),
              // )
            ],
          );
        }
    );
    print(result);
  }

  //获取储存权限
  setPermission() async {
    if (await Permission.storage.request().isGranted) {   //判断是否授权,没有授权会发起授权
      // print("获得了储存授权");
    }else{
      SQToast.show("保存需要储存授权");
    }
  }

  //保存图片在图库
  Future<void> _save(url) async {


      //开始保存图片
      var response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        // name: "hello"
      );
      // print(result);
      SQToast.show('已保存至相册');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: displayBigImage(),
      )
    );
  }
}
