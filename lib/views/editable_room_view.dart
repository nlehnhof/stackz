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
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          if (widget.addingShelf) {
            dragStart = details.localPosition;
            tempShelf = Shelf(
              id: uuid.v4(),
              name: 'Shelf ${widget.room.shelves.length + 1}',
              posX: (dragStart!.dx / widget.scale).floor(),
              posY: (dragStart!.dy / widget.scale).floor(),
              width: 1,
              depth: 1,
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
              // Snap width/depth to grid in real-time
              tempShelf!.width =
                  ((details.localPosition.dx - dragStart!.dx) / widget.scale)
                      .ceil()
                      .clamp(1, 20);
              tempShelf!.depth =
                  ((details.localPosition.dy - dragStart!.dy) / widget.scale)
                      .ceil()
                      .clamp(1, 20);

              // Snap top-left to grid while dragging
              tempShelf!.posX = (dragStart!.dx / widget.scale).floor();
              tempShelf!.posY = (dragStart!.dy / widget.scale).floor();
            });
          }

          if (resizing && widget.selectedShelf != null && resizeStart != null) {
            setState(() {
              final deltaX =
                  (details.localPosition.dx - resizeStart!.dx) / widget.scale;
              final deltaY =
                  (details.localPosition.dy - resizeStart!.dy) / widget.scale;

              // Snap width/depth changes to grid
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

            if (tapX >= sx &&
                tapX <= sx + sw &&
                tapY >= sy &&
                tapY <= sy + sd) {
              if (widget.addingLevelMode) {
                widget.onAddLevel(shelf);
              } else {
                widget.onShelfSelected(shelf);
              }
              break;
            }
          }
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: _RoomPainter(
            room: widget.room,
            scale: widget.scale,
            tempShelf: tempShelf,
            selectedShelf: widget.selectedShelf,
            highlightItemName: widget.highlightItemName,
          ),
        ),
      ),
    );
  }
}

class _RoomPainter extends CustomPainter {
  final Room room;
  final double scale;
  final Shelf? tempShelf;
  final Shelf? selectedShelf;
  final String? highlightItemName;

  _RoomPainter({
    required this.room,
    required this.scale,
    this.tempShelf,
    this.selectedShelf,
    this.highlightItemName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Draw grid lines
    for (double x = 0; x <= size.width; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw existing shelves
    for (var shelf in room.shelves) {
      _drawShelf(canvas, shelf, selectedShelf == shelf);
    }

    // Draw temp shelf while adding
    if (tempShelf != null) {
      _drawShelf(canvas, tempShelf!, false);
    }
  }

  void _drawShelf(Canvas canvas, Shelf shelf, bool isSelected) {
    final rect = Rect.fromLTWH(
      shelf.posX * scale,
      shelf.posY * scale,
      shelf.width * scale,
      shelf.depth * scale,
    );

    final paint = Paint()
      ..color = isSelected ? Colors.green.shade300 : Colors.brown.shade300;

    canvas.drawRect(rect, paint);

    final border = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, border);

    // Draw levels
    for (int i = 0; i < shelf.levels.length; i++) {
      final levelY = rect.bottom - (i + 1) * 20;
      final levelRect = Rect.fromLTWH(rect.left, levelY, rect.width, 20);
      final levelPaint = Paint()..color = Colors.brown.shade100;
      canvas.drawRect(levelRect, levelPaint);

      // Draw items
      for (var item in shelf.levels[i].items) {
        final itemRect = Rect.fromLTWH(
          levelRect.left,
          levelRect.top,
          item.width * scale,
          levelRect.height,
        );
        final itemPaint = Paint()
          ..color = (highlightItemName != null &&
                  item.name.toLowerCase() == highlightItemName!.toLowerCase())
              ? Colors.yellow
              : Colors.grey.shade400;
        canvas.drawRect(itemRect, itemPaint);

        final borderPaint = Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawRect(itemRect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
