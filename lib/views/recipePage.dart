import 'dart:ui';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/recipeSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {

  final Recipe recipe;
  final Future<Recipe> futureRecipe;

  RecipePage({this.recipe, this.futureRecipe});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  Recipe recipe;

  @override
  void initState() { 
    super.initState();

    recipe = widget.recipe;
    initRecipe();
  }

  void initRecipe() async {
    
    widget.futureRecipe.then(
      // Load in all futures
      (futureRecipe) async {
        List<Future> preloads = [
          futureRecipe.getIngredients(),
          futureRecipe.getSteps(),
          futureRecipe.getTags(),
          futureRecipe.isFavorite()
        ];
        await Future.wait(preloads);
        setState(() {
          recipe = futureRecipe;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    if(recipe != null) {
      return buildRecipe(context);
    }

    return Container(
      color: StyleSheet.WHITE,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget buildRecipe(BuildContext context) {

    return Stack(
      children: <Widget>[
         ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(0, -0.75),
              colors: [Colors.black26, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.hardLight,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(recipe.image),
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.softLight),
                fit: BoxFit.cover
              )
            ),
          ),
        ),
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Padding(  // Top Bar
              padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING - 20, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
              child: Container(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Button(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "BACK",
                        style: TextStyle(
                          color: StyleSheet.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: _PAGE_NAME_FONT_SIZE
                        ),
                      ),
                    ),
                    Spacer(),
                    _TopBarToggle(
                      initialValue: recipe.favorite,
                      disabledIcon: _TopBarIcon(
                        icon: Icons.favorite_border,
                        color: StyleSheet.WHITE,
                        size: 30,
                      ),
                      enabledIcon: _TopBarIcon(
                        icon: Icons.favorite,
                        color: StyleSheet.WHITE,
                        size: 30,
                      ),
                      size: 30,
                      onTap: (bool value) async {
                        if(value) {
                          recipe.addToFavorites();
                        } else {
                          recipe.removeFromFavorites();
                        }
                      },
                    ),
                  ]
                ),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => TabNavigationModel(tabCount: 2, expandSheet: true),
              child: RecipeSheet(recipe)
            )
          ],
        )
      ],
    );
  }
}

class _TopBarIcon extends StatelessWidget {

  final IconData icon;
  final Color color;
  final double size;

  _TopBarIcon({
    @required this.icon, 
    @required this.color, 
    @required this.size,
  }) : super(key: ValueKey<List<dynamic>>([icon, color, size]));

  @override
  Widget build(BuildContext context) => Icon(icon, color: color, size: size);
}


class _TopBarToggle extends StatefulWidget {

  final _TopBarIcon disabledIcon;
  final _TopBarIcon enabledIcon;
  final double size;

  final bool initialValue;
  final Function(bool) onTap;

  _TopBarToggle({
    @required this.initialValue,
    @required this.disabledIcon,
    @required this.enabledIcon,
    @required this.size,
    @required this.onTap
  });

  @override
  __TopBarToggleState createState() => __TopBarToggleState();
}

class __TopBarToggleState extends State<_TopBarToggle> {

  bool enabled;

  @override
  void initState() { 
    super.initState();
    enabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {

    return Button(
      onPressed: () {
        setState(() {
          enabled = !enabled;
          widget.onTap(enabled);
        });
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
  }
}