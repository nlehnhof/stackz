import 'package:stackz/models/item.dart';

class Levels {
  final String id; // immutable identifier
  int index;       // position/order of this level
  List<Item> items;

  Levels({
    required this.id,
    required this.index,
    List<Item>? items,
  }) : items = items ?? []; // ✅ never null

  factory Levels.fromJson(Map<String, dynamic> json) {
    return Levels(
      id: json['id'] as String,
      index: json['index'] is int
          ? json['index'] as int
          : int.tryParse(json['index'].toString()) ??
              0, // ✅ safely parse index
      items: (json['items'] as List<dynamic>?)
              ?.map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>))
              .toList() ??
          [], // ✅ ensures empty list instead of null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
