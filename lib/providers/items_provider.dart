import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'package:stackz/models/item.dart';
import 'package:stackz/models/levels.dart';

class ItemProvider extends ChangeNotifier {
  final Levels level;

  ItemProvider(this.level);

  List<Item> get items => level.items;

  void addItem(Item item) {
    level.items.add(item);
    notifyListeners();
  }

  void removeItem(String itemId) {
    level.items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void updateItem(Item updatedItem) {
    final index = level.items.indexWhere((i) => i.id == updatedItem.id);
    if (index != -1) {
      level.items[index] = updatedItem;
      notifyListeners();
    }
  }

  Item? getItemById(String id) =>
      level.items.firstWhereOrNull((i) => i.id == id);
}
