import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/background.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  /* Members */
  final String name;
  final PageSheet pageSheet;
  final String title;
  final String subtitle;

  /* Constructor */
  MainPage({
    @required this.name, 
    @required this.pageSheet,
    this.title,
    this.subtitle
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  /* Constants */
  static const double _TITLE_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;
  static const String _backupImageURL = "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/cranberry-orange-cornbread.jpg";

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => TabNavigationModel(tabCount: widget.pageSheet.tabs.length),
      child: Stack(
        children: <Widget>[
          Background(_backupImageURL),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.name.toUpperCase(),
                      style: TextStyle(
                        color: StyleSheet.WHITE,
                        fontWeight: FontWeight.bold,
                        fontSize: _TITLE_FONT_SIZE
                      ),
                    ),
                    Spacer(),
                    snackbar,
                  ]
                ),
              ),
              AnimatedSize(
                vsync: this,
                alignment: Alignment.topLeft,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                child: Consumer<TabNavigationModel> (
                  builder: (context, model, _) { 
                    String text = widget.pageSheet.tabs[model.currentTab].title;
                    text = text != null ? text : widget.title;
                    return text != null ? Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        right: _TOP_BAR_EDGE_PADDING,
                        left: _TOP_BAR_EDGE_PADDING,
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: StyleSheet.WHITE,
                          fontSize: 40,
                          fontFamily: 'Hoefler'
                        ),
                      )
                    ) : Container();
                  },
                ),
              ),
              AnimatedSize(
                vsync: this,
                alignment: Alignment.topLeft,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                child: Consumer<TabNavigationModel> (
                  builder: (context, model, _) { 
                    String text = widget.pageSheet.tabs[model.currentTab].subtitle;
                    text = text != null ? text : widget.subtitle;
                    return text != null ? Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        right: _TOP_BAR_EDGE_PADDING,
                        left: _TOP_BAR_EDGE_PADDING,
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: StyleSheet.WHITE,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    )  : Container();
                  }
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 30)),
              widget.pageSheet,
            ],
          )
        ],
      )
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