import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/menuButton.dart';
import 'package:CookMate/widgets/pageLayout/background.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  /* Members */
  final String name;
  final String backgroundImage;
  final PageSheet pageSheet;
  final String header;
  final String subheader;

  /* Constructor */
  MainPage({
    @required this.name,
    @required this.backgroundImage,
    @required this.pageSheet,
    this.header,
    this.subheader
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

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (_) => TabNavigationModel(tabCount: widget.pageSheet.tabs.length),
        child: Stack(
          children: <Widget>[
            Consumer<TabNavigationModel>(
              // Background
              builder: (context, model, _) {
                String url = widget.pageSheet.tabs[model.currentTab].backgroundImage;
                url ??= widget.backgroundImage;
                
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: _TITLE_SWITCH_DURATION),
                    switchInCurve: Curves.fastOutSlowIn,
                    switchOutCurve: Curves.fastOutSlowIn,
                    child: Background(url));
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // Top Bar
                  padding: const EdgeInsets.only(
                    top: _TOP_BAR_EDGE_PADDING / 3,
                    right: _TOP_BAR_EDGE_PADDING / 2,
                    left: _TOP_BAR_EDGE_PADDING),
                  child: Row(children: <Widget>[
                    Text(
                      widget.name.toUpperCase(),
                      style: TextStyle(
                          color: StyleSheet.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: _PAGE_NAME_FONT_SIZE),
                    ),
                    Spacer(),
                    MenuButton(),
                  ]),
                ),
                Consumer<TabNavigationModel>( // Titles
                  builder: (context, model, _) => Column(children: <Widget>[
                    titleBuilder(context, model, padding: MainPage.TITLE_FONT_SIZE),
                    titleBuilder(context, model, subtitle: true, padding: 24)
                ])),
                Padding(padding: const EdgeInsets.only(top: 24)),
                Consumer<TabNavigationModel>( // Search bar
                  builder: (context, model, _) { 
                    if(widget.pageSheet.tabs[model.currentTab].searchBar == null) {
                      return Container();
                    }
                    return Column(
                      children: <Widget>[
                        widget.pageSheet.tabs[model.currentTab].searchBar,
                        Padding(padding: const EdgeInsets.only(top: 24)),
                      ]
                    );
                  }
                ),
                widget.pageSheet,
              ],
            )
          ],
        )
      );
  }

  bool _didExceedOneLine(int textLength, double textSize, double padding) => MediaQuery.of(context).size.width < (textLength * textSize) + (padding * 2);

  Widget titleBuilder(BuildContext context, TabNavigationModel model, { @required double padding, bool subtitle = false }) {

    String text = subtitle ? widget.pageSheet.tabs[model.currentTab].subheader : widget.pageSheet.tabs[model.currentTab].header;
    if (model.expandSheet) {
      text = "";
    } else if (text == null) {
      text = "";
      if (widget.header != null) {
        text = widget.header;
      }
    }
    final double fontSize = subtitle ? MainPage.SUBTITLE_FONT_SIZE * MainPage.SUBTITLE_LINE_HEIGHT : MainPage.TITLE_FONT_SIZE;
    final int numberOfLines = _didExceedOneLine(text.length, MainPage.SUBTITLE_FONT_SIZE, _TOP_BAR_EDGE_PADDING) ? 2 : 1;
    final double widgetHeight = (fontSize * numberOfLines) + padding;

    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      height: text == "" ? 0 : widgetHeight,
      child: Padding(
          padding: EdgeInsets.only(
            top: padding,
            right: _TOP_BAR_EDGE_PADDING,
            left: _TOP_BAR_EDGE_PADDING,
          ),
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: _TITLE_SWITCH_DURATION),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (child, animation) {
                
                double direction = model.previousTab < model.currentTab ? -1 : 1;
                if(animation.isDismissed) {
                  direction *= -1;
                }
                Animation<Offset> slide = Tween<Offset>(begin: Offset(direction, 0), end: Offset(0, 0)).animate(animation);

                return SlideTransition(
                    position: slide,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    )
                  );
              },
              child: _HeaderTitle(
                text: text,
                subtitle: subtitle,
              ))),
    );
  }

}

class _HeaderTitle extends StatelessWidget {
  final String text;
  final bool subtitle;

  _HeaderTitle({@required this.text, this.subtitle = false})
      : super(key: ValueKey<String>(text));

  @override
  Widget build(BuildContext context) {
    if (subtitle) {
      return Container(
      alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
              color: StyleSheet.WHITE,
              fontSize: MainPage.SUBTITLE_FONT_SIZE,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              height: MainPage.SUBTITLE_LINE_HEIGHT),
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
