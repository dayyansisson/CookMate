import 'dart:ui';

import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeSheet extends StatefulWidget {

  @override
  _RecipeSheetState createState() => _RecipeSheetState();
}

class _RecipeSheetState extends State<RecipeSheet> with SingleTickerProviderStateMixin {

  /* Layout Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const double _TITLE_SIZE = 36;
  static const double _DESCRIPTION_SIZE = 20;
  static const double _INFO_SIZE = 15;
  static const double _LINE_SPACING = 1.2;
  static const double _HEAD_SPACE = 70;

  static const double _MIN_SHEET_HEIGHT = _SHEET_BORDER_RADIUS + _TITLE_SIZE + 14 + (_DESCRIPTION_SIZE * _LINE_SPACING * 3) + 40 + (_INFO_SIZE * 2) + _HEAD_SPACE;

  /* Animation Controller */
  AnimationController dragController;
  Animation<double> dragPosition;

  @override
  void initState() { 

    super.initState();
    
    dragController = AnimationController(
      vsync: this, 
      duration: Duration(seconds: 1),
    )..addListener(() => setState((){}));
    
    dragPosition = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: dragController,
      )
    );

    dragController.value = 1;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: _HEAD_SPACE),
      child: Stack(
        children: <Widget>[
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: (MediaQuery.of(context).size.height - _MIN_SHEET_HEIGHT) * dragPosition.value,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
                  topRight: Radius.circular(_SHEET_BORDER_RADIUS)
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    color: Colors.white12,
                    child: Column(
                      children: <Widget> [
                        header,
                        SizedBox(height: 35 - 30 * (1 - dragPosition.value)),
                        tagRow,
                        SizedBox(height: 85 - 60 * (1 - dragPosition.value)),
                        Expanded(child: tabBody),
                      ]
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get header {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          dragController.value += (details.primaryDelta / (MediaQuery.of(context).size.height - _MIN_SHEET_HEIGHT));
        });
      },
      onVerticalDragEnd: (details) {
        if(dragController.value > 0.5) {
          dragController.forward(from: dragController.value);
        } else {
          dragController.reverse(from: dragController.value);
        }
      },
      child: Button(
        onPressed: null,
        child: Column(
          children: <Widget> [
            _title,
            SizedBox(height: 14),
            _description,
            _horizontalInfoBar
          ]
        ),
      ),
    );
  }

  /* Getter for the header segment of the sheet */
  Widget get _title {
    
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(    // Rounded edges
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
              topRight: Radius.circular(_SHEET_BORDER_RADIUS)
            )
          ),
          height: _SHEET_BORDER_RADIUS + _TITLE_SIZE,
        ),
        Positioned(
          top: 14,
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: StyleSheet.WHITE.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(_SHEET_BORDER_RADIUS))
            ),
          ),
        ),
        Positioned(
          top: _SHEET_BORDER_RADIUS,
          left: _SHEET_BORDER_RADIUS,
          child: Text(
            "Wild Rice & Egg",
            style: TextStyle(
              fontSize: _TITLE_SIZE,
              fontFamily: 'Hoefler',
              color: StyleSheet.WHITE,
            ),
          )
        ),
      ],
    );
  }

  Widget get _description {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _SHEET_BORDER_RADIUS),
      child: Text(
        "Wild rice’s nutty and earthy flavors elevate an otherwise boring dish instantly.",
        style: TextStyle(
          fontSize: _DESCRIPTION_SIZE,
          height: _LINE_SPACING,
          color: StyleSheet.WHITE,
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }

  Widget get _horizontalInfoBar {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _SHEET_BORDER_RADIUS, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _basicInfo("Prep", "15 min"),
          _basicInfo("Cook", "10 min"),
          _basicInfo("Serves", "4-6")
        ],
      ),
    );
  }

  Widget _basicInfo(String title, String data) {

    return Column(
      children: <Widget> [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: StyleSheet.WHITE,
            fontSize: _INFO_SIZE
          ),
        ),
        Text(
          data.toUpperCase(),
          style: TextStyle(
            color: StyleSheet.WHITE,
            fontSize: _INFO_SIZE - 1,
            fontWeight: FontWeight.w300
          ),
        ),
      ]
    );
  }

  Widget get tagRow {

    List<String> tags = [
      "rice",
      "appetizers",
      "light"
    ];

    return Container(
      height: Tag.DEFAULT_SIZE * 2,
      child: ListView.builder(
        itemCount: tags.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Tag(tags[index]),
          );
        }
      ),
    );

  }

  Widget get tabBody {

    return Consumer<TabNavigationModel> (
      builder: (context, model, _) {
        Widget contents = ingredientsList;
        if(model.currentTab == 1) {
          contents = directionsList;
        }
        return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => onHorizontalSwipe(details, model),
          child: ClipPath(
            clipper: TabClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Stack(
                children: <Widget> [
                  Container(color: Colors.white12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TabBox(title: "Ingredients", index: 0),
                      TabBox(title: "Directions", index: 1),
                    ],
                  ),
                  Positioned(
                    top: TabClipper.TAB_HEIGHT,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: TabClipper.tabSpacing(MediaQuery.of(context).size.width),
                        right: TabClipper.tabSpacing(MediaQuery.of(context).size.width),
                      ),
                      child: contents,
                    ),
                  )
                ]
              )
            ),
          ),
        );
      },
    );
  }

  Widget get ingredientsList {

    return Text(
      '– 3 large brown eggs\n– 1 cup of Wild Rice\n– 2 ½ cups of Kale\n– 1 sweet potato',
      style: TextStyle(
        color: StyleSheet.WHITE,
        fontWeight: FontWeight.w300,
        fontSize: 20,
        height: 2
      ),
    );
  }

  Widget get directionsList {

    return Text(
      '– 1 of something\n– 2 cups of something else\n– 3 tbsp of the last thing',
      style: TextStyle(
        color: StyleSheet.WHITE,
        fontWeight: FontWeight.w300,
        fontSize: 20,
        height: 1.5
      ),
    );
  }

  void onHorizontalSwipe(DragEndDetails details, TabNavigationModel model) {

    if(details.primaryVelocity < 0) {
      model.currentTab++;
    } else if(details.primaryVelocity > 0) {
      model.currentTab--;
    }
  }
}

class TabBox extends StatelessWidget {

  final String title;
  final int index;

  TabBox({@required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    
    return Consumer<TabNavigationModel>(
      builder: (context, model, _) {
        bool enabled = model.currentTab == index;
        return Button(
          onPressed: () {
            model.currentTab = index;
          },
          child:
          Container(
            alignment: Alignment.center,
            width: TabClipper.tabSize(screenWidth) / 2,
            height: TabClipper.TAB_HEIGHT,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: enabled ? 0 : 0.06,
                  duration: Duration(milliseconds: 200),
                  child: Container(  // Tab indicator
                    color: Colors.black,
                    height: TabClipper.TAB_HEIGHT,
                    width: screenWidth / 2,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: enabled ? 16 : 15,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: AnimatedOpacity(
                      opacity: enabled ? 1 : 0.5,
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}

class TabClipper extends CustomClipper<Path> {

  static const double TAB_HEIGHT = 50;
  static const double TAB_RADIUS = 30;
  static const double TAB_SIZE_FACTOR = 0.85;

  static double tabSize(double screenWidth) => screenWidth * TAB_SIZE_FACTOR;
  static double tabSpacing(double screenWidth) => (screenWidth - tabSize(screenWidth))/2;

  @override
  Path getClip(Size size) {

    double width = tabSize(size.width);

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH((size.width - width)/2, 0, width, size.height),
          const Radius.circular(TAB_RADIUS)
        )
      )..addRect(Rect.fromLTWH(0, TAB_HEIGHT, size.width, size.height - TAB_HEIGHT))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => false;
}