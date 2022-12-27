import 'package:flutter/material.dart';

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
    const TWO_PI = 3.14 * 2;
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