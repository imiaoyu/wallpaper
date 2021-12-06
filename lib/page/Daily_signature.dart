import 'package:flutter/material.dart';



class Daily_signature extends StatefulWidget {
  var Daily_data_image;
  var Daily_data_title;
    Daily_signature({Key? key, required this.Daily_data_image, this.Daily_data_title}) : super(key: key);

  @override
  _Daily_signatureState createState() => _Daily_signatureState();
}

class _Daily_signatureState extends State<Daily_signature> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    print(DateTime.now().day);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          fit: StackFit.expand,
          alignment:Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.Daily_data_image),
                  fit: BoxFit.cover,
                ),
              ),
              // height: 120,
            ),
            Positioned(
                left: 70,
                top: 100,
                child: Container(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('${DateTime.now().day}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontFamily: 'Roboto-Black',
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(15.0, 15.0),
                              blurRadius: 30.0,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),

                      Text('   Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Roboto-Black',
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(15.0, 15.0),
                              blurRadius: 30.0,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
            ),
            // Positioned(
            //     left: 120,
            //     top: 73,
            //     child: Container(
            //       margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            //       child: Text('Day',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 28,
            //           fontFamily: 'Roboto-Black',
            //           fontWeight: FontWeight.bold,
            //           shadows: <Shadow>[
            //             Shadow(
            //               offset: Offset(8.0, 8.0),
            //               blurRadius: 30.0,
            //               color: Colors.black12,
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            // ),
            Stack(
            // 使用alignment配合FractionalOffset：对于FractionalOffset的参数，我是这么理解的：相当于比例，第一个代表横向的权重，第二个代表竖向的权重，横0.9代表在横向十分之九的位置，竖0.1代表在竖向十分之一的位置
              alignment: const FractionalOffset(0.5, 0.9),
              children: <Widget>[
                Container(
                  // color: Colors.red,
                    // margin: EdgeInsets.fromLTRB(0, 600, 0, 0),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(widget.Daily_data_title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Roboto-Black',
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
              ],
            )

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Container(
            //           margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            //           child: Text('${DateTime.now().day}',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 80,
            //                 fontFamily: 'Roboto-Black',
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         Container(
            //           margin: EdgeInsets.fromLTRB(10, 80, 0, 0),
            //           child: Text('Step ${DateTime.now().year}',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 24,
            //                 fontFamily: 'Roboto-Black',
            //                 fontWeight: FontWeight.bold,
            //               )
            //            )
            //         )
            //       ],
            //     ),
            //     Container(
            //       width: 250,
            //       margin: EdgeInsets.fromLTRB(30, 400, 0, 40),
            //       child: Positioned(
            //         bottom: 100.0,
            //         left: 25.0,
            //         width: 250,
            //         child: Text(widget.Daily_data_title,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 14,
            //             fontFamily: 'Roboto-Black',
            //             // fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      )
    );
  }
}
