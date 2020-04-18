import 'dart:ui';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  final String _imageURL;
  Background(this._imageURL) : super(key: ValueKey<String>(_imageURL));

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imageURL),
          colorFilter: ColorFilter.mode(Colors.black87, BlendMode.overlay),
          fit: BoxFit.fitHeight
        )
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}