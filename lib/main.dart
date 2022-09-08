import 'package:flutter/material.dart';

import 'Layout/Todo_Layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeLayOut(),
    );
  }
}
