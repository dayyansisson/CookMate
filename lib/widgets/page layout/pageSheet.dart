import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:CookMate/widgets/page%20layout/tabIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSheet extends StatefulWidget {

  final List<SheetTab> tabs;
  PageSheet(this.tabs);

  @override
  _PageSheetState createState() => _PageSheetState();
}

class _PageSheetState extends State<PageSheet> with TickerProviderStateMixin {

  /* Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const int _NAVIGATION_SPACING = 20;

  /* Harcoded values to replace with dynamic */
  int tabCount;
  List<String> tabNames;
  List<Widget> tabHeaderContents;
  List<Widget> tabBodyContents;

  Widget bodyWidget;

  @override
  void initState() { 
    
    super.initState();

    /* Initialize tabs */
    tabCount = widget.tabs.length;
    tabNames = List<String>(tabCount);
    tabHeaderContents = List<Widget>(tabCount);
    tabBodyContents = List<Widget>(tabCount);
    for(int i = 0; i < tabCount; i++) {
      tabNames[i] = widget.tabs[i].name;
      tabHeaderContents[i] = widget.tabs[i].headerContent;
      tabBodyContents[i] = widget.tabs[i].bodyContent;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Consumer<TabNavigationModel> (
        builder: (context, model, _) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) => onSwipe(details, model),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                FractionallySizedBox(     // Make sheet background white (underneath rounded edges) so that dynamically changing widgets don't show background
                  heightFactor: 0.9,
                  child: Container(color: StyleSheet.WHITE),
                ),
                Column(
                  children: <Widget> [
                    _header(model.currentTab),
                    _bodyWidgets(model.currentTab)
                  ]
                ),
              ],
            )
          );
        },
      ),
    );
  }

  /* Getter for the header segment of the sheet */
  Widget _header(int tab) {

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget> [
            Container(    // Rounded edges
              decoration: BoxDecoration(
                color: StyleSheet.WHITE,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
                  topRight: Radius.circular(_SHEET_BORDER_RADIUS)
                )
              ),
              height: _SHEET_BORDER_RADIUS + _NAVIGATION_SPACING,
            ),
            Container(    // Header contents
              color: StyleSheet.WHITE,
              child: AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.fastOutSlowIn,
                  switchOutCurve: Curves.fastOutSlowIn,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: _SheetContents(contents: tabHeaderContents, index: tab),
                )
              ),
            )
          ]
        ),
        Positioned.fill(  // Navigation
          top: _SHEET_BORDER_RADIUS - TabIndicator.NAVIGATION_TEXT_SIZE,
          child: _navigation
        ),
      ],
    );
  }

  /* Getter for the tab navigation of the sheet */
  Widget get _navigation {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
        Spacer(),
        TabIndicator(name: tabNames[0], index: 0),
        Spacer(flex: tabNames[0].length),
        TabIndicator(name: tabNames[1], index: 1),
        Spacer(flex: tabNames[1].length),
        TabIndicator(name: tabNames[2], index: 2),
        Spacer(),
        Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
      ],
    );
  }

  Widget _bodyWidgets(int tab) {

    return Expanded(
      flex: tabBodyContents[tab] != null ? 1 : 0, // Only flex if there are any contents
      child: Stack(
        children: <Widget>[
          Container(decoration: BoxDecoration(gradient: widget.tabs[tab].bodyGradient)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.fastOutSlowIn,
            switchOutCurve: Curves.easeInOutSine,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                alignment: Alignment.centerLeft,
                scale: animation,
                child: child,
              );
            },
            child: _SheetContents(contents: tabBodyContents, index: tab),
          )
        ],
      ),
    );
  }

  void onSwipe(DragEndDetails details, TabNavigationModel model) {

    if(details.primaryVelocity < 0) {
      model.currentTab++;
    } else if(details.primaryVelocity > 0) {
      model.currentTab--;
    }
  }
}

class _SheetContents extends StatelessWidget {

  final List<Widget> contents;
  final int index;

  _SheetContents({@required this.contents, @required this.index}) : super(key: ValueKey<int>(index));

  @override
  Widget build(BuildContext context) => contents[index];
}