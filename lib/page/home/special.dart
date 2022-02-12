import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';



class Special extends StatefulWidget {
  const Special({Key? key}) : super(key: key);

  @override
  _SpecialState createState() => _SpecialState();
}

class _SpecialState extends State<Special> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('专题',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 207, 211, 217),
        centerTitle:true,
      ),
      body: Container(
        child: ListView(
          children: [
            List()
          ],
        ),
      ),
    );
  }


  Widget List(){
    return Column(
      children: <Widget>[
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        ),
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        ),
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        ),
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        ),
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        ),
        Container(
          color: Colors.blueAccent,
          height: 100,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
            child: Text('春天'),
          ),
        )
      ],
    );
  }
}
