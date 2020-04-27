import 'dart:async';

import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {

  final String text;
  final TextStyle style;

  Marquee(this.text, {this.style});

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {

  ScrollController _scrollController;
  bool _forward;
  Timer _timer;

  @override
  void initState() {

    super.initState();

    _scrollController = ScrollController();
    _forward = true;
    _timer = Timer.periodic(Duration(seconds: 5),
      (Timer timer) {
        animate();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Transform.translate(
      offset: Offset(-5, 0),
      child: ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            stops: [0, 0.05, 0.95, 1],
            colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Container(width: 8),
              Text(widget.text, style: widget.style, maxLines: 1),
              Container(width: 8),
            ],
          )
        ),
      )
    );
  }

  void animate() {

    double offsetTarget;
    if(_forward) {
      offsetTarget = _scrollController.position.maxScrollExtent;
    } else  {
      offsetTarget = _scrollController.position.minScrollExtent;
    }

    _forward = !_forward;
    _scrollController.animateTo(offsetTarget, duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
}