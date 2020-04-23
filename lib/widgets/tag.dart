import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {

  static const double DEFAULT_SIZE = 18;

  final String content;

  final double size;
  final double borderWidth;
  final Color color;

  Tag(this.content, 
      { this.size = DEFAULT_SIZE,
        this.borderWidth = 0.075,
        this.color = StyleSheet.WHITE
      }
    );

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.size * 2,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        border: Border.all(
          color: widget.color.withOpacity(0.75),
          width: widget.size * widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.size)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.size / 2,
          vertical: widget.size * (2/5)
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            widget.content.toLowerCase(),
            style: TextStyle(
              color: StyleSheet.WHITE,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}