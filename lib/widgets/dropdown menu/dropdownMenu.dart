import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';

class DropdownMenu extends StatefulWidget {
 // constructor with hint text 
  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu>{
  List<String> test = ["Scroll Direction", "Vertical", "Horizontal", "Show Recipes As", "Cards", "Icons", "List"];

  @override  
  Widget build(BuildContext context) {
    return Container(
      //child: ClipRRect (
      //borderRadius: BorderRadius.circular(15.0),
      child: ConstrainedBox (
        constraints: BoxConstraints(
          maxHeight: 200.0,
          maxWidth: 100.0
        ),
          child: ListView.builder(
            itemCount: test.length, 
            itemBuilder: (context, index) {
              return Container (
                height: 100,
                color: Colors.white,
                child: Center (
                    child: Text(
                      '${test[index]}',
                      textAlign: TextAlign.center,
                    ),
                  ),
              );
            }
          )
      ),
     // ),
    );
  }
}