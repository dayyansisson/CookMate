import 'package:CookMate/widgets/pageLayout/driver.dart';
import 'package:flutter/material.dart';

import 'widgets/backendTest.dart';

/* This class only exists for us to develop different parts of the app 
   without affecting each other's work.
*/
class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BackendTest(),
          ),
        ),
      ),
    );
  }
}
