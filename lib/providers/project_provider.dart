import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:stackz/models/room.dart';
import 'package:stackz/models/shelf.dart';
import 'package:stackz/models/levels.dart';
import 'package:stackz/models/item.dart';

final uuid = Uuid();

class ProjectProvider with ChangeNotifier {
  final List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  // --- ROOM METHODS ---
  void addRoom(Room room) {
    _rooms.add(room);
    notifyListeners();
  }

  void removeRoom(String roomId) {
    _rooms.removeWhere((room) => room.id == roomId);
    notifyListeners();
  }

  // --- SHELF METHODS ---
  void addShelfToRoom(String roomId, Shelf shelf) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    room.shelves.add(shelf);
    notifyListeners();
  }

  void removeShelfFromRoom(String roomId, String shelfId) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    room.shelves.removeWhere((shelf) => shelf.id == shelfId);
    notifyListeners();
  }

  // --- LEVEL METHODS ---
  void addLevelToShelf(String roomId, String shelfId, [Levels? level]) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    final shelf = room.shelves.firstWhere((s) => s.id == shelfId);

    final newIndex = shelf.levels.length + 1;

    final newLevel = level ??
        Levels(
          id: uuid.v4(),
          index: newIndex,
        );

    shelf.levels.add(newLevel);
    notifyListeners();
  }

  void removeLevelFromShelf(String roomId, String shelfId, String levelId) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    final shelf = room.shelves.firstWhere((s) => s.id == shelfId);

    shelf.levels.removeWhere((lvl) => lvl.id == levelId);

    // 🔄 Renumber levels so they're sequential again
    for (int i = 0; i < shelf.levels.length; i++) {
      shelf.levels[i].index = i + 1;
    }

    notifyListeners();
  }

  // --- ITEM METHODS ---
  void addItemToLevel(String roomId, String shelfId, String levelId, Item item) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    final shelf = room.shelves.firstWhere((s) => s.id == shelfId);
    final level = shelf.levels.firstWhere((l) => l.id == levelId);

    level.items.add(item);
    notifyListeners();
  }

  void removeItemFromLevel(String roomId, String shelfId, String levelId, String itemId) {
    final room = _rooms.firstWhere((r) => r.id == roomId);
    final shelf = room.shelves.firstWhere((s) => s.id == shelfId);
    final level = shelf.levels.firstWhere((l) => l.id == levelId);

    level.items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }
}
