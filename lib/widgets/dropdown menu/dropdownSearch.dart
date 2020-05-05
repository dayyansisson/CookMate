import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/provider/searchModel.dart';
import 'package:provider/provider.dart';



class DropDownSearch extends StatefulWidget {
 // constructor with hint text 
  @override
  _DropDownSearchState createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch>{
 
  @override  
  Widget build(BuildContext context) {
    return Consumer<SearchModel>(
      builder: (context, model, _) {
        return Container(
          //child: ClipRRect (
          //borderRadius: BorderRadius.circular(15.0),
          child: ConstrainedBox (
            constraints: BoxConstraints(
              maxHeight: 200.0,
              maxWidth: 300.0
            ),
              child: ListView.builder(
                itemCount: model.inputList.length, 
                itemBuilder: (context, index) {
                  return Container (
                    height: 30,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                      //   RaisedButton(
                      //   onPressed: changeList,
                      //   color: Colors.green,
                      //   child: new Text('hi'),
                      // ),
                        Center (
                        child: Text(
                          '${model.inputList[index]}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    ),
                  );
                }
              )
          ),
        // ),
        );
      }
    );
  }
}