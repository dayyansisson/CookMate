import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/background.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  /* Members */
  final String name;
  final String backgroundImage;
  final PageSheet pageSheet;
  final String title;
  final String subtitle;

  /* Constructor */
  MainPage({
    @required this.name,
    @required this.backgroundImage,
    @required this.pageSheet,
    this.title,
    this.subtitle
  });

  /* Constants */
  static const double TITLE_FONT_SIZE = 36;
  static const double SUBTITLE_FONT_SIZE = TITLE_FONT_SIZE / 2;
  static const double SUBTITLE_LINE_HEIGHT = 1.1;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  /* Animation Constants */
  static const int _TITLE_SWITCH_DURATION = 650;
  static const Curve _TITLE_CURVE = const Interval(0.5, 1, curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => TabNavigationModel(tabCount: widget.pageSheet.tabs.length),
      child: Stack(
        children: <Widget>[
          Consumer<TabNavigationModel> (  // Background
            builder: (context, model, _) { 
              String url = widget.pageSheet.tabs[model.currentTab].backgroundImage;
              if(url == null) {
                url = widget.backgroundImage;
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: _TITLE_SWITCH_DURATION),
                switchInCurve: Curves.fastOutSlowIn,
                switchOutCurve: Curves.fastOutSlowIn,
                child: Background(url)
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(  // Top Bar
                padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.name.toUpperCase(),
                      style: TextStyle(
                        color: StyleSheet.WHITE,
                        fontWeight: FontWeight.bold,
                        fontSize: _PAGE_NAME_FONT_SIZE
                      ),
                    ),
                    Spacer(),
                    snackbar,
                  ]
                ),
              ),
              Consumer<TabNavigationModel> (  // Titles
                builder: (context, model, _) => Column(
                  children: <Widget> [
                    titleBuilder(context, model, padding: MainPage.TITLE_FONT_SIZE),
                    titleBuilder(context, model, subtitle: true, padding: 24)
                  ]
                )
              ),
              Padding(padding: const EdgeInsets.only(top: 24)),
              widget.pageSheet,
            ],
          )
        ],
      )
    );
  }

  Widget titleBuilder(BuildContext context, TabNavigationModel model, {@required double padding, bool subtitle = false}) {

    final double fontSize = subtitle ? MainPage.SUBTITLE_FONT_SIZE * MainPage.SUBTITLE_LINE_HEIGHT : MainPage.TITLE_FONT_SIZE;
    final double widgetHeight = (fontSize * 2) + padding;
    String text = subtitle ? widget.pageSheet.tabs[model.currentTab].subtitle : widget.pageSheet.tabs[model.currentTab].title;
    if(model.expandSheet) {
      text = "";
    } else if(text == null) {
      text = "";
      if(widget.title != null) {
        text = widget.title;
      }
    }

    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      constraints: BoxConstraints(maxHeight: text == "" ? 0 : widgetHeight),
      child: Padding(
        padding: EdgeInsets.only(
          top: padding,
          right: _TOP_BAR_EDGE_PADDING,
          left: _TOP_BAR_EDGE_PADDING,
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: _TITLE_SWITCH_DURATION),
          switchInCurve: _TITLE_CURVE,
          switchOutCurve: _TITLE_CURVE,
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: animation,
                child: child,
              )
            );
          },
          child: _HeaderTitle(text: text, subtitle: subtitle,)
        )
      ),
    );
  }

  // TODO: Replace with actual Menu widget
  Widget get snackbar {
    return Container(
      width: 16,
      child: Column(
        children: <Widget>[
          Container(height: 2, color: StyleSheet.WHITE),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Container(height: 2, color: StyleSheet.WHITE),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {

  final String text;
  final bool subtitle;

  _HeaderTitle({@required this.text, this.subtitle = false}) : super(key: ValueKey<String>(text));

  @override
  Widget build(BuildContext context) {

    if(subtitle) {
      return Text(
        text,
        style: TextStyle(
          color: StyleSheet.WHITE,
          fontSize: MainPage.SUBTITLE_FONT_SIZE,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          height: MainPage.SUBTITLE_LINE_HEIGHT
        ),
      );
    }

    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          color: StyleSheet.WHITE,
          fontSize: MainPage.TITLE_FONT_SIZE,
          fontFamily: 'Hoefler',
        ),
      ),
    );
  }
}