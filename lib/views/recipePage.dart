import 'dart:ui';
import 'package:CookMate/controllers/ShoppingListController.dart';
import 'package:CookMate/provider/recipeModel.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/favoriteButton.dart';
import 'package:CookMate/widgets/pageLayout/recipeSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: StyleSheet.WHITE,
      body: Consumer<RecipeModel>(
        builder: (context, recipe, loadingScreen) {
          if (recipe.isReadyForDisplay) {
            return buildPage(recipe);
          }
          recipe.loadRecipeForDisplay();
          return loadingScreen;
        },
        child: Container(
          color: StyleSheet.WHITE,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildPage(RecipeModel model) {
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
                    image: CachedNetworkImageProvider(model.imageURL),
                    fit: BoxFit.cover)),
          ),
        ),
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            ChangeNotifierProvider(
                create: (_) =>
                    TabNavigationModel(tabCount: 2, expandSheet: true),
                child: RecipeSheet()),
            Padding(
              // Top Bar
              padding: const EdgeInsets.only(
                  top: _TOP_BAR_EDGE_PADDING,
                  right: _TOP_BAR_EDGE_PADDING,
                  left: _TOP_BAR_EDGE_PADDING),
              child: Container(
                height: 40,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      roundedBackground([
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Button(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "BACK",
                              style: TextStyle(
                                  color: StyleSheet.WHITE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _PAGE_NAME_FONT_SIZE),
                            ),
                          ),
                        ),
                      ]),
                      Spacer(),
                      roundedBackground([
                        ShoppingBagIcon(() => ShoppingListController()
                            .addRecipeToShoppingList(model.recipe)),
                        FavoriteButton()
                      ]),
                    ]),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget roundedBackground(List<Widget> widgets) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 100,
            alignment: Alignment.center,
            color: StyleSheet.DEEP_GREY.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widgets,
              ),
            ),
          )),
    );
  }
}

class ShoppingBagIcon extends StatefulWidget {
  final Function onTap;
  ShoppingBagIcon(this.onTap);

  @override
  _ShoppingBagIconState createState() => _ShoppingBagIconState();
}

class _ShoppingBagIconState extends State<ShoppingBagIcon>
    with TickerProviderStateMixin {
  /* Constants */
  static const double DEFAULT_SIZE = 24;

  AnimationController controller;
  Animation<double> bounceAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  void bounce() {
    bounceAnimation = Tween<double>(begin: DEFAULT_SIZE, end: DEFAULT_SIZE / 2)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
          ..addListener(() => setState(() {}));

    controller
        .forward(from: controller.value)
        .whenComplete(() => controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        widget.onTap();
        bounce();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Container(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  CookMateIcon.bag_icon,
                  color: StyleSheet.WHITE,
                  size: bounceAnimation != null
                      ? bounceAnimation.value
                      : DEFAULT_SIZE,
                ),
                Container(width: 20),
                Text(
                  "Added ingredients to shopping list",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        ));
      },
      child: Icon(
        CookMateIcon.bag_icon,
        color: StyleSheet.WHITE,
        size: bounceAnimation != null ? bounceAnimation.value : DEFAULT_SIZE,
      ),
    );
  }
}
