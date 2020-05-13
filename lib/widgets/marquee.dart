import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {

  final String text;
  final TextStyle style;

  Marquee(this.text, {this.style});

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {

  double _spacing;
  double _fading;

  ScrollController _scrollController;
  bool _forward;

  @override
  void initState() {

    super.initState();

    _scrollController = ScrollController();
    _forward = true;
    Timer.periodic(Duration(seconds: 5),
      (Timer timer) {
        animate();
      }
    );

    _spacing = sqrt(widget.style.fontSize);
    _fading = _spacing/140;
  }

  @override
  Widget build(BuildContext context) {

    return Transform.translate(
      offset: Offset(-_spacing, 0),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            stops: [0, _fading, 1 - _fading, 1],
            colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Container(width: _spacing),
              Text(widget.text, style: widget.style, maxLines: 1),
              Container(width: _spacing),
            ],
          )
        ),
      )
    );
  }

  void animate() {

    if(!_scrollController.hasClients) {
      return;
    }

    double offsetTarget;
    if(_forward) {
      offsetTarget = _scrollController.position.maxScrollExtent;
    } else  {
      offsetTarget = _scrollController.position.minScrollExtent;
    }

    _forward = !_forward;
    _scrollController.animateTo(offsetTarget, duration: Duration(seconds: widget.text.length ~/ 10), curve: Curves.easeInOut);
  }
}