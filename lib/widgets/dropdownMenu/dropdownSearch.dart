import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
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
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: ConstrainedBox (
            constraints: BoxConstraints(
              maxHeight: 200.0,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: limitDisplay(model.inputList.length), 
              itemBuilder: (context, index) {
                if(index == 0 || index == limitDisplay(model.inputList.length - 1)) { // Top & Bottom Padding
                  return Container(height: 10, color: StyleSheet.WHITE);
                }

                return Button(
                  child: Container (
                    height: 40,
                    alignment: Alignment.center,
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.inputList[index].toLowerCase(), 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: StyleSheet.DEEP_GREY
                      ),
                    ),
                  ),
                  onPressed: () => print('${model.inputList[index]}'),
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