import 'package:CookMate/playground.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(CookMate());

class CookMate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'CookMate',
      debugShowCheckedModeBanner: false,
      theme: StyleSheet.theme,
      home: Playground()
    );
  }
}