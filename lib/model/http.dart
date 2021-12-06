import 'package:http/http.dart' as http;
import 'package:test/http/a.dart';
import 'package:test/http/article.dart';
import 'package:test/http/conversation.dart';
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

  //  请求话题
  static conversation(String urls) async {
    var item;
    var itemCount;
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse(urls);
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);

    //用于发帖所选话题列表数据
    final jsons = json['data'];
    conversation_item = jsons;

    //首页部分推荐话题数据
    Conversation conversation = Conversation.fromJson(json);
    return conversation;
    // setState(() {
    //   itemCount = entity.res.vertical.length;
    //   item = entity.res.vertical;
    //   // item = entity.res.vertical;
    // });
  }

  //  请求帖子
  static article(String urls) async {
    var item;
    var itemCount;
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse(urls);
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final moviesMap = json['data'];
    Article article = Article.fromJson(json);

    return article;
    // setState(() {
    //   itemCount = entity.res.vertical.length;
    //   item = entity.res.vertical;
    //   // item = entity.res.vertical;
    // });
  }

}