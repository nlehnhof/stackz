import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'package:stackz/models/room.dart';
import 'package:stackz/models/shelf.dart';
import 'package:stackz/models/levels.dart';
import 'package:stackz/models/item.dart';

class ProjectProvider extends ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  // Undo/Redo stacks
  final List<List<Room>> _undoStack = [];
  final List<List<Room>> _redoStack = [];

  // --- rooms ---
  void addRoom(Room room) {
    _saveStateForUndo();
    _rooms.add(room);
    notifyListeners();
  }

  void removeRoom(Room room) {
    _saveStateForUndo();
    _rooms.remove(room);
    notifyListeners();
  }

  void updateRoom(Room updatedRoom) {
    _saveStateForUndo();
    final index = _rooms.indexWhere((p) => p.id == updatedRoom.id);
    if (index != -1) {
      _rooms[index] = updatedRoom;
      notifyListeners();
    }
  }

  Room? getRoomById(String id) {
    return _rooms.firstWhereOrNull((p) => p.id == id);
  }

  // --- Shelves ---
  void addShelfToRoom(String roomId, Shelf shelf) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      room.shelves.add(shelf);
      notifyListeners();
    }
  }

  void updateShelf(String roomId, Shelf updatedShelf) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      final index = room.shelves.indexWhere((s) => s.id == updatedShelf.id);
      if (index != -1) {
        room.shelves[index] = updatedShelf;
        notifyListeners();
      }
    }
  }

  void removeShelf(String roomId, String shelfId) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      room.shelves.removeWhere((s) => s.id == shelfId);
      notifyListeners();
    }
  }

  // --- Levels ---
  void addLevelToShelf(String roomId, String shelfId, Levels level) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      final shelf = room.shelves.firstWhereOrNull((s) => s.id == shelfId);
      if (shelf != null) {
        shelf.levels.add(level);
        notifyListeners();
      }
    }
  }

  void removeLevelFromShelf(String roomId, String shelfId, String levelId) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      final shelf = room.shelves.firstWhereOrNull((s) => s.id == shelfId);
      shelf?.levels.removeWhere((l) => l.id == levelId);
      notifyListeners();
    }
  }

  // --- Items ---
  void addItemToLevel(String roomId, String shelfId, String levelId, Item item) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      final shelf = room.shelves.firstWhereOrNull((s) => s.id == shelfId);
      final level = shelf?.levels.firstWhereOrNull((l) => l.id == levelId);
      if (level != null) {
        level.items.add(item);
        notifyListeners();
      }
    }
  }

  void removeItem(String roomId, String shelfId, String levelId, String itemId) {
    _saveStateForUndo();
    final room = getRoomById(roomId);
    if (room != null) {
      final shelf = room.shelves.firstWhereOrNull((s) => s.id == shelfId);
      final level = shelf?.levels.firstWhereOrNull((l) => l.id == levelId);
      level?.items.removeWhere((i) => i.id == itemId);
      notifyListeners();
    }
  }

  // --- Undo / Redo ---
  void _saveStateForUndo() {
    _undoStack.add(_cloneRooms());
    _redoStack.clear(); // Clear redo when new action
  }

  List<Room> _cloneRooms() {
    // Deep copy rooms
    return _rooms.map((room) {
      return Room(
        id: room.id,
        name: room.name,
        shelves: room.shelves.map((shelf) {
          return Shelf(
            id: shelf.id,
            name: shelf.name,
            width: shelf.width,
            depth: shelf.depth,
            posX: shelf.posX,
            posY: shelf.posY,
            levels: shelf.levels.map((level) {
              return Levels(
                id: level.id,
                height: level.height,
                items: level.items.map((item) {
                  return Item(
                    id: item.id,
                    name: item.name,
                    description: item.description,
                    width: item.width,
                  );
                }).toList(),
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(_cloneRooms());
    _rooms = _undoStack.removeLast();
    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(_cloneRooms());
    _rooms = _redoStack.removeLast();
    notifyListeners();
  }
}
