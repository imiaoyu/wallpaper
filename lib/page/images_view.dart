import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:test/model/toast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


//首页全部XX
class Images_view extends StatefulWidget {
  var  image_list;
  var  title_bar;
  var  image_list_count;
  Images_view({Key? key,required this.image_list,this.title_bar,this.image_list_count}) : super(key: key);
  @override
  _Images_view createState() {
    return _Images_view();
  }
}

class _Images_view extends State<Images_view> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.angle_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.title_bar,
            style: TextStyle(
                fontSize: 16,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 207, 211, 217),
          // backgroundColor: colors.isNotEmpty ? colors[0].color: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body:Container(
            // color: Colors.black87,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(//SliverGridDelegateWithFixedCrossAxisCount可以直接指定每行（列）显示多少个Item   SliverGridDelegateWithMaxCrossAxisExtent会根据GridView的宽度和你设置的每个的宽度来自动计算没行显示多少个Item
                crossAxisSpacing:10.0,
                mainAxisSpacing: 10.0,
                crossAxisCount: 2,
                childAspectRatio:0.6,
              ),
              itemBuilder:  (BuildContext context, int index) {
                return itemWidget(index);
              },
              itemCount: widget.image_list_count,
            ),
        )
    );
  }
  Widget  itemWidget(int index) {
    String item = widget.image_list[index].img;
    var items = widget.image_list[index];
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return new FullScreenImagePage(imageurl: items);
            },
          ),
        );
      },
      child:
      CachedNetworkImage(
          imageUrl: item,
          fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
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
          //有网情况:网络下载图片缓存到本地,当第二次打开时,不下载网络图片,使用缓存到本地的图片,若没有网,没有缓存到本地图片,则使用默认图片.
          //CachedNetworkImage
          placeholder: (context,url){
            return  SpinKitRotatingCircle(
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
}
