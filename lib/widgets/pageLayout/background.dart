import 'dart:ui';

import 'package:CookMate/util/styleSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          image: CachedNetworkImageProvider(_imageURL),
          colorFilter: ColorFilter.mode(StyleSheet.BLACK.withOpacity(0.65), BlendMode.overlay),
          fit: BoxFit.fitHeight
        )
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}