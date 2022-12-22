import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ValueNotifierExample extends StatefulWidget {
  ValueNotifier<double> valueNotifier;
  ValueNotifierExample({Key? key, required this.valueNotifier})
      : super(key: key);

  @override
  State<ValueNotifierExample> createState() => _ValueNotifierExampleState();
}

class _ValueNotifierExampleState extends State<ValueNotifierExample> {
  final centerTextStyle = const TextStyle(
    fontSize: 48,
    color: Color.fromARGB(255, 238, 22, 7),
    fontWeight: FontWeight.bold,
  );

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = widget.valueNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SimpleCircularProgressBar(
      fullProgressColor: Color.fromARGB(255, 0, 209, 17),
      animationDuration: 0,
      size: 200,
      valueNotifier: valueNotifier,
      progressStrokeWidth: 24,
      backStrokeWidth: 24,
      mergeMode: true,
      onGetText: (value) {
        return Text(
          '%${value.toInt()}',
          style: centerTextStyle,
        );
      },
      progressColors: const [Colors.cyan, Colors.purple],
      backColor: Colors.black.withOpacity(0.4),
    ));
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
