import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test/http/entity.dart';
import 'dart:io';



class Http {
  //  请求图片资源
  static imageslist(String urls) async {
    var item;
    var itemCount;
      // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
      // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
      var url = Uri.parse(urls);
      http.Response response = await http.get(url);
      final json = jsonDecode(response.body);
      final moviesMap = json['res']['vertical'];
      Entity entity = Entity.fromJson(json);

      return entity;
      // setState(() {
      //   itemCount = entity.res.vertical.length;
      //   item = entity.res.vertical;
      //   // item = entity.res.vertical;
      // });

  }

  //  请求日签数据
  static Daily_signature(String urls) async {
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse(urls);
    http.Response response = await http.get(url);
     final json = jsonDecode(response.body);
     final data = json['images'];
     return data;
  }
}