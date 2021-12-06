import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:test/http/http_url.dart';
import 'package:test/model/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/my/login.dart';
import 'package:flustars/flustars.dart';

//上传图片
class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  //点击空白处输入法关闭焦点
  FocusNode _focusNode = FocusNode();
  //输入法内容监控
  TextEditingController tagController = TextEditingController();

  final List<String> _list = [];

  //所选择的图片流
  var images=null;
  //图片名称
  var key;
  //图片大小
  var size;
  //图片分辨率
  var resolution;
  //图片链接
  var urls;
  //判断是否重复上传
  var flag;
  late File _userImage;
  var user_token;
  var user_uid;
  var qiniu_token=null;

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
  void up_image() async{

    var tag = jsonEncode('$_list');
    // print(jsonEncode('$_list'));

    var url = Uri.parse('$http_url/api/newarticle');
    http.Response response = await http.post(url,body: {'file_name':'$key','size':'$size','uid':'$user_uid','resolution':'$resolution','img':'$urls?imageView2/0/q/60','preview':'$urls','tag':'$_list'},headers: {'token':'$user_token'});
    final json = jsonDecode(response.body);
    var code = json['code'].toString();
    if(code != '200'){
      print('上传失败');
      SQToast.show('上传异常 稍后重试');
      return;
    }else{
      SQToast.show('上传成功');
      flag = key;
      return;
    }
  }


  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print('失去焦点');
      } else {
        print('得到焦点');
      }
    });

    read();
  }
  @override
  void dispose() {
    super.dispose();
    _focusNode.unfocus();
  }





  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("上传中心",
          style: TextStyle(
              fontSize: 18,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 207, 211, 217),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: <Widget>[
              Container(
                // color: Colors.red,
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(top: height/15),
                      child: Center(
                          child: Up()
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  /*判断*/
  Widget Up() {
    if (qiniu_token == null) {
      return Load();
    } else {
      return Upload();
    }
  }

//  上传
  Widget Upload(){
    final sizes = MediaQuery.of(context).size;
    final width = sizes.width;
    final height = sizes.height;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 500,
                  width: width/1.1,
                  margin: EdgeInsets.only(bottom: 20),
                  // color: Colors.red,
                  child: images != null ? Image_File() : Container(
                    child: Center(
                      child: Text('请先选择图片',
                        style : TextStyle(
                        fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              // // 选择图片路径
              final ImagePicker _picker = ImagePicker();
              // // Pick an image
              final  image = await _picker.pickImage(source: ImageSource.gallery);
              _userImage = File(image!.path);
              // print(_userImage);
              setState(() {
                images = _userImage;
              });

              // SQToast.show('初始化');

              //图片文件大小
              var bytes = new File(image.path);
              var enc = await bytes.readAsBytes();
              var a = enc.length/1000;
              var b;
              if(a>1000){
                b = a/1000;
                size = b.toStringAsFixed(2);
                print(size);
              }else{
                size = a.ceil();
                print(size);
              }


              // md5生成
              var bytess = utf8.encode(_userImage.toString()); // data being hashed
              var digest = md5.convert(bytess);
              key = digest.toString();

              // 获取图片分辨率
              Image imageFile = new Image.file(_userImage);
              Rect rect1 = await WidgetUtil.getImageWH(image: imageFile);
              var width = rect1.width.ceil();
              var height  = rect1.height.ceil();
              resolution = '$height'+'×'+'$width';
              print(size);
            },
            child: Container(
              color: Color.fromARGB(255, 165, 177, 206),
              height: 40,
              width: 100,
              child: Center(
                child: Text( images != null ? '更换图片' : '选择图片',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        // fontWeight: FontWeight.bold
                    )
                ),
              ),
            ),
          ),

          Container(
            height: 20,
          ),

          Container(
            child: Wrap(
              spacing: 5.0,
              //主轴间距
              runSpacing: 8.0,
              //副轴间距
              alignment: WrapAlignment.end,
              //主轴上的对齐方式
              crossAxisAlignment: WrapCrossAlignment.center,
              //副轴上的对齐方式
              children: List<Widget>.generate(
                _list.length,
                    (int index) {
                  return _buildItem(index);
                },
              ).toList(),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            child: TextField(
              keyboardType: TextInputType.name,
              controller:tagController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                icon: Icon(Icons.label),
                labelText: '请输入标签',
                helperText: '最多添加四个 比如：动物、宠物、猫、喵',
              ),
              onSubmitted: (String str){
                print(str);
                if(_list.length == 4){
                  SQToast.show('最多添加四个标签');
                }else{
                  print(_list);
                  setState(() {
                    _list.add(tagController.text);
                    tagController.clear();
                  });
                }
              },
              autofocus: false,
            ),

          ),

          Container(
            padding: EdgeInsets.only(right: 15,top: 20,bottom: 20),
            child: Divider(
              height: 0.5,
              indent: 16.0,
              color: Color.fromARGB(255, 207, 211, 217),
            ),
          ),

          InkWell(
            onTap: () {
              //判断是否重复上传
              if(flag == key){

                SQToast.show('禁止重复上传');

              }else{

                // up_image();
                //判断标签是否为空
                if(_list.length == 0 || images == null){
                  SQToast.show('至少有一项未完成');
                }else{

                  // 上传至七牛云
                  // var key= 'gyguyg';
                  // 创建 storage 对象
                  var storage = Storage();
                  // 使用 storage 的 putFile 对象进行文件上传
                  storage.putFile(_userImage, '$qiniu_token',
                      options: PutOptions(key: key))
                    ..then((storage){
                      print('ok');
                      // SQToast.show('初始化');
                      urls = 'http://pan-qiniu.imiaoyu.top/$key';
                      up_image();
                    })
                    ..catchError((err){
                      // print('no');
                      SQToast.show('初始化失败 稍后重试');
                    });

                }

              }
            },
            child: Container(
              // margin: EdgeInsets.only(top: 50),
              color: Color.fromARGB(255, 165, 177, 206),
              height: 50,
              width: 200,
              child: Center(
                child: Text('上传',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25,bottom: 20),
            child: Text(
              '提示：上传后的图片将会获得推荐和积分',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Image_File (){
    return Container(
      child: Image.file(
        images != null ? images : Icon(Icons.south),
        fit: BoxFit.cover,
      ),
    );
  }


//  登录
  Widget Load(){
    // 获取屏幕宽度
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Column(
      children: <Widget>[
        Center(
            child:
            // _ImageView(images),
            Container(
              // color: Color.fromARGB(255, 165, 177, 206),
              // color: Colors.red,
              height: 300,
              // width: 200,
              child: Center(
                  child: Image.asset(
                    'images/upload_image.png',
                    fit: BoxFit.cover,
                  )
              ),
            )
        ),


        InkWell(
          onTap: () {
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
            margin: EdgeInsets.only(top: height/6),
            // color: Color.fromARGB(255, 165, 177, 206),
            color: Color.fromARGB(255, 165, 177, 206),
            height: 50,
            width: 200,
            child: Center(
              child: Text('登录',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
          ),
        )

      ],
    );
  }



  //标签
  List<String> _filters = <String>[];

  Widget _buildItem(int index) {
    String content = _list[index];
    return InputChip(
      // avatar: CircleAvatar(
      //   backgroundImage: NetworkImage('https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
      //   radius: 12.0,
      // ),
      label: Text(
        content,
        style: TextStyle(fontSize: 12.0),
      ),
      shadowColor: Colors.grey,
      deleteIcon: Icon(
        Icons.close,
        color: Colors.black54,
        size: 14.0,
      ),
      onDeleted: () {
        setState(() {
          _list.removeAt(index);
        });
      },
      //选中后的效果事件
      // onSelected: (bool selected) {
      //   setState(() {
      //     if (selected) {
      //       _filters.add(_list[index]);
      //       print(_filters.contains(_list[index]));
      //     } else {
      //       _filters.removeWhere((String name) {
      //         return name == _list[index];
      //       });
      //     }
      //   });
      // },
      selectedColor: Colors.orange,
      disabledColor: Colors.grey,
      selected: _filters.contains(_list[index]),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(color: Colors.black54),
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