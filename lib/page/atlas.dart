import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/http/entity.dart';
import 'package:test/model/toast.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  String theImage = "https://images.unsplash.com/photo-1571260118569-c77a06a97a8c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80";

  var item ;
  var itemCount;
  Future getData() async{
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse('http://service.picasso.adesk.com/v1/vertical/vertical?limit=30&skip=180&adult=false&first=0&order=hot');
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final moviesMap = json['res']['vertical'];
    Entity entity = Entity.fromJson(json);
    setState(() {
      itemCount = entity.res.vertical.length;
      item = entity.res.vertical;
      // item = entity.res.vertical;
    });
  }

  @override
  void initState() {
    super.initState();
    // item != null && itemCount != null ? getData() : SQToast.show('.....');
    getData();
  }

  // @override
  // void didChangeDependencies() {
  //   precacheImage(NetworkImage(theImage), context);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7, //宽高比例  1.0 为相等
            crossAxisSpacing: 3,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context,index) {
            return Container(
              alignment: Alignment.center,
              // color: Colors.orange,
              // child: Text("$index"),
              child: CachedNetworkImage(
                imageUrl: item[index].thumb,
              )
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}