// main.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'KindaCode.com',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _fetchData(BuildContext context) async {
    int i = 0;
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.all(15),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.red)),
            elevation: 15,
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  progress2(i),
                  // progres(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...'),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        i++;
                      },
                      child: Text("arttır"))
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 4));

    // Close the dialog programmatically
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
     
    CustomCircleProgresIndicator circleProgresIndicator =
        CustomCircleProgresIndicator(
            increaceProgres: () => i++,);

    return Scaffold(
      appBar: AppBar(title: const Text('KindaCode.com')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => circleProgresIndicator);
          
          },
          child: const Text('Load Data'),
        ),
      ),
    );
  }
}

class CustomCircleProgresIndicator extends StatefulWidget {
  int Function() increaceProgres;
  VoidCallback? onError;
  CustomCircleProgresIndicator(
      {required this.increaceProgres, this.onError, super.key});

  var st = _CustomCircleProgresIndicatorState();

  @override
  State<CustomCircleProgresIndicator> createState() => st;
}

class _CustomCircleProgresIndicatorState
    extends State<CustomCircleProgresIndicator> {
  final size = 200.0;
  int percentage = 0;
  String message = 'lütfen bekleyin...';

  @override
  void initState() {
    if (widget.onError != null) {
      widget.onError = () => closeDialog();
    }
    super.initState();
  }

  closeDialog() {
    Navigator.of(context).pop();
  }

  updateMessage(String messageOut) {
    setState(() {
      message = messageOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(

      insetPadding: EdgeInsets.all(15),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.red, width: 2)),
      elevation: 15,
      // The background color
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The loading indicator
            Container(
              width: size,
              height: size,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return SweepGradient(
                              startAngle: 0.0,
                              endAngle: TWO_PI,
                              stops: [
                                percentage.toDouble() / 100,
                                percentage.toDouble() / 100
                              ],
                              // 0.0 , 0.5 , 0.5 , 1.0
                              center: Alignment.center,
                              colors: [Colors.blue, Colors.grey.withAlpha(55)])
                          .createShader(rect);
                    },
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  Image.asset("assets/images/radial_scale.png")
                                      .image)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: size - 40,
                      height: size - 40,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                          child: Text(
                        "%$percentage",
                        style: TextStyle(
                            fontSize: 40,
                            color: Color.fromRGBO(
                                percentage > 50 ? percentage + 155 : percentage,
                                0,
                                0,
                                100)),
                      )),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Some text
            Text(
              message,
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}

const TWO_PI = 3.14 * 2;
final size = 200.0;
final _random = Random();

Widget progres() => Center(
      // This Tween Animation Builder is Just For Demonstration, Do not use this AS-IS in Projects
      // Create and Animation Controller and Control the animation that way.
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(seconds: 4),
        builder: (context, value, child) {
          print("anlık value $value");
          int percentage = (value * 100).ceil();
          return Container(
            width: size,
            height: size,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                            startAngle: 0.0,
                            endAngle: TWO_PI,
                            stops: [value, value],
                            // 0.0 , 0.5 , 0.5 , 1.0
                            center: Alignment.center,
                            colors: [Colors.blue, Colors.grey.withAlpha(55)])
                        .createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.asset("assets/images/radial_scale.png")
                                .image)),
                  ),
                ),
                Center(
                  child: Container(
                    width: size - 40,
                    height: size - 40,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      "%$percentage",
                      style: TextStyle(
                          fontSize: 40,
                          color: Color.fromRGBO(
                              percentage > 50 ? percentage + 155 : percentage,
                              0,
                              0,
                              100)),
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

Widget progress2(int percentage) {
  return Container(
    width: size,
    height: size,
    child: Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
                    startAngle: 0.0,
                    endAngle: TWO_PI,
                    stops: [
                      percentage.toDouble() / 100,
                      percentage.toDouble() / 100
                    ],
                    // 0.0 , 0.5 , 0.5 , 1.0
                    center: Alignment.center,
                    colors: [Colors.blue, Colors.grey.withAlpha(55)])
                .createShader(rect);
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:
                        Image.asset("assets/images/radial_scale.png").image)),
          ),
        ),
        Center(
          child: Container(
            width: size - 40,
            height: size - 40,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
                child: Text(
              "%$percentage",
              style: TextStyle(
                  fontSize: 40,
                  color: Color.fromRGBO(
                      percentage > 50 ? percentage + 155 : percentage,
                      0,
                      0,
                      100)),
            )),
          ),
        )
      ],
    ),
  );
}
