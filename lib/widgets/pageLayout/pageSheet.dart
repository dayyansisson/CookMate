import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSheet extends StatefulWidget {
  final List<SheetTab> tabs;
  PageSheet(this.tabs);

  @override
  _PageSheetState createState() => _PageSheetState();
}

class _PageSheetState extends State<PageSheet> with TickerProviderStateMixin {
  /* Layout Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const int _NAVIGATION_SPACING = 20;

  /* Animation Constants */
  static const Curve _BODY_CURVE =
      const Interval(0, 1, curve: Curves.easeInOutCubic);

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
              onHorizontalDragEnd: (DragEndDetails details) =>
                  onHorizontalSwipe(details, model),
              onVerticalDragEnd: (DragEndDetails details) =>
                  onVerticalSwipe(details, model),
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
        Container(
          // Rounded edges
          decoration: BoxDecoration(
              color: StyleSheet.WHITE,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
                  topRight: Radius.circular(_SHEET_BORDER_RADIUS))),
          height: _SHEET_BORDER_RADIUS + _NAVIGATION_SPACING,
        ),
        Positioned.fill(
            // Navigation
            top: _SHEET_BORDER_RADIUS - TabIndicator.NAVIGATION_TEXT_SIZE,
            child: _navigation),
      ],
    );
  }

  /* Getter for the tab navigation of the sheet */
  Widget get _navigation {

    // List<Widget> _navigationWidgets = List<Widget>();
    // _navigationWidgets.add(Padding(padding: EdgeInsets.symmetric(horizontal: 15)));
    // for (int i = 0; i < tabCount; i++) {
    //   _navigationWidgets.add(TabIndicator(name: tabNames[i], index: i));
    // }
    // _navigationWidgets.add(Padding(padding: EdgeInsets.symmetric(horizontal: 15)));

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: _navigationWidgets
    // );

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
            duration: const Duration(milliseconds: 600),
            switchInCurve: _BODY_CURVE,
            switchOutCurve: _BODY_CURVE,
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

enum _RelativeAlignment { FromLeft, FromRight, Center }

class __NavigationBarState extends State<_NavigationBar> {

  /* CONSTANTS */
  static const int MAX_TABS = 3;
  static const Duration ANIMATION_LENGTH = const Duration(milliseconds: 200);

  int tabCount;
  double tabSpacing;
  int leftEdgeIndex;
  int rightEdgeIndex;

  void calculateValues() {

    tabCount = widget.tabs.length;

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
        List<Widget> tabs = List<Widget>(tabCount);
        for(int i = 0; i < tabCount; i++) {
          tabs[i] = tabDisplay(widget.tabs[i]);
        }

        return Stack(children: tabs, alignment: Alignment.topCenter);
      }
    );
  }

  Widget tabDisplay(TabIndicator tab) {

    _RelativeAlignment alignment;
    if(tab.index <= leftEdgeIndex) {
      alignment = _RelativeAlignment.FromLeft;
    } else if(tab.index >= rightEdgeIndex) {
      alignment = _RelativeAlignment.FromRight;
    } else {
      alignment = _RelativeAlignment.Center;
    }

    Widget tabWidget;
    double offset = calculatePosition(tab, alignment);
    switch(alignment) {
      case _RelativeAlignment.FromLeft:
        tabWidget = Positioned(
          left: offset,
          child: tab,
        );
        break;
      case _RelativeAlignment.FromRight:
        tabWidget = Positioned(
          right: offset,
          child: tab,
        );
        break;
      case _RelativeAlignment.Center:
        tabWidget = Positioned(
          child: tab,
        );
        break;
    }

    return tabWidget;
  }

  double calculatePosition(TabIndicator tab, _RelativeAlignment alignment) {

    int delta;
    switch(alignment) {
      case _RelativeAlignment.FromLeft:
        delta = tab.index - leftEdgeIndex;
        break;
      case _RelativeAlignment.FromRight:
        delta = tab.index - rightEdgeIndex;
        break;
      default:
        delta = 0;
        break;
    }

    double tabWidth = tab.name.length * TabIndicator.NAVIGATION_TEXT_SIZE;
    double spacing = tabSpacing * (delta + 1) - (tabWidth / 2);

    if(tab.index < leftEdgeIndex) {
      spacing = -tabWidth;
    } else if(tab.index > rightEdgeIndex) {
      spacing = -tabWidth;
    }

    return spacing;
  }
}

class TabIndicator extends StatefulWidget {
  static const double NAVIGATION_TEXT_SIZE = 13.5;

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

      return Button(
        splashColor: StyleSheet.TRANSPARENT,
        onPressed: () {
          navigationModel.currentTab = widget.index; // Try change the tab index
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedOpacity(
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
            Padding(padding: EdgeInsets.symmetric(vertical: 1)),
            AnimatedContainer(
              width: indicatorSize,
              height: indicatorSize,
              decoration: const BoxDecoration(
                color: StyleSheet.DARK_GREY, shape: BoxShape.circle),
                duration: _ANIM_DURATION,
                curve: Curves.easeInOut,
              ),
            ],
          ),
        );
      }
    );
  }
}
