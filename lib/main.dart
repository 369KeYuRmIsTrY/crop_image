import 'package:flutter/material.dart';
import 'imageCropperDemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageCropperDemo(),
    );
  }
}
