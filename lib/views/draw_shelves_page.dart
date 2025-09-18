import 'package:flutter/material.dart';
import 'package:stackz/models/shelf.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class DrawShelvesPage extends StatefulWidget {
  final double scale;

  const DrawShelvesPage({super.key, this.scale = 50.0});

  @override
  State<DrawShelvesPage> createState() => _DrawShelvesPageState();
}

class _DrawShelvesPageState extends State<DrawShelvesPage> {
  Offset? start;
  Offset? current;
  final List<Rect> rectangles = [];

  void _finishDrawing() {
    final shelves = rectangles.map((rect) {
      final posX = (rect.left / widget.scale).floor();
      final posY = (rect.top / widget.scale).floor();
      final width = (rect.width / widget.scale).ceil().clamp(1, 50);
      final depth = (rect.height / widget.scale).ceil().clamp(1, 50);

      return Shelf(
        id: uuid.v4(),
        name: "Shelf ${rectangles.indexOf(rect) + 1}",
        posX: posX,
        posY: posY,
        width: width,
        depth: depth,
        levels: [], // empty for now, can add levels later
      );
    }).toList();

    Navigator.pop(context, shelves);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw Shelves"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _finishDrawing,
          )
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            start = details.localPosition;
            current = start;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            current = details.localPosition;
          });
        },
        onPanEnd: (details) {
          if (start != null && current != null) {
            setState(() {
              rectangles.add(Rect.fromPoints(start!, current!));
              start = null;
              current = null;
            });
          }
        },
        child: CustomPaint(
          painter: RectanglesPainter(
            rectangles: rectangles,
            temp: (start != null && current != null)
                ? Rect.fromPoints(start!, current!)
                : null,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class RectanglesPainter extends CustomPainter {
  final List<Rect> rectangles;
  final Rect? temp;

  RectanglesPainter({required this.rectangles, this.temp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var rect in rectangles) {
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, border);
    }

    if (temp != null) {
      canvas.drawRect(temp!, paint);
      canvas.drawRect(temp!, border);
    }
  }

  @override
  bool shouldRepaint(covariant RectanglesPainter oldDelegate) =>
      oldDelegate.rectangles != rectangles || oldDelegate.temp != temp;
}
