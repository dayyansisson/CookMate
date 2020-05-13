import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/provider/searchModel.dart';
import 'package:provider/provider.dart';
import 'package:CookMate/Controllers/SearchController.dart';


class SearchBar extends StatefulWidget {
 // constructor with hint text 
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>{
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchModel>(
      builder: (context, model, _) {
        return ConstrainedBox (
          constraints: BoxConstraints(
            maxHeight: 45.0,
            maxWidth: 400.0
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                onChanged: (value) async {
                  print(value);
                  if (value == '') {
                    model.inputList = [];
                    changeList(model.inputList, model);
                  } else {
                    List<String> temp = await SearchController().findIngredients(value);
                    model.inputList = temp;
                    print("First element" + model.inputList[0]);
                    changeList(model.inputList, model);
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                  hintText: "Type in a ...",
                  hintStyle: TextStyle(fontSize: 15.0, color: Color.fromRGBO(255, 255, 255, 0.5)),
                  prefixIcon: Icon(
                    CookMateIcon.search_icon,
                    size: 17,
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

void changeList(List<String> list, SearchModel model) => model.updateList(list);