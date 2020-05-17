
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/provider/searchModel.dart';
import 'package:provider/provider.dart';



class DropDownSearch extends StatefulWidget {
 // constructor with hint text 

  List<String> inputList;
  bool selected;
  DropDownSearch(this.inputList, this.selected);

  @override
  _DropDownSearchState createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch>{

  @override  
  Widget build(BuildContext context) {
        return ConstrainedBox (
          constraints: BoxConstraints(
            maxHeight: 200.0,
            maxWidth: 300.0
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
               borderRadius: BorderRadius.all(Radius.circular(30)),
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: widget.inputList.length, 
                itemBuilder: (context, index) {
                  return Button(
                    child: Container(
                      height: 40, 
                      alignment: Alignment.center,
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                      widget.inputList[index].toLowerCase(), 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: StyleSheet.DEEP_GREY
                      ),
                    ),
                    ),
                    onPressed: () {
                      print('${widget.inputList[index]}');
                      setState(() {
                        widget.inputList = [];
                      });
                      //clearSearch(true, model)
                      //widget.inputList = [];
                      },
                  );
                }
              ),
            )
          ),
        );
  }
}

void changeList(List<String> list, SearchModel model) {
  model.updateList(list);
}
