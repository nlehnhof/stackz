import 'package:flutter/material.dart';
import 'package:stackz/models/room.dart';
import 'package:stackz/models/shelf.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class EditableRoomView extends StatefulWidget {
  final Room room;
  final String? highlightItemName;
  final double scale;
  final bool addingShelf;
  final bool addingLevelMode;
  final Shelf? selectedShelf;
  final void Function(Shelf) onShelfSelected;
  final void Function(Shelf) onAddLevel;
  final void Function(Shelf) onAddShelf;

  const EditableRoomView({
    super.key,
    required this.room,
    this.highlightItemName,
    this.scale = 50.0,
    this.addingShelf = false,
    this.addingLevelMode = false,
    this.selectedShelf,
    required this.onShelfSelected,
    required this.onAddLevel,
    required this.onAddShelf,
  });

  @override
  State<EditableRoomView> createState() => _EditableRoomViewState();
}

class _EditableRoomViewState extends State<EditableRoomView> {
  Shelf? tempShelf;
  Offset? dragStart;
  bool resizing = false;
  Offset? resizeStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (widget.addingShelf) {
          dragStart = details.localPosition;
          tempShelf = Shelf(
            id: uuid.v4(),
            name: 'Shelf ${widget.room.shelves.length + 1}',
            width: 1,
            depth: 1,
            posX: (dragStart!.dx / widget.scale).floor(),
            posY: (dragStart!.dy / widget.scale).floor(),
            levels: [],
          );
        }

        if (widget.selectedShelf != null) {
          final shelf = widget.selectedShelf!;
          final handleRect = Rect.fromLTWH(
            shelf.posX * widget.scale + shelf.width * widget.scale - 20,
            shelf.posY * widget.scale + shelf.depth * widget.scale - 20,
            20,
            20,
          );
          if (handleRect.contains(details.localPosition)) {
            resizing = true;
            resizeStart = details.localPosition;
          }
        }
      },
      onPanUpdate: (details) {
        if (widget.addingShelf && dragStart != null && tempShelf != null) {
          setState(() {
            tempShelf!.width =
                ((details.localPosition.dx - dragStart!.dx) / widget.scale).ceil();
            tempShelf!.depth =
                ((details.localPosition.dy - dragStart!.dy) / widget.scale).ceil();
          });
        }

        if (resizing && widget.selectedShelf != null && resizeStart != null) {
          setState(() {
            final deltaX = (details.localPosition.dx - resizeStart!.dx) / widget.scale;
            final deltaY = (details.localPosition.dy - resizeStart!.dy) / widget.scale;
            widget.selectedShelf!.width =
                (widget.selectedShelf!.width + deltaX).clamp(1, 20).ceil();
            widget.selectedShelf!.depth =
                (widget.selectedShelf!.depth + deltaY).clamp(1, 20).ceil();
            resizeStart = details.localPosition;
          });
        }
      },
      onPanEnd: (details) {
        if (widget.addingShelf && tempShelf != null) {
          widget.onAddShelf(tempShelf!);
          tempShelf = null;
          dragStart = null;
        }
        if (resizing) {
          resizing = false;
          resizeStart = null;
        }
      },
      onTapDown: (details) {
        final tapX = (details.localPosition.dx / widget.scale).floor();
        final tapY = (details.localPosition.dy / widget.scale).floor();

        for (var shelf in widget.room.shelves) {
          final sx = shelf.posX;
          final sy = shelf.posY;
          final sw = shelf.width;
          final sd = shelf.depth;

          if (tapX >= sx && tapX <= sx + sw && tapY >= sy && tapY <= sy + sd) {
            if (widget.addingLevelMode) {
              widget.onAddLevel(shelf);
            } else {
              widget.onShelfSelected(shelf);
            }
            break;
          }
        }
      },
      child: Stack(
        children: [
          if (tempShelf != null)
            Positioned(
              left: tempShelf!.posX * widget.scale,
              top: tempShelf!.posY * widget.scale,
              child: Container(
                width: tempShelf!.width * widget.scale,
                height: tempShelf!.depth * widget.scale,
                color: Colors.brown.withOpacity(0.5),
              ),
            ),
          for (var shelf in widget.room.shelves)
            Positioned(
              left: shelf.posX * widget.scale,
              top: shelf.posY * widget.scale,
              child: Stack(
                children: [
                  Container(
                    width: shelf.width * widget.scale,
                    height: shelf.depth * widget.scale,
                    decoration: BoxDecoration(
                      color: shelf == widget.selectedShelf
                          ? Colors.green.shade300
                          : Colors.brown.shade300,
                      border: Border.all(color: Colors.brown.shade800),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i < shelf.levels.length; i++)
                          Positioned(
                            bottom: i * 20.0,
                            left: 0,
                            child: Container(
                              width: shelf.width * widget.scale,
                              height: 20,
                              color: Colors.brown.shade100,
                              child: Stack(
                                children: [
                                  for (var item in shelf.levels[i].items)
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      width: item.width * widget.scale,
                                      height: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (widget.highlightItemName != null &&
                                                  item.name.toLowerCase() ==
                                                      widget.highlightItemName!
                                                          .toLowerCase())
                                              ? Colors.yellow
                                              : Colors.grey.shade400,
                                          border: Border.all(
                                              color: Colors.black54, width: 0.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 12),
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
                  if (shelf == widget.selectedShelf)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
