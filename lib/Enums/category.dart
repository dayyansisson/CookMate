/* 
An enum for recipe category options
each enum has an index as a value, it starts at 0
ex: none: 0, appetizers: 1, ... , desserts: 6
*/
enum Category {
  none,
  appetizers,
  beverages,
  breakfast,
  lunch,
  dinner,
  desserts,
}

// returns the string value for db lookup
String catToString(Category cat) {
  return cat.toString().split('.').last;
}
