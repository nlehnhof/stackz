import 'package:stackz/models/shelf.dart';
import 'package:flutter/foundation.dart';

class Room {
  final String id;          // immutable
  String name;              // mutable
  List<Shelf> shelves;      // mutable

  Room({
    required this.id,
    required this.name,
    required this.shelves,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      shelves: (json['shelves'] as List<dynamic>)
          .map((shelfJson) => Shelf.fromJson(shelfJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shelves': shelves.map((shelf) => shelf.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.id == id &&
        other.name == name &&
        listEquals(other.shelves, shelves);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ shelves.hashCode;
  }
}