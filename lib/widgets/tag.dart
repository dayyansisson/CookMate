import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
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
    @required this.content,
    this.size = DEFAULT_SIZE,
    this.borderWidth = 0.075,
    this.horizontalPadding = 0,
    this.color = StyleSheet.WHITE,
    this.textColor = StyleSheet.WHITE,
    this.onPressed,
    this.pop = false,
    this.withCancelIcon = false,
    this.popCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Button(
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                  return;
                }
                if (pop) {
                  if (popCallback != null) {
                    popCallback();
                  }
                }
              },
              child: Transform.scale(
                scale: 1,
                child: Container(
                  height: size * 2,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      border: Border.all(
                        color: color.withOpacity(0.75),
                        width: size * borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(size)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size / 2, vertical: size * (2 / 5)),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        content.toLowerCase(),
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            withCancelIcon
                ? Positioned(
                    height: 22,
                    right: -3,
                    top: -3,
                    child: SizedBox(
                      width: 22,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FittedBox(
                            child: Icon(
                              Icons.clear,
                              color: StyleSheet.WHITE,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
