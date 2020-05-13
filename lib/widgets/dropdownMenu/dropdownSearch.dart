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
          padding: const EdgeInsets.all(0),
          child: ConstrainedBox (
            constraints: BoxConstraints(
              maxHeight: 200.0,
              maxWidth: 300.0
            ),
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: limitDisplay(model.inputList.length), 
              itemBuilder: (context, index) {
                return Container (
                  height: 35,
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Center (
                        child: InkWell(
                          child: Text('${model.inputList[index]}', textAlign: TextAlign.center),
                          onTap: () => print('${model.inputList[index]}'),
                        ),
                      ),
                    ],
                  ),
                );
              }
            )
          ),
        );
      }
    );
  }
}

int limitDisplay(int length) {
  if (length == 0) {
    return 0;
  } else {
    return length;
  }
}

behavior() {

}