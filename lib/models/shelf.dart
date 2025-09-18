import 'package:stackz/models/levels.dart';

class Shelf {
  final String id;
  String name;
  int width;
  int depth;
  int posX;
  int posY;
  List<Levels> levels;

  Shelf({
    required this.id,
    required this.name,
    this.width = 3,
    this.depth = 1,
    this.posX = 0,
    this.posY = 0,
    List<Levels>? levels,
  }) : levels = levels ?? []; // ✅ never null

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'] as String,
      name: json['name'] as String,
      width: json['width'] is int ? json['width'] as int : int.tryParse(json['width'].toString()) ?? 3,
      depth: json['depth'] is int ? json['depth'] as int : int.tryParse(json['depth'].toString()) ?? 1,
      posX: json['posX'] is int ? json['posX'] as int : int.tryParse(json['posX'].toString()) ?? 0,
      posY: json['posY'] is int ? json['posY'] as int : int.tryParse(json['posY'].toString()) ?? 0,
      levels: (json['levels'] as List<dynamic>?)
              ?.map((levelJson) => Levels.fromJson(levelJson as Map<String, dynamic>))
              .toList() ??
          [], // ✅ ensures empty list instead of null
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
      'levels': levels.map((l) => l.toJson()).toList(),
    };
  }
}
