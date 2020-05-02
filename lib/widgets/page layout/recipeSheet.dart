import 'dart:ui';
import 'package:CookMate/provider/recipeModel.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/marquee.dart';
import 'package:CookMate/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  ScrollController directionsScrollController;

  RecipeModel recipe;

  @override
  void initState() { 

    super.initState();

    recipe = Provider.of<RecipeModel>(context, listen: false);
    directionsScrollController = ScrollController()..addListener(directionsScrollListener);
    
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

  void directionsScrollListener () {

    if(directionsScrollController.position.outOfRange) {
      TabNavigationModel model = Provider.of<TabNavigationModel>(context, listen: false);
      if(directionsScrollController.offset < directionsScrollController.position.minScrollExtent - 80) {
        model.expandSheet = true;
      } else if(directionsScrollController.offset > directionsScrollController.position.maxScrollExtent + 80){
        model.expandSheet = false;
      }
    }
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
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    color: StyleSheet.TAB_GREY.withOpacity(0.3),
                    child: Column(
                      children: <Widget> [
                        header,
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
      onVerticalDragEnd: (details) {    // TODO account for user acceleration and velocity
        if(dragController.value > 0.5) {
          dragController.forward(from: dragController.value);
          Provider.of<TabNavigationModel>(context, listen: false).expandSheet = true;
        } else {
          dragController.reverse(from: dragController.value);
        }
      },
      child: Button(
        onPressed: null,
        child: Column(
          children: <Widget>[
            _title,
            SizedBox(height: 14),
            _ExpandableWidget(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              children: <Widget>[
                _description,     // TODO fix overflow
                _horizontalInfoBar,
                SizedBox(height: 35 - 30 * (1 - dragPosition.value)),
                tagRow,
                SizedBox(height: 85 - 60 * (1 - dragPosition.value)),
              ],
            )
          ],
        )
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
          child: Container(
            width: MediaQuery.of(context).size.width - (2 * _SHEET_BORDER_RADIUS),
            height: _TITLE_SIZE,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Marquee(
                    recipe.title,
                    style: TextStyle(
                      fontSize: _TITLE_SIZE,
                      fontFamily: 'Hoefler',
                      color: StyleSheet.WHITE,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -10),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: _ExpandIcon(
                      Provider.of<TabNavigationModel>(context, listen: true).expandSheet
                      ? Icons.arrow_drop_down : Icons.arrow_right,
                      1 - dragController.value
                    ),
                  ),
                )
              ],
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
        recipe.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
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
          _basicInfo("Prep", recipe.prepTime),
          _basicInfo("Cook", recipe.cookTime),
          _basicInfo("Serves", recipe.servings)
        ],
      ),
    );
  }

  Widget _basicInfo(String title, String data) {

    if(data == null) {
      data = "None";
    }

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

    if(recipe.tags == null) {
      return Container();
    }

    List<Widget> row = List<Widget>();
    row.add(Container(width: 15));
    row.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Tag(content: recipe.category)));
    for(String tag in recipe.tags) {
      row.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Tag(content: tag)));
    }
    row.add(Container(width: 15));

    return Container(
      height: Tag.DEFAULT_SIZE * 2,
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: row,
      ),
    );
  }

  Widget get tabBody {

    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TabNavigationModel> (
      builder: (context, model, _) {
        Widget contents = ingredientsList;
        if(model.currentTab == 1) {
          contents = directionsList;
        }
        return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => onHorizontalSwipe(details, model),
          child: ClipPath(
            clipper: _TabClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                color: Colors.white12,
                child: Column(
                  children: <Widget> [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _TabBox(title: "Ingredients", index: 0),
                        _TabBox(title: "Directions", index: 1),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: _TabClipper.tabSpacing(screenWidth),
                        ),
                        child: Transform.translate(
                          offset: Offset(-_TabClipper.TAB_RADIUS / 2, -5),
                          child: Container(
                            width: screenWidth -  (2 * _TabClipper.tabSpacing(screenWidth)),
                            child: ShaderMask(          // TODO FIX THE SHADER AMOUNT
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment(0, -1),
                                  end: Alignment(0, -0.92),
                                  colors: [Colors.transparent, Colors.black],
                                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: contents
                            )
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              )
            ),
          ),
        );
      },
    );
  }

  Widget get ingredientsList {

    return Text(
      '– 3 large brown egsqwertfyudhkdfgh\n– 1 cup of Wild Rice\n– 2 ½ cups of Kale\n– 1 sweet potato',
      style: TextStyle(
        color: StyleSheet.WHITE,
        fontWeight: FontWeight.w300,
        fontSize: 20,
        height: 2
      ),
    );
  }

  Widget get directionsList {

    final double textWidth = MediaQuery.of(context).size.width - (_TabClipper.TAB_RADIUS * 10/3);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: recipe.steps.length,
            controller: directionsScrollController,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: _TabClipper.TAB_RADIUS,
                      alignment: Alignment.center,
                      child: Text(
                        "${(index + 1).toString()}.",
                        style: TextStyle(
                        color: StyleSheet.WHITE,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      )
                    ),
                    Container(width: _TabClipper.TAB_RADIUS / 3),
                    Container(
                      width: textWidth,
                      child: Text(
                        recipe.steps[index],
                        style: TextStyle(
                          color: StyleSheet.WHITE,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
        Container(height: _HEAD_SPACE)
      ],
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

class _TabBox extends StatelessWidget {

  final String title;
  final int index;

  _TabBox({@required this.title, @required this.index});

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
            width: _TabClipper.tabSize(screenWidth) / 2,
            height: _TabClipper.TAB_HEIGHT,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: enabled ? 0 : 0.06,
                  duration: Duration(milliseconds: 200),
                  child: Container(  // Tab indicator
                    color: Colors.black,
                    height: _TabClipper.TAB_HEIGHT,
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

class _TabClipper extends CustomClipper<Path> {

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
  bool shouldReclip(_TabClipper oldClipper) => false;
}

class _ExpandIcon extends StatelessWidget {

  final IconData icon;
  final double iconOpacity;
  _ExpandIcon(this.icon, this.iconOpacity) : super(key: ValueKey<IconData>(icon));

  @override
  Widget build(BuildContext context) {
    TabNavigationModel model = Provider.of<TabNavigationModel>(context);
    return IconButton(
      onPressed: () { 
        if(iconOpacity == 1) {
          model.expandSheet = !model.expandSheet;
        }
      },
      splashColor: Colors.transparent,
      icon: Icon(
        icon,
        color: StyleSheet.WHITE.withOpacity(0.4 * iconOpacity),
        size: 36,
      ),
    );
  }
}

class _ExpandableWidget extends StatefulWidget {

  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  _ExpandableWidget({ @required this.children, @required this.duration, @required this.curve});

  @override
  __ExpandableWidgetState createState() => __ExpandableWidgetState();
}

class __ExpandableWidgetState extends State<_ExpandableWidget> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _expanded;

  @override
  void initState() { 
    super.initState();
    
    _expanded = true;
    _controller = AnimationController(vsync: this, duration: widget.duration)..addListener(() => setState(() {}));
    _controller.value = 1;
  }

  void animate(bool setExpand) {

    if(setExpand == _expanded) {
      return;
    }

    _expanded = setExpand;

    Animation animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _heightFactor = Tween<double>(begin: 0, end: 1).animate(animation)..addListener(() => setState(() {}));
    if(setExpand) {
      _controller.forward(from: _controller.value);
    } else {
      _controller.reverse(from: _controller.value);
    }
  }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   animate(Provider.of<TabNavigationModel>(context).expandSheet);
 }
  
  @override
  Widget build(BuildContext context) {

    return Consumer<TabNavigationModel> (
      builder: (context, model, _) {
        return ClipRect(
          child: Align(
            heightFactor: _heightFactor == null ? 1 : _heightFactor.value,
            child: Opacity(
              opacity: _heightFactor == null ? 1 : _heightFactor.value,
              child: Column(children: widget.children)
            ),
          ),
        );
      }
    );
  }
}