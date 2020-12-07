// import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/playground.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'backend/backend2.dart';

void main() async {
  // Initializes flutter properly while waiting to bulid db
  WidgetsFlutterBinding.ensureInitialized();

  // Creates database
  await DB.init();
  runApp(CookMate());
}

class CookMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        title: 'CookMate',
        debugShowCheckedModeBanner: false,
        theme: StyleSheet.theme,
        home: Playground());
  }
}
