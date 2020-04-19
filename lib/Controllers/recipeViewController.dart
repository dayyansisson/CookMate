class RecipeViewController {

  /* Constants */
  static int INGREDIENTS_TAB = 0;
  static int DIRECTIONS_TAB = 0;

  /* Constructors */
  static final RecipeViewController _controller = RecipeViewController._internal();
  factory RecipeViewController() =>_controller;
  RecipeViewController._internal() : currentTab = 0;

  int currentTab;
}