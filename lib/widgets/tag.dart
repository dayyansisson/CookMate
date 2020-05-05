import 'package:CookMate/entities/query.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {

  static const double DEFAULT_SIZE = 18;

  final Query query;
  final String content;

  final double size;
  final double borderWidth;
  final Color color;

  final Function onPressed;

  Tag({ this.content = "", 
        this.size = DEFAULT_SIZE,
        this.borderWidth = 0.075,
        this.color = StyleSheet.WHITE,
        this.query,
        this.onPressed
      }
    );

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {

  @override
  Widget build(BuildContext context) {

    bool hasQuery = widget.query != null;

    String text = hasQuery ? widget.query.ingredient : widget.content;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Button(
          onPressed: widget.onPressed,
          child: Container(
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
                  text.toLowerCase(),
                  style: TextStyle(
                    color: StyleSheet.WHITE,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ),
        ),
        hasQuery ? Positioned(
          height: 22,
          right: -8,
          top: -8,
          child: SizedBox(
            width: 22,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: FittedBox(
                  child: Text(
                    widget.query.resultCount.toString(),
                    style: TextStyle(
                      color: StyleSheet.WHITE,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) : Container(),
      ],
    );
  }
}