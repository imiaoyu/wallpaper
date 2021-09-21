import 'package:flutter/material.dart';
// import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:test/page/bar.dart';
import 'package:test/page/home.dart';
import 'package:test/page/images.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:test/page/my.dart';
import 'package:test/page/atlas.dart';
void main() => runApp(Bar());

class Bar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Bubble Bottom Bar Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: BarPage(title: '这是一个标题'),
    // );
    return BarPage(title: '这是一个标题');
  }
}

class BarPage extends StatefulWidget {

  BarPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _BarPageState createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  final PageController controller = PageController(
    initialPage: 0,
  );

  late int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    // controller.jumpToPage(index);
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[300],
      // ),
      // body: Row(
      //   children: <Widget>[
      //     Text(currentIndex.toString())
      //   ],
      // ),
      body: IndexedStack(
        children: <Widget>[
            Home(),
            Images(),
            // Demo(),
            // Container(color: Colors.green),
            MyHomePage()
          ],
          index:currentIndex,
      ),

      // PageView(
      //   controller: controller,
      //   children: <Widget>[
      //     Home(),
      //     My(),
      //     // TravelPage(),
      //     // MyPage(),
      //   ],
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('add');
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("首页"),
            selectedColor: Colors.black87,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.image),
            title: Text("图推"),
            selectedColor: Colors.black87,
          ),

          /// Search
          // SalomonBottomBarItem(
          //   icon: Icon(Icons.photo_library),
          //   title: Text("图集"),
          //   selectedColor: Colors.black87,
          // ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("我的"),
            selectedColor: Colors.black87,
          ),
        ],
      ),
    );
  }
}