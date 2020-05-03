// An abstract base entity class that provides the methods to convert from sqlite data into an object.

abstract class Entity {
  int id;

  static fromMap() {}

  toMap() {}
}
