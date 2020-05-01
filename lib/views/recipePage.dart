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
      (futureRecipe) {
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
                      enabled: recipe.isFavorite(),
                      onTap: () async {
                        bool favorited = await recipe.isFavorite();
                        if(favorited) {
                          recipe.removeFromFavorites();
                        } else {
                          recipe.addToFavorites();
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

class _TopBarToggle extends StatelessWidget {

  final _TopBarIcon disabledIcon;
  final _TopBarIcon enabledIcon;
  final double size;

  final Future<bool> enabled;
  final Function onTap;

  _TopBarToggle({
    @required this.disabledIcon,
    @required this.enabledIcon,
    @required this.size,
    @required this.onTap,
    this.enabled
  });

  @override
  Widget build(BuildContext context) {

    return Button(
      onPressed: onTap,
      child: Container(
        width: size,
        height: size,
        child: FutureBuilder<bool>(
          future: enabled,
          builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if(!snapshot.hasData) {
              print('error');
              return Container();
            }

            return AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: snapshot.data ? enabledIcon : disabledIcon,
            );
          },
        )
      ),
    );
  }
}