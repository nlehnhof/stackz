import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'package:stackz/models/levels.dart';
import 'package:stackz/models/shelf.dart';

class LevelProvider extends ChangeNotifier {
  final Shelf shelf;

  LevelProvider(this.shelf);

  List<Levels> get levels => shelf.levels;

  void addLevel(Levels level) {
    shelf.levels.add(level);
    notifyListeners();
  }

  void removeLevel(String levelId) {
    shelf.levels.removeWhere((l) => l.id == levelId);
    notifyListeners();
  }

  void updateLevel(Levels updatedLevel) {
    final index = shelf.levels.indexWhere((l) => l.id == updatedLevel.id);
    if (index != -1) {
      shelf.levels[index] = updatedLevel;
      notifyListeners();
    }
  }

  Levels? getLevelById(String id) =>
      shelf.levels.firstWhereOrNull((l) => l.id == id);
}
