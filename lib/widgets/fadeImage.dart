import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FadeImage extends StatelessWidget {

  final String url;
  FadeImage(this.url);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImage(url),
      fit: BoxFit.cover,
      fadeInCurve: Curves.fastOutSlowIn,
    );
  }
}