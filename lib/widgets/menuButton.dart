import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Button(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    
    return Container(
      width: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(height: 2, color: StyleSheet.WHITE),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Container(height: 2, width: 10, color: StyleSheet.WHITE),
        ],
      ),
    );
  }
}