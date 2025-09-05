import 'package:flutter/material.dart';
import 'package:stackz/models/room.dart';
// import 'package:stackz/app_theme.dart';

class RoomView extends StatelessWidget {
  final Room room;
  final String? highlightItemName; // the item name to highlight
  final double scale; // pixels per unit

  const RoomView({
    super.key,
    required this.room,
    this.highlightItemName,
    this.scale = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Render Shelves
        for (var shelf in room.shelves)
          Positioned(
            left: shelf.posX * scale,
            top: shelf.posY * scale,
            child: Container(
              width: shelf.width * scale,
              height: shelf.depth * scale,
              decoration: BoxDecoration(
                color: Colors.brown.shade300,
                border: Border.all(color: Colors.brown.shade800),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Render Levels stacked vertically
                  for (int levelIndex = 0; levelIndex < shelf.levels.length; levelIndex++)
                    Positioned(
                      bottom: levelIndex * 20.0,
                      left: 0,
                      child: Container(
                        width: shelf.width * scale,
                        height: 20.0, // fixed visual height per level
                        color: Colors.brown.shade100,
                        child: Stack(
                          children: [
                            // Render items inside this level
                            for (var item in shelf.levels[levelIndex].items)
                              Positioned(
                                left: 0,
                                top: 0,
                                width: item.width * scale,
                                height: 20.0, // match level height
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (highlightItemName != null &&
                                            item.name.toLowerCase() ==
                                                highlightItemName!.toLowerCase())
                                        ? Theme.of(context).highlightColor
                                        : Theme.of(context).disabledColor,
                                    border: Border.all(
                                        color: Colors.black54, width: 0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
