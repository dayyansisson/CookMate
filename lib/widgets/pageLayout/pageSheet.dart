import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSheet extends StatefulWidget {

  final List<SheetTab> tabs;
  PageSheet(this.tabs);

  PageSheet.builder({ @required int tabCount, @required SheetTab Function(int) builder }) : tabs = List<SheetTab>(tabCount) {

    for(int index = 0; index < tabCount; index++) {
      tabs[index] = builder(index);
    }
  }

  @override
  _PageSheetState createState() => _PageSheetState();
}

class _PageSheetState extends State<PageSheet> with TickerProviderStateMixin {

  /* Layout Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const int _NAVIGATION_SPACING = 20;

  /* Animation Constants */
  static const Curve BODY_CURVE = const Interval(0, 1, curve: Curves.easeInOutCubic);
  static const Duration ANIMATION_LENGTH = const Duration(milliseconds: 600);

  /* Harcoded values to replace with dynamic */
  int tabCount;
  List<String> tabNames;
  List<Widget> tabBodyContents;

  Widget bodyWidget;

  @override
  void initState() {
    super.initState();

    /* Initialize tabs */
    tabCount = widget.tabs.length;
    tabNames = List<String>(tabCount);
    tabBodyContents = List<Widget>(tabCount);
    for (int i = 0; i < tabCount; i++) {
      tabNames[i] = widget.tabs[i].name;
      tabBodyContents[i] = widget.tabs[i].bodyContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TabNavigationModel>(
        builder: (context, model, _) {
          return GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) => onHorizontalSwipe(details, model),
              onVerticalDragEnd: (DragEndDetails details) => onVerticalSwipe(details, model),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  FractionallySizedBox(
                    heightFactor: 0.9,
                    child: Container(color: StyleSheet.WHITE),
                  ),
                  Column(children: <Widget>[
                    _header(),
                    _bodyWidgets(model.currentTab, model.previousTab)
                  ]),
                ],
              ));
        },
      ),
    );
  }

  /* Getter for the header segment of the sheet */
  Widget _header() {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(  // Rounded edges
          decoration: BoxDecoration(
            color: StyleSheet.WHITE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
              topRight: Radius.circular(_SHEET_BORDER_RADIUS)
            ),
          ),
          height: _SHEET_BORDER_RADIUS + _NAVIGATION_SPACING,
        ),
        Positioned.fill(  // Navigation
          top: _SHEET_BORDER_RADIUS - TabIndicator.NAVIGATION_TEXT_SIZE * 2.75,
          child: _navigation),
      ],
    );
  }

  /* Getter for the tab navigation of the sheet */
  Widget get _navigation {

    List<TabIndicator> tabs = List<TabIndicator>(tabCount);
    for(int i = 0; i < tabCount; i++) {
      tabs[i] = TabIndicator(name: tabNames[i], index: i);
    }

    return _NavigationBar(tabs);
  }

  Widget _bodyWidgets(int tab, int previousTab) {
    return Expanded(
      flex: tabBodyContents[tab] != null ? 1 : 0, // Only flex if there are any contents
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: ANIMATION_LENGTH,
            switchInCurve: BODY_CURVE,
            switchOutCurve: BODY_CURVE,
            transitionBuilder: (child, animation) {
              double start = previousTab > tab ? 1 : -1;
              Animation<Offset> offsetAnimation =
                  Tween<Offset>(begin: Offset(start, 0), end: Offset(0, 0))
                      .animate(animation);
              if (animation.isDismissed) {
                offsetAnimation =
                    Tween<Offset>(begin: Offset(-start, 0), end: Offset(0, 0))
                        .animate(animation);
              }
              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: _SheetContents(contents: tabBodyContents, index: tab),
          )
        ],
      ),
    );
  }

  void onHorizontalSwipe(DragEndDetails details, TabNavigationModel model) {
    if (details.primaryVelocity < 0) {
      model.currentTab++;
    } else if (details.primaryVelocity > 0) {
      model.currentTab--;
    }
  }

  void onVerticalSwipe(DragEndDetails details, TabNavigationModel model) {
    /* Check, don't allow user to expand sheet if tab does not allow it */
    if (!widget.tabs[model.currentTab].canExpandSheet) {
      return;
    }

    if (details.primaryVelocity > 0) {
      model.expandSheet = false;
    } else if (details.primaryVelocity < 0) {
      model.expandSheet = true;
    }
  }
}

class _SheetContents extends StatelessWidget {

  final List<Widget> contents;
  final int index;

  _SheetContents({@required this.contents, @required this.index})
      : super(key: ValueKey<int>(index));

  @override
  Widget build(BuildContext context) =>
      Container(alignment: Alignment.topLeft, child: contents[index]);
}

class _NavigationBar extends StatefulWidget {

  final List<TabIndicator> tabs;
  _NavigationBar(this.tabs);

  @override
  __NavigationBarState createState() => __NavigationBarState();
}

class __NavigationBarState extends State<_NavigationBar> {

  /* CONSTANTS */
  static const int MAX_TABS = 3;
  static const int CENTER = -1;
  static const int LEFT = 0;
  static const int RIGHT = 1;

  int tabCount;
  double tabSpacing;
  int leftEdgeIndex;
  int rightEdgeIndex;

  //List<List<double>> lrPairs;
  List<AnimatedPositioned> tabWidgets;

  @override
  void initState() { 
    super.initState();
    
    tabCount = widget.tabs.length;
    tabWidgets = List<AnimatedPositioned>(tabCount);
  }

  void calculateValues() {


    int adjustedTabCount = tabCount > MAX_TABS ? MAX_TABS : tabCount;
    tabSpacing = MediaQuery.of(context).size.width / (adjustedTabCount + 1);
  }

  void calculateEdgeValues(int currentTab) {

    /* Calculate left edge */
    leftEdgeIndex = currentTab - 1;
    if(currentTab == tabCount - 1) {
      leftEdgeIndex = currentTab - 2;
    }

    /* Calculate left edge */
    rightEdgeIndex = currentTab + 1;
    if(currentTab == 0) {
      rightEdgeIndex = currentTab + 2;
    }

    /* Adjust for overcompensation */
    if(leftEdgeIndex < 0) {
      leftEdgeIndex = 0;
    }

    if(rightEdgeIndex > tabCount - 1) {
      rightEdgeIndex = tabCount - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    calculateValues();
    return Consumer<TabNavigationModel>(
      builder: (context, model, _) {
        calculateEdgeValues(model.currentTab);
        for(int i = 0; i < tabCount; i++) {
          tabWidgets[i] = alignTab(widget.tabs[i]);
        }
        return Stack(children: tabWidgets, alignment: Alignment.topCenter);
      }
    );
  }

  AnimatedPositioned alignTab(TabIndicator tab) {

    double screenWidth = MediaQuery.of(context).size.width;

    int alignment;
    if(tab.index <= leftEdgeIndex) {
      alignment = LEFT;
    } else if(tab.index >= rightEdgeIndex) {
      alignment = RIGHT;
    } else {
      alignment = CENTER;
    }

    final double tabWidth = tab.name.length * TabIndicator.NAVIGATION_TEXT_SIZE;
    final double primary = calcPrimary(tab.index, alignment, tabWidth);
    final double secondary = screenWidth - primary - tabWidth;

    double left;
    double right; 
    switch(alignment) {
      case LEFT:
        left = primary;
        right = secondary;
        break;
      case RIGHT:
        left = secondary;
        right = primary;
        break;
      case CENTER:
        left = (screenWidth - tabWidth) / 2;
        right = (screenWidth - tabWidth) / 2;
        break;
    }

    return AnimatedPositioned(
      duration: _PageSheetState.ANIMATION_LENGTH,
      curve: _PageSheetState.BODY_CURVE,
      left: left,
      right: right,
      child: AnimatedOpacity(
        duration: _PageSheetState.ANIMATION_LENGTH,
        curve: _PageSheetState.BODY_CURVE,
        opacity: left < 0 || right < 0 ? 0 : 1,
        child: tab,
      ),
    );
  }

  double calcPrimary(int index, int alignment, double tabWidth) {

    int delta = CENTER;
    switch(alignment) {
      case LEFT:
        delta = index - leftEdgeIndex;
        break;
      case RIGHT:
        delta = index - rightEdgeIndex;
        break;
    }

    double spacing = tabSpacing * (delta + 1) - (tabWidth / 2);

    if(index < leftEdgeIndex) {
      spacing = -tabWidth;
    } else if(index > rightEdgeIndex) {
      spacing = -tabWidth;
    }

    return spacing;
  }
}

class TabIndicator extends StatefulWidget {
  static const double NAVIGATION_TEXT_SIZE = 13;

  final String name;
  final int index;

  TabIndicator({@required String name, @required int index})
      : name = name,
        index = index;

  @override
  _TabIndicatorState createState() => _TabIndicatorState();
}

class _TabIndicatorState extends State<TabIndicator> {
  /* Constants */
  static const double _POINT_ENABLED_SIZE = TabIndicator.NAVIGATION_TEXT_SIZE * (3 / 8);
  static const Duration _ANIM_DURATION = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {

    return Consumer<TabNavigationModel>(builder: (context, navigationModel, _) {
      bool enabled = navigationModel.currentTab == widget.index;
      double indicatorSize = enabled ? _POINT_ENABLED_SIZE : 0;

      return Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: <Widget>[
          Button(
            onPressed: () {
              navigationModel.currentTab = widget.index; // Try change the tab index
            },
            child: AnimatedOpacity(
              opacity: enabled ? 1 : 0.5,
              child: Text(
                widget.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: TabIndicator.NAVIGATION_TEXT_SIZE,
                  fontWeight: FontWeight.bold,
                  color: StyleSheet.DARK_GREY
                ),
              ),
              duration: _ANIM_DURATION,
              curve: Curves.easeInOut,
            ),
          ),
          Positioned(
            bottom: 8,
            child: AnimatedContainer(
              width: indicatorSize,
              height: indicatorSize,
              decoration: const BoxDecoration(
                color: StyleSheet.DARK_GREY, shape: BoxShape.circle),
                duration: _ANIM_DURATION,
                curve: Curves.easeInOut,
              ),
          ),
          ],
        );
      }
    );
  }
}
