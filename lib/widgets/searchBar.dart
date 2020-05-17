import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/dropdownMenu/dropdownSearch.dart';
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

  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;

  DropDownSearch searchBar;

  @override
  void initState() {
    super.initState();
    initFocusNode();
  }

  void initFocusNode() async {
    //Future.delayed(Duration(microseconds: 1));
    _focusNode.addListener(() {
              if (_focusNode.hasFocus) {

        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
        //Overlay.of(context).setState(fn)

      } else {
        this._overlayEntry.remove();
      }
    }
    );
  }

  OverlayEntry _createOverlayEntry() {

    print('here');

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
         left: size.width / 12,
         top: size.height + offset.dy,
        //width: size.width,
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: searchBar
          ),
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchModel>(
      builder: (context, model, _) {
        return  Container(
           child: ConstrainedBox (
            constraints: BoxConstraints(
              maxHeight: 45.0,
              maxWidth: 400.0
            ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: (value) async {
                        print(value);
                        if (value == '') {
                          print('In empty');
                          model.inputList = [];
                          changeList(model.inputList, model);
                        } else {
                          List<String> temp = await SearchController().findIngredients(value);
                          model.inputList = temp;
                          //print("First element" + model.inputList[0]);
                          changeList(model.inputList, model);
                        }
                        searchBar = DropDownSearch(model.inputList);
                        Overlay.of(context).setState((){});
                    },
                    style: TextStyle(color: StyleSheet.WHITE),
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
           ),
        );
      }
    );
  }
}

void changeList(List<String> list, SearchModel model) {
  model.updateList(list);
}