import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:test/http/http_url.dart';
import 'package:test/page/my/login.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:test/model/toast.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  void register(String username,password,phone) async{
    var bytes = utf8.encode(password);
    var password_md5 = md5.convert(bytes);

    // print("Digest as hex string: $password_md5");

    try{
      var url = Uri.parse('$http_url/user/add');
      http.Response response = await http.post(url,body: {'username': username,'phone': phone,'password':password_md5.toString()});
      final json = jsonDecode(response.body);
      // final moviesMap = json['data'];
      // print(moviesMap);

      if(json['code'] != 200){
        print('账号或密码错误');
        SQToast.show('注册异常 请稍后重试');
        return;
      }
      SQToast.show('注册成功');
      // 注册成功返回登录
      Navigator.of(context)..pop();

    }catch(err){
      SQToast.show('抱歉 土豆服务器故障了');
    }

  }


  final _formKey = new GlobalKey<FormState>();

  late String _userPhone;
  late String _userName;
  late String _password;
  bool _isChecked = true;
  late bool _isLoading;
  IconData _checkIcon = Icons.check_box;

  void _changeFormToLogin() {
    _formKey.currentState!.reset();
  }

  void _onLogin() {
    final form = _formKey.currentState;
    form!.save();

    if (_userPhone == '') {
      _showMessageDialog('手机号不可为空');
      return;
    }
    if (_userName == '') {
      _showMessageDialog('昵称不可为空');
      return;
    }
    if (_password == '') {
      _showMessageDialog('密码不可为空');
      return;
    }
    // print('账号：'+_userID+'昵称：'+_userName+'密码：'+_password);

    register(_userName,_password,_userPhone);
  }

  void _showMessageDialog(String message) {
    SQToast.show(message);
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     // return object of type Dialog
    //     return AlertDialog(
    //       title: new Text('提示'),
    //       content: new Text(message),
    //       actions: <Widget>[
    //         new FlatButton(
    //           child: new Text("ok"),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入手机号',
            icon: new Icon(
              LineAwesomeIcons.mobile_phone,
              color: Colors.grey,
            )),
        onSaved: (value) => _userPhone = value!.trim(),
      ),
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入昵称',
            icon: new Icon(
              LineAwesomeIcons.user_plus,
              color: Colors.grey,
            )),
        onSaved: (value) => _userName = value!.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              LineAwesomeIcons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.angle_left,size: 20,),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          middle: const Text('注册'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              padding: const EdgeInsets.only(top: 20),
              height: 250,
              child: Image.asset(
                  'images/login.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 190,
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        _showEmailInput(),
                        Divider(
                          height: 0.5,
                          indent: 16.0,
                          color: Colors.grey[300],
                        ),
                        _showNameInput(),
                        Divider(
                          height: 0.5,
                          indent: 16.0,
                          color: Colors.grey[300],
                        ),
                        _showPasswordInput(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: OutlineButton(
                child: Text('注册'),
                textColor: Color.fromARGB(255, 165, 177, 206),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Color.fromARGB(255, 165, 177, 206), width: 1),
                onPressed: () {
                  _onLogin();
                },
              ),
            ),
            Center(
              child: InkWell(
                child: Text('快去登录',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) {
                        return new Login();
                      },
                    ),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(40, 10, 50, 0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: <Widget>[
            //       IconButton(
            //           icon: Icon(_checkIcon),
            //           color: Color.fromARGB(255, 165, 177, 206),
            //           onPressed: () {
            //             setState(() {
            //               _isChecked = !_isChecked;
            //               if (_isChecked) {
            //                 _checkIcon = LineAwesomeIcons.check_square;
            //               } else {
            //                 _checkIcon = LineAwesomeIcons.stop;
            //               }
            //             });
            //           }),
            //       Expanded(
            //         child: RichText(
            //             text: TextSpan(text: '我已经详细阅读并同意', style: TextStyle(color: Colors.black, fontSize: 13), children: <TextSpan>[
            //               TextSpan(text: '《隐私政策》', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
            //               TextSpan(text: '和'),
            //               TextSpan(text: '《用户协议》', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline))
            //             ])),
            //       )
            //     ],
            //   ),
            // )
          ],
        ));
  }
}
