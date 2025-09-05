import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'package:stackz/models/shelf.dart';
import 'package:stackz/models/room.dart';

class ShelfProvider extends ChangeNotifier {
  final Room room;

  ShelfProvider(this.room);

  List<Shelf> get shelves => room.shelves;

  void addShelf(Shelf shelf) {
    room.shelves.add(shelf);
    notifyListeners();
  }

  void removeShelf(String shelfId) {
    room.shelves.removeWhere((s) => s.id == shelfId);
    notifyListeners();
  }

  void updateShelf(Shelf updatedShelf) {
    final index = room.shelves.indexWhere((s) => s.id == updatedShelf.id);
    if (index != -1) {
      room.shelves[index] = updatedShelf;
      notifyListeners();
    }
  }

  Shelf? getShelfById(String id) =>
      room.shelves.firstWhereOrNull((s) => s.id == id);
}
