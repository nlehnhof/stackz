import 'package:stackz/models/item.dart';

class Levels {
  final String id;        // immutable
  int height;            // mutable             // mutable
  List<Item> items;       // mutable

  Levels({
    required this.id,
    this.height = 1,
    this.items = const [],
  });

  factory Levels.fromJson(Map<String, dynamic> json) {
    return Levels(
      id: json['id'] as String,
      height: json['height'] as int? ?? 1,
      items: (json['items'] as List<dynamic>?)
              ?.map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'height': height,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}