import 'package:flutter/material.dart';

class rounded_corner_button extends StatelessWidget {
  String text;
  Color color;
  void Function() function;
  rounded_corner_button({required this.text,required this.color,required this.function});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.lightBlueAccent,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: function,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          text,
        ),
      ),
    );
  }
}
