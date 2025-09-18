
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stackz/app_theme.dart';
import 'package:stackz/pages/home_page.dart';
import 'package:stackz/providers/project_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'Stackz',
        theme: AppTheme.themeData,
        home: HomePage(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() => runApp(DrawApp());

// class DrawApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DrawPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class DrawPage extends StatefulWidget {
//   @override
//   _DrawPageState createState() => _DrawPageState();
// }

// class _DrawPageState extends State<DrawPage> {
//   // Store all points drawn
//   List<Offset?> points = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Draw on Emulator'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () {
//               setState(() {
//                 points.clear();
//               });
//             },
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return GestureDetector(
//             onPanUpdate: (details) {
//               setState(() {
//                 // Convert global coordinates to local coordinates
//                 // RenderBox box = context.findRenderObject() as RenderBox;
//                 points.add(details.localPosition);
//               });
//             },
//             onPanEnd: (_) {
//               // Add a separator so lines don’t connect
//               points.add(null);
//             },
//             child: CustomPaint(
//               size: Size.infinite,
//               painter: DrawPainter(points),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class DrawPainter extends CustomPainter {
//   final List<Offset?> points;
//   DrawPainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;

//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i]!, points[i + 1]!, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(DrawPainter oldDelegate) => true;
// }