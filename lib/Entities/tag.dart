import 'package:CookMate/Entities/entity.dart';

/*
  This file lays out the tag class. 
*/

class Tag extends Entity {
  static String table = 'tag';

  // Properties
  int id;
  String title;

  // Tag Constructor
  Tag({
    this.id,
    this.title,
  });

  // Returns a JSON version
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Returns an object
  static Tag fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      title: map['title'],
    );
  }
}
