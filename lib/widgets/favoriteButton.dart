import 'package:CookMate/provider/recipeModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ButtonIcon extends StatelessWidget {

  final Icon data;
  _ButtonIcon(this.data) : super(key: ValueKey<Icon>(data));

  @override
  Widget build(BuildContext context) => data;
}

class FavoriteButton extends StatefulWidget {

  final _ButtonIcon disabledIcon;
  final _ButtonIcon enabledIcon;
  final double size;

  FavoriteButton({
    Icon disabledIcon = const Icon(
      Icons.favorite_border,
      color: StyleSheet.WHITE,
      size: 30,
    ),
    Icon enabledIcon = const Icon(
      Icons.favorite,
      color: StyleSheet.WHITE,
      size: 30,
    ),
    this.size = 30,
  }) : this.disabledIcon = _ButtonIcon(disabledIcon), this.enabledIcon = _ButtonIcon(enabledIcon);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {

  bool enabled;

  @override
  Widget build(BuildContext context) {

    return Consumer<RecipePageModel>(
      builder: (context, recipe, loadingPlaceholder) {
        enabled = recipe.isFavorite;
        if(enabled == null) {
          return loadingPlaceholder;
        }

        return Button(
          onPressed: () {
            setState(() {
              enabled = !enabled;
            });
            if(enabled) {
              recipe.favorite();
            } else {
              recipe.unfavorite();
            }
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  )
                );  
              },
              child: enabled ? widget.enabledIcon : widget.disabledIcon,
            )
          ),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        child: CircularProgressIndicator()
      )
    );
  }
}