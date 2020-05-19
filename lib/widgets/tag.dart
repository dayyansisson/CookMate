import 'package:CookMate/entities/query.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {

  static const double DEFAULT_SIZE = 18;

  final String content;
  final bool withCancelIcon;

  final double size;
  final double borderWidth;
  final double horizontalPadding;
  final Color color;
  final Color textColor;

  final Function onPressed;
  final bool pop;
  final Function popCallback;

  Tag({ 
    this.content = "", 
    this.size = DEFAULT_SIZE,
    this.borderWidth = 0.075,
    this.horizontalPadding = 0,
    this.color = StyleSheet.WHITE,
    this.textColor = StyleSheet.WHITE,
    this.onPressed,
    this.pop = false,
    this.withCancelIcon = false,
    this.popCallback
  });

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {

  double scale;

  @override
  void initState() { 
    super.initState();
     scale = 1; // TODO animate scale
  }

  @override
  Widget build(BuildContext context) {

    String text = widget.content;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Button(
              onPressed: () { 
                if(widget.onPressed != null) {
                  widget.onPressed();
                  return;
                }
                if(widget.pop) {
                  setState(() {
                    // scale
                    if(widget.popCallback != null) {
                      widget.popCallback();
                    }
                  });
                }
              },
              child: Transform.scale(
                scale: scale,
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
                          color: widget.textColor,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            widget.withCancelIcon ? Positioned(
              height: 22,
              right: -3,
              top: -3,
              child: SizedBox(
                width: 22,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                      child: Icon(Icons.clear, color: StyleSheet.WHITE,),
                    ),
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}