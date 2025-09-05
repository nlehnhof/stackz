import 'package:flutter/foundation.dart';
import 'package:stackz/models/levels.dart';

class Shelf {
  final String id; // immutable
  String name;     // mutable
  int width;       // for visualization (x-axis)
  int depth;       // for visualization (y-axis)
  int posX;        // for visualization (x-axis position)
  int posY;        // for visualization (y-axis position)
  List<Levels> levels; // mutable

  Shelf({
    required this.id,
    required this.name,
    this.width = 3,
    this.depth = 1,
    this.posX = 0,
    this.posY = 0,
    List<Levels>? levels,
  }) : levels = levels ?? [];

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'] as String,
      name: json['name'] as String,
      width: json['width'] as int? ?? 3,
      depth: json['depth'] as int? ?? 1,
      posX: json['posX'] as int? ?? 0,
      posY: json['posY'] as int? ?? 0,
      levels: (json['levels'] as List<dynamic>?)
              ?.map((levelJson) => Levels.fromJson(levelJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'depth': depth,
      'posX': posX,
      'posY': posY,
      'levels': levels.map((level) => level.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Shelf &&
        other.id == id &&
        other.name == name &&
        other.width == width &&
        other.depth == depth &&
        other.posX == posX &&
        other.posY == posY &&
        listEquals(other.levels, levels);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        width.hashCode ^
        depth.hashCode ^
        posX.hashCode ^
        posY.hashCode ^
        levels.hashCode;
  }
}
