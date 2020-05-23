import 'package:CookMate/controllers/searchController.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';

enum SearchType { Ingredient, Recipe }

class SearchBar extends StatefulWidget {

  final SearchType searchType;
  SearchBar(this.searchType);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  static const double BAR_DROPDOWN_SPACING = 5;

  FocusNode _focusNode;
  OverlayEntry _overlayEntry;
  _DropDownSearch dropdown;

  TextEditingController textController;
  List<String> ingredientList;

  @override
  void initState() {

    super.initState();

    ingredientList = List<String>();
    textController = TextEditingController();
    initFocusNode();
  }

  void initFocusNode() {

    _focusNode = FocusNode()
    ..addListener(
      () {
        if(_focusNode.hasFocus) {
          this._overlayEntry = this._createOverlayEntry();
          Overlay.of(context).insert(this._overlayEntry);
        } else {
          this._overlayEntry.remove();
        }
      }
    );
  }

  void clearText() => textController.clear();

  OverlayEntry _createOverlayEntry() {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
         left: size.width / 12,
         top: size.height + offset.dy + BAR_DROPDOWN_SPACING,
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: dropdown
          ),
        ),
      )
    );
  }

  void onChangedIngredients(String value) async {

    dropdown = _DropDownSearch(await SearchController().findIngredients(value), clearText);
    Overlay.of(context).setState((){});
  }

  void onChangedRecipes(String value) async => SearchController().getRecipesBySubstring(value);

  @override
  Widget build(BuildContext context) {

    return Container(
        child: ConstrainedBox (
        constraints: BoxConstraints(
          maxHeight: 45.0,
          maxWidth: 400.0
        ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: textController,
                focusNode: _focusNode,
                onChanged: (value) {
                  if (value == '') {
                    ingredientList.clear();
                  } else {
                    if(widget.searchType == SearchType.Ingredient) {
                      onChangedIngredients(value);
                    } else {
                      onChangedRecipes(value);
                    }
                  }
                },
                style: TextStyle(color: StyleSheet.WHITE),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                  hintText: hint,
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
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
              ),
          ),
        ),
    );
  }

  String get hint {

    if(widget.searchType == SearchType.Ingredient) {
      return 'Type in an ingredient...';
    } else {
      return 'Type in a recipe...';
    }
  }
}

class _DropDownSearch extends StatefulWidget {

 // constructor with hint text 
  final List<String> inputList;
  final Function callback;
  _DropDownSearch(this.inputList, this.callback);

  @override
  __DropDownSearchState createState() => __DropDownSearchState();
}

class __DropDownSearchState extends State<_DropDownSearch>{

  @override  
  Widget build(BuildContext context) {
    
    return ConstrainedBox (
      constraints: BoxConstraints(
        maxHeight: 200.0,
        maxWidth: 300
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: StyleSheet.BLACK.withOpacity(0.4),
                blurRadius: 5,
                offset: Offset(0, 2)
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: widget.inputList.length, 
              itemBuilder: (context, index) {
                return Button(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 48),
                    alignment: Alignment.center,
                    color: StyleSheet.WHITE,
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
                    print('Adding "${widget.inputList[index]}" to search');
                    setState(() {
                      widget.callback();
                      SearchController().addIngredientToSearch(widget.inputList[index]);
                      widget.inputList.clear();
                    });
                  },
                );
              }
            ),
          ),
        )
      ),
    );
  }
}