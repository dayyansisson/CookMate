import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FadeImage extends StatelessWidget {

  final String url;
  FadeImage(this.url);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: CachedNetworkImageProvider(url),
      fit: BoxFit.cover,
      fadeInCurve: Curves.fastOutSlowIn,
    );
  }
}