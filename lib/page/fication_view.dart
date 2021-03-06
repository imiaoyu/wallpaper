import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:test/http/entity.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:test/model/toast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Classification_view extends StatefulWidget {
  var  id;
  var name;
  Classification_view({Key? key,required this.id,this.name}) : super(key: key);
  @override
  _Classification_view createState() {
    return _Classification_view();
  }
}

class _Classification_view extends State<Classification_view> {

  var item;
  var itemCount;

  Future getData() async {
    // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
    // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
    var url = Uri.parse(
        'http://service.picasso.adesk.com/v1/vertical/category/${widget
            .id}/vertical?limit=50&adult=false&first=1&order=new');
    http.Response response = await http.get(url);
    final json = jsonDecode(response.body);
    final moviesMap = json['res']['vertical'];

    // print(json);

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
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Scaffold(
        body: Center(
          child: loading(),
        ),
      );
    }

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.angle_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.name,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 207, 211, 217),
          // backgroundColor: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          // color: Colors.black87,
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount( //SliverGridDelegateWithFixedCrossAxisCount????????????????????????????????????????????????Item   SliverGridDelegateWithMaxCrossAxisExtent?????????GridView???????????????????????????????????????????????????????????????????????????Item
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              crossAxisCount: 3,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (BuildContext context, int index) {
              return itemWidget(index);
            },
            itemCount: itemCount,
          ),
        )
    );
  }

  Widget itemWidget(int index) {
    String imgPath = item[index].thumb;
    var imgPaths = item[index];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return new FullScreenImagePage(imageurl: imgPaths);
            },
          ),
        );
      },
      child:
      CachedNetworkImage(
        imageUrl: imgPath,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) =>
            Container(
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
        //      Image.asset('images/wallfy.png'),
        //????????????:?????????????????????????????????,?????????????????????,?????????????????????,??????????????????????????????,????????????,???????????????????????????,?????????????????????.
        //CachedNetworkImage
        placeholder: (context, url) {
          return SpinKitRotatingCircle(
            color: Color.fromARGB(255, 165, 177, 206),
            size: 20.0,
          );
        },
        errorWidget: (context, url, android) {
          print('CachedNetworkImage${item}');
          return Icon(Icons.refresh);
        },
      ),
    );
  }

  Widget loading() {
    return Container(
        color: Colors.black87,
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