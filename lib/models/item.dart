class Item {
  final String id;
  String name;
  String description;
  int width;
  int height;
  int depth;

  Item({
    required this.id,
    required this.name,
    this.description = "No description provided",
    this.width = 1,
    this.height = 1,
    this.depth = 1,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? "No description provided",
      width: json['width'] as int? ?? 1,
      height: json['height'] as int? ?? 1,
      depth: json['depth'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'width': width,
      'height': height,
      'depth': depth,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.width == width &&
        other.height == height &&
        other.depth == depth;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      width.hashCode ^
      height.hashCode ^
      depth.hashCode;
}
