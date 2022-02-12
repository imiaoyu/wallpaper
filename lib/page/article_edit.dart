import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/http/a.dart';
import 'package:test/http/conversation.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/dropdownbutton.dart';
import 'package:test/model/http.dart';
import 'package:test/model/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:http/http.dart' as http;


//话题文章上传页面
class Article_edit extends StatefulWidget {


  @override
  _Article_editState createState() => _Article_editState();
}

class _Article_editState extends State<Article_edit> {


  // List status = [{'id': 1, 'name': '全部',},{'id': 2, 'name': '已发货',}, {'id': 3, 'name': '未发货'}];

  var conversation_value; //已选话题
  var title_value; //标题
  var content_value; //内容
  List<String> img_value = []; //已选图片


  var qiniu_token=null; //七牛koken
  var val=null; //上传时进度条数据

  // //获取话题
  var conversation_items;
  // void conversation() async {
  //   var url = Uri.parse('$http_url/api/conversation');
  //   http.Response response = await http.get(url);
  //   final json = jsonDecode(response.body);
  //   final jsons = json['data'];
  //   // print(jsons[0]['title']);
  //   setState(() {
  //     // conversation_itemCount = conversation.data.length;
  //     conversation_item = jsons;
  //   });
  //   // print(conversation_item);
  // }

  //图片上传相关
  String  _title="图片上传";
  List<XFile> _imageFileList=List.empty(growable: true);//存放选择的图片
  final ImagePicker _picker = ImagePicker();
  int maxFileCount=9;//最大选择图片数量
  dynamic _pickImageError;
  int _bigImageIndex=0;//选中的需要放大的图片的下标
  bool _bigImageVisibility=false;//是否显示预览大图


  //获取当前展示的图的数量
  int getImageCount() {
    if(_imageFileList.length<maxFileCount){
      return _imageFileList.length+1;
    }else{
      return _imageFileList.length;
    }
  }


  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = new FocusNode();
  FocusNode focusNodes = new FocusNode();
  ///文本输入框是否可编辑
  bool isEnable = true;

  //点击空白处输入法关闭焦点
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    conversation_items = conversation_item;

