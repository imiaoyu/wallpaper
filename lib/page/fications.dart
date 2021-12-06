import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/http/a.dart';
import 'package:test/page/fication_view.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class classification extends StatefulWidget {
  const classification({Key? key}) : super(key: key);

  @override
  _classificationState createState() => _classificationState();
}

class _classificationState extends State<classification> {


  // var item ;
  // var itemCount;
  // void getData() async{
  //   // https://gank.io/api/v2/banners  http://service.picasso.adesk.com/v1/vertical/vertical  https://jsonplaceholder.typicode.com/posts/1
  //   // https://service.picasso.adesk.com/v1/vertical/category/4e4d610cdf714d2966000003/vertical?limit=20&adult=false&first=1&order=new
  //   var url = Uri.parse('http://service.picasso.adesk.com/v1/vertical/category');
  //   http.Response response = await http.get(url);
  //   final json = jsonDecode(response.body);
  //   final moviesMap = json['res']['category'];
  //   Fication fication = Fication.fromJson(json);
  //   print(json);
  //   setState(() {
  //     itemCount = fication.res.category.length;
  //     item = fication.res.category;
  //     // item = entity.res.category;
  //   });
  //   // for (item in item){
  //   //   print(item.cover);
  //   // }
  // }

  @override
  void initState() {
    super.initState();
    // item != null && itemCount != null ? getData() : SQToast.show('.....');
    // getData();
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    if(item == null){
      return Scaffold(
        body: Center(
          child: loading(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('分类',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 207, 211, 217),
        centerTitle:true,
      ),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          // color: Color.fromARGB(255, 165, 177, 206),
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(//SliverGridDelegateWithFixedCrossAxisCount可以直接指定每行（列）显示多少个Item   SliverGridDelegateWithMaxCrossAxisExtent会根据GridView的宽度和你设置的每个的宽度来自动计算没行显示多少个Item
              crossAxisSpacing:20.0,
              mainAxisSpacing: 20.0,
              crossAxisCount: 2,
              childAspectRatio:1.1,
            ),
            itemBuilder:  (BuildContext context, int index) {
              String imgPath = item[index]['cover'];
              String textPath = item[index]['name'];
              String id = item[index]['id'];
              // var imgPaths = item[index];
              return  ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) {
                            return new Classification_view(id: id,name:textPath);
                          },
                        ),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: imgPath,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter:
                                  ColorFilter.mode(Colors.white12, BlendMode.colorBurn)
                              ),
                            ),
                          ),
                          placeholder: (context,url){
                            return  SpinKitRotatingCircle(
                              color: Colors.yellow[100],
                              size: 20.0,
                            );
                          },
                          errorWidget: (context, url, android) {
                            print('CachedNetworkImage${imgPath}');
                            return Icon(Icons.refresh);
                          },
                        ),
                        Container(
                          color: Colors.black45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Text(textPath,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              );
            },
            itemCount: 12,
          ),
        ),
      )

    );
  }

  Widget loading() {
    return Container(
        color: Color.fromARGB(255, 207, 211, 217),
        child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SpinKitRotatingCircle(
              color: Colors.yellow[100],
              size: 20.0,
            )
        )
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