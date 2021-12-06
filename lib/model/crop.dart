import 'dart:ui' as ui;
import 'package:test/model/centered_slider_track_shape.dart';
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';
import 'package:test/page/full_screenimagepage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHome();
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<StatefulWidget> {
  final controller = CropController(aspectRatio: 1000 / 667.0);
  double _rotation = 0;
  BoxShape shape = BoxShape.rectangle;
  var  imageurl;

  @override
  void initState() {
    super.initState();
    // read();
  }

  // void read() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     imageurl = prefs.getString('imageurl');
  //   });
  //
  // }

  void _cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);
    print(cropped);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor:  Color.fromARGB(255, 207, 211, 217),
            leading: IconButton(
              icon: Icon(LineAwesomeIcons.angle_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('请设定',
            style: TextStyle(
              fontSize: 18
            ),
            ),
            centerTitle: true,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(LineAwesomeIcons.mobile_phone),
                  onPressed: () async {
                    print(await _saveScreenShot(cropped));

                    // final status = await Permission.storage.request();
                    // if (status == PermissionStatus.granted) {
                    //   await _saveScreenShot(cropped);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Saved to gallery.'),
                      //   ),
                      // );
                    // }
                  },
                ),
              ),
            ],
          ),
          body: Center(
            child: RawImage(
              image: cropped,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:  Color.fromARGB(255, 207, 211, 217),
        title: Text('裁剪',
        style: TextStyle(
          fontSize: 18
        ),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.link),
        //   onPressed: () {
        //     launch('https://github.com/xclud/flutter_crop');
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            onPressed: _cropImage,
            tooltip: 'Crop',
            icon: Icon(LineAwesomeIcons.crop),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Crop(
                onChanged: (decomposition) {
                  if (_rotation != decomposition.rotation) {
                    setState(() {
                      _rotation = ((decomposition.rotation + 180) % 360) - 180;
                    });
                  }

                  print(
                      "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                },
                controller: controller,
                shape: shape,
                child: Image.network(
                  imageurl,
                  fit: BoxFit.cover,
                ),
                /* It's very important to set `fit: BoxFit.cover`.
                   Do NOT remove this line.
                   There are a lot of issues on github repo by people who remove this line and their image is not shown correctly.
                */
                foreground: IgnorePointer(
                  child: Container(
                    alignment: Alignment.bottomRight,
//                    水印
                    // child: Text(
                    //   'Foreground Object',
                    //   style: TextStyle(color: Colors.red),
                    // ),
                  ),
                ),
                helper: shape == BoxShape.rectangle
                    ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                )
                    : null,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(LineAwesomeIcons.alternate_undo),
                tooltip: 'Undo',
                onPressed: () {
                  controller.rotation = 0;
                  controller.scale = 1;
                  controller.offset = Offset.zero;
                  setState(() {
                    _rotation = 0;
                  });
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    trackShape: CenteredRectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    divisions: 360,
                    value: _rotation,
                    min: -180,
                    max: 180,
                    label: '$_rotation°',
                    onChanged: (n) {
                      setState(() {
                        _rotation = n.roundToDouble();
                        controller.rotation = _rotation;
                      });
                    },
                  ),
                ),
              ),
              PopupMenuButton<BoxShape>(
                icon: Icon(LineAwesomeIcons.alternate_crop),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Box"),
                    value: BoxShape.rectangle,
                  ),
                  PopupMenuItem(
                    child: Text("Oval"),
                    value: BoxShape.circle,
                  ),
                ],
                tooltip: 'Crop Shape',
                onSelected: (x) {
                  setState(() {
                    shape = x;
                  });
                },
              ),
              PopupMenuButton<double>(
                icon: Icon(LineAwesomeIcons.expand),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Original"),
                    value: 1000 / 667.0,
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: Text("16:9"),
                    value: 16.0 / 9.0,
                  ),
                  PopupMenuItem(
                    child: Text("4:3"),
                    value: 4.0 / 3.0,
                  ),
                  PopupMenuItem(
                    child: Text("1:1"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("3:4"),
                    value: 3.0 / 4.0,
                  ),
                  PopupMenuItem(
                    child: Text("9:16"),
                    value: 9.0 / 16.0,
                  ),
                ],
                tooltip: 'Aspect Ratio',
                onSelected: (x) {
                  controller.aspectRatio = x;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> _saveScreenShot(ui.Image img) async {
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new FullScreenImagePage(imageurl: null,)
        ), (route) => route == null);

    print(byteData);
    // var buffer = byteData!.buffer.asUint8List();
    // print(buffer);
    // final result = await ImageGallerySaver.saveImage(buffer);
    // print(result);

    // return result;
    return byteData;
  }
  
}