    token();
    read();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print('失去焦点');
      } else {
        print('得到焦点');
      }
    });

    ///添加获取焦点与失去焦点的兼听
    // focusNode.addListener((){
    //   ///当前兼听的 TextFeild 是否获取了输入焦点
    //   bool hasFocus = focusNode.hasFocus;
    //   ///当前 focusNode 是否添加了兼听
    //   bool hasListeners = focusNode.hasListeners;
    //
    //   print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    // });

    focusNodes.addListener((){
      ///当前兼听的 TextFeild 是否获取了输入焦点
      bool hasFocus = focusNode.hasFocus;
      ///当前 focusNode 是否添加了兼听
      bool hasListeners = focusNode.hasListeners;

      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });

    /// WidgetsBinding 它能监听到第一帧绘制完成，第一帧绘制完成标志着已经Build完成
    /// 页面加载焦点初始化
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   ///获取输入框焦点
    //   FocusScope.of(context).requestFocus(focusNode);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.unfocus();
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext? context,double? maxHeight,double? maxWidth,int? imageQuality}) async {
    try {
      final pickedFileList = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      setState(() {
        //pickedFileList.e
        if(_imageFileList.length<maxFileCount){//小于最大数量
          if((_imageFileList.length+(pickedFileList?.length??0))<=maxFileCount){//加上新选中的不超过最大数量
            pickedFileList!.forEach((element) {
              _imageFileList.add(element);
            });
          }else {//否则报错
            SQToast.show("超过可选最大数量!自动移除多余的图片");
            int avaliableCount=maxFileCount-_imageFileList.length;
            for(int i=0;i<avaliableCount;i++){
              _imageFileList.add(pickedFileList![i]);
            }

          }
        }

      });
    } catch (e) {
      setState(() {
        SQToast.show("$_pickImageError");//出现错误的话报错
        _pickImageError = e;
      });
    }

  }

  //移除图片
  void _removeImage(int index){

    setState(() {
      _imageFileList.removeAt(index);
    });
  }

  //通过双击小图的时候获取当前需要放大预览的图的下标
  void showBigImage(int index){
    setState(() {
      _bigImageIndex=index;
      _bigImageVisibility=true;
    });
  }
  //通过大图的双击事件 隐藏大图
  void hiddenBigImage(){
    setState(() {
      _bigImageVisibility=false;
    });
  }

  //展示大图
  Widget? displayBigImage(){
    if(_imageFileList.length>_bigImageIndex){
      return Image.file(File(_imageFileList[_bigImageIndex].path),fit:BoxFit.cover);
    }else{
      return null;
    }
  }



  //图片上传
  _upLoadImage()  {
    // List<dynamic> _imgListUpload  = [];

    // 判断文件大小

    SQToast.show('上传中 请勿操作');
    _imageFileList.forEach((element) async {//遍历图片 加入到dio的批量文件里面
      // _imgListUpload.add( MultipartFile.fromFileSync(element.path, filename: element.name));
      // print(_imageFileList.length);

      var bytes = new File(element.path);
      var enc = await bytes.readAsBytes();
      var  size = enc.length/1024;
      // print(size);



      //上传七牛云
      File img_path = File(element.path);
      String img_name = element.name;
      var storage = Storage();

      // var qiniu_token = 'yVMbT3GZy653wFpbsRjzq3IF6zQIMS_b7kI9ZoQA:cVGKiQHu0_xP-VjVI-xNYcELDmM=:eyJzY29wZSI6InBhbi1pbWlhb3l1IiwiZGVhZGxpbmUiOjE2MzcyMzM1NDl9';
      // 使用 storage 的 putFile 对象进行文件上传
      storage.putFile(img_path, '$qiniu_token',
          options: PutOptions(key: element.name))
        ..then((storage){
          // SQToast.show('初始化');
          var urls = 'http://pan-qiniu.imiaoyu.top/$img_name';
          setState(() {
            img_value.add(urls);
            // val = 0.5; //进度条数据
          });
          // print(img_value);
        })
        ..catchError((err){
          // print('no');
          SQToast.show('初始化失败 稍后重试');
        });

    });


    // 上传服务
    // if(size >=10000.000){
    //   Timer(Duration(seconds: 16), () {
    //     // print("3秒后执行");
    //     // print(img_value);
    //     up_article();
    //   });
    // }else if(size <10000.000 && size >4000.000){
    //   Timer(Duration(seconds: 12), () {
    //     // print("3秒后执行");
    //     // print(img_value);
    //     up_article();
    //   });
    // }else{
    //   Timer(Duration(seconds: 6), () {
    //     // print("3秒后执行");
    //     // print(img_value);
    //     up_article();
    //   });
    // }

    Timer(Duration(seconds: 15), () {
      // print("3秒后执行");
      // print(img_value);
      up_article();
    });

    // var formData= FormData.fromMap({
    //   'files': _imgListUpload,//批量的图片
    //   'WAREHOUSEID':'TEST', //其他的参数
    //   'ORDERNO':'HZ00000000001'
    // });
    try{
      // Dio dio = new Dio();
      // var respone = await dio.post<String>("http://192.168.1.21:8080/FlutterService/UploadImages", data: formData);
      // if (respone.statusCode == 200) {
      //   SQToast.show("上传成功!");
      // }
    }catch (e) {
      SQToast.show("上传失败!");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 165, 177, 206),
        title: Text('编辑文章'),
        centerTitle: true,
        actions: <Widget>[
          // FlatButton(child: Text("获取焦点"),onPressed: (){
          //   FocusScope.of(context).requestFocus(focusNode);
          //   FocusScope.of(context).requestFocus(focusNodes);
          // },),
          // FlatButton(child: Text("失去焦点"),onPressed: (){
          //   focusNode.unfocus();
          //   focusNodes.unfocus();
          // },),
          // FlatButton(child: Text("编辑"),onPressed: (){
          //   setState(() {
          //     isEnable = true;
          //   });
          // },),
          // FlatButton(child: Text("不可编辑"),onPressed: (){
          //   setState(() {
          //     isEnable = false;
          //   });
          // },),
          IconButton(icon: Icon(Icons.send), onPressed: () {
            _upLoadImage();

            //上传进度条
            showDialog<Null>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // height: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Container(
                  // height: 20,
                  margin: EdgeInsets.fromLTRB(20,0,20,0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.yellow),
                    // value: val,
                  ),
                ),
                      Container(
                        margin:EdgeInsets.fromLTRB(0,5, 0, 0),
                        child: Text('上传中 请勿操作',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:16,decoration: TextDecoration.none,),),
                      )
                    ],
                  )
                );
              },
            ).then((val) {
              print(val);
            });


          }),
          // Icon(Icons.send,color: Color.fromARGB(255, 165, 177, 206),),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //选择话题
                  Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10,right: 10,left: 10),
                      // color:Colors.red,
                      child: InkWell(
                        onTap: (){
                          print('ok');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.add_circle,color: Color.fromARGB(255, 165, 177, 206),),
                                Text(' 发布到',style: TextStyle(color: Colors.black87,fontSize: 16),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('选择合适的话题 ',style: TextStyle(color: Colors.black38),),
                                // dropdownButtonItem('装车状态', status, statusItem, statusId, _handleStatusChange),
                                // Icon(Icons.keyboard_arrow_right,color: Colors.black38),
                                new DropdownButton( //下拉列表
                                  items: conversation_item.map<DropdownMenuItem<String>>((item){
                                    return new DropdownMenuItem<String>( //下拉项
                                      value: item['id'].toString(),//下拉项值
                                      child: new Text(item['title']),//下拉项显示内容
                                    );
                                  }).toList(),
                                  hint: Text('请选择:'),
                                  value: conversation_value,
                                  onChanged: (item) {
                                    setState(() {
                                      conversation_value = item;
                                    });
                                    // print(item);
                                  },//on change事件
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  ),


                  //标题输入
                  new  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // 触摸收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      ///SizedBox 用来限制一个固定 width height 的空间
                      child: SizedBox(
                        // width: 400,
                        // height: 130,
                        child: Container(
                          color: Colors.white24,
                          ///距离顶部
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          ///Alignment 用来对齐 Widget
                          alignment: Alignment(0, 0),
                          ///文本输入框
                          child: TextField(
                            ///是否可编辑
                            enabled: isEnable,
                            ///焦点获取
                            focusNode: focusNode,
                            ///单行
                            maxLines: 1,
                            ///用来配置 TextField 的样式风格
                            decoration:InputDecoration(
                              hintText:"标题",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),  // 边框颜色
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3),  // 边框颜色
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                ///设置边框四个角的弧度
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                ///用来配置边框的样式
                                borderSide: BorderSide(
                                  ///设置边框的颜色
                                  //   color: Colors.white.withOpacity(0.3),
                                  color: Color.fromARGB(255, 207, 211, 217),
                                  ///设置边框的粗细
                                  width: 2.0,
                                ),
                              ),
                              ///用来配置输入框获取焦点时的颜色
                              focusedBorder: OutlineInputBorder(
                                ///设置边框四个角的弧度
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                                ///用来配置边框的样式
                                borderSide: BorderSide(
                                  ///设置边框的颜色
                                  color: Colors.white.withOpacity(0.3),  // 边框颜色
                                  // color: Color.fromARGB(255, 207, 211, 217),
                                  ///设置边框的粗细
                                  // width: 2.0,
                                ),
                              ),
                              filled: true,  // 不然 fillColor 等 不生效
                              fillColor: Colors.white.withOpacity(0.6),
                              focusColor: Colors.white.withOpacity(0.5),
                              hoverColor: Colors.white.withOpacity(0.3),
                            ),
                            onChanged:(value){
                              setState(() {
                                this.title_value = value;
                              });
                              print(title_value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),


                  //内容输入
                  new  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // 触摸收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      ///SizedBox 用来限制一个固定 width height 的空间
                      child: SizedBox(
                        // width: 400,
                        // height: 130,
                        child: Container(
                          color: Colors.white24,
                          ///距离顶部
                          // margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          ///Alignment 用来对齐 Widget
                          alignment: Alignment(0, 0),
                          ///文本输入框
                          child: TextField(
                            ///是否可编辑
                            enabled: isEnable,
                            ///焦点获取
                            focusNode: focusNodes,
                            ///多行
                            maxLines: 8,
                            ///用来配置 TextField 的样式风格
                            decoration:InputDecoration(
                              hintText:"内容",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),  // 边框颜色
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3),  // 边框颜色
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                ///设置边框四个角的弧度
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                ///用来配置边框的样式
                                borderSide: BorderSide(
                                  ///设置边框的颜色
                                  // color: Colors.red,
                                  color: Color.fromARGB(255, 207, 211, 217),
                                  ///设置边框的粗细
                                  width: 2.0,
                                ),
                              ),
                              ///用来配置输入框获取焦点时的颜色
                              focusedBorder: OutlineInputBorder(
                                ///设置边框四个角的弧度
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                                ///用来配置边框的样式
                                borderSide: BorderSide(
                                  ///设置边框的颜色
                                  color: Colors.white.withOpacity(0.3),  // 边框颜色
                                  // color: Color.fromARGB(255, 207, 211, 217),
                                  ///设置边框的粗细
                                  // width: 2.0,
                                ),
                              ),
                              filled: true,  // 不然 fillColor 等 不生效
                              fillColor: Colors.white.withOpacity(0.6),
                              focusColor: Colors.white.withOpacity(0.5),
                              hoverColor: Colors.white.withOpacity(0.3),
                            ),
                            onChanged:(value){
                              setState(() {
                                this.content_value = value;
                              });
                              print(content_value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  //图片选择
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SizedBox(
                      height: 400,
                      child: _handlePreview(),
                    ),
                  ),

                ],
              )
            ],
          ),

          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child:Visibility(
                visible: _bigImageVisibility,
                child: GestureDetector(
                  child:displayBigImage(),
                  onTap: hiddenBigImage,
                )

            ),
          ),
        ],
      )

    );
  }

  Widget _handlePreview() {
    return _previewImages();
  }
  Widget _previewImages() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:3,//每行三个
        childAspectRatio: 1.0,//宽高比1：1
      ),
      itemBuilder: (context,index){
        if(_imageFileList.length<maxFileCount){//没选满
          if(index<_imageFileList.length){//需要展示的图片
            return Stack( //层叠布局 图片上面要有一个删除的框
              alignment: Alignment.center,
              children: [
                Positioned(
                    top:0.0 ,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child:GestureDetector(
                      child: Image.file(File(_imageFileList[index].path),fit:BoxFit.cover ),
                      onTap:()=>showBigImage(index) ,
                    )
                ),
                Positioned(
                  top:0.0,
                  right: 5.0,
                  width: 20,
                  height: 20,
                  child:GestureDetector(child: SizedBox(child:  Icon(Icons.close,color: Colors.white60),),
                    onTap:()=>_removeImage(index) ),
                ),

              ],
            );
            //return Image.file(File(_imageFileList[index].path),fit:BoxFit.cover ,) ;
          }else{//显示添加符号
            return GestureDetector( //手势包含添加按钮 实现点击进行选择图片
                child:Container(
                  color: Colors.black12,
                  child: Icon(Icons.add),
                ),
                onTap: ()=>_onImageButtonPressed(//执行打开相册
              ImageSource.gallery,
              context: context,
              // imageQuality: 40,//图片压缩
            ),
            );
          }
        }else {//选满了
          return Stack( //层叠布局 图片上面要有一个删除的框
            alignment: Alignment.center,
            children: [
              Positioned(
                top:0.0 ,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: GestureDetector(
                  child: Image.file(File(_imageFileList[index].path),fit:BoxFit.cover ),
                  onTap:()=>showBigImage(index) ,
                ),
              ),
              Positioned(
                top:0.0,
                right: 5.0,
                width: 20,
                height: 20,
                child:GestureDetector(child: SizedBox(child:  Icon(Icons.close,color: Colors.white60),),
                  onTap:()=>_removeImage(index), ),
              ),

            ],
          ) ;
        }
      },
      itemCount: getImageCount(),);
  }



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
    return user_token !=null ? token() : 'null';
  }

  //获取token
  void token() async{
    var url = Uri.parse('$http_url/api/uploadToken');
    http.Response response = await http.get(url,headers: {'token':'$user_token'});
    final json = jsonDecode(response.body);
    final moviesMap = json['token'];
    qiniu_token = moviesMap;
    print('qiniu_token:'+qiniu_token);
  }

  //上传图片数据
  void up_article() async{

    var img = jsonEncode('$img_value');
    // print(jsonEncode('$_list'));

    var url = Uri.parse('$http_url/article/add');
    http.Response response = await http.post(url,body: {'title':'$title_value','content':'$content_value','uid':'$user_uid','cid':'$conversation_value','img':'$img_value','copyright':'原创'},headers: {'token':'$user_token'});
    final json = jsonDecode(response.body);
    var code = json['code'].toString();
    if(code != '200'){
      print('上传失败');
      SQToast.show('发布异常 稍后重试');
      return;
    }else{
      setState(() {
        val = 0.5;
      });
      Navigator.of(context)..pop()..pop();
      SQToast.show('发布成功');
      // flag = key;
      return;
    }
  }

}
