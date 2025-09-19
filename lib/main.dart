import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() => runApp(const StackZ3DApp());

class StackZ3DApp extends StatelessWidget {
  const StackZ3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StackZ 3D',
      home: const StackZ3DScene(),
    );
  }
}

class StackZ3DScene extends StatefulWidget {
  const StackZ3DScene({super.key});

  @override
  State<StackZ3DScene> createState() => _StackZ3DSceneState();
}

class _StackZ3DSceneState extends State<StackZ3DScene> {
  final int stackHeight = 5; // Number of cubes in the stack
  final double cubeSpacing = 1.0; // Vertical spacing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StackZ 3D')),
      body: Cube(
        onSceneCreated: (Scene scene) {
          // Center the camera
          scene.camera.zoom = 10;
          scene.camera.position.setValues(5, 5, 10);

          // Add stacked cubes
          for (int i = 0; i < stackHeight; i++) {
            scene.world.add(
              Object(
                fileName: 'assets/20357_Cube_Bookcase_v1_Textured.obj',
                position: Vector3(0, i * cubeSpacing, 0), // Stack vertically
              ),
            );
          }
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:stackz/app_theme.dart';
// import 'package:stackz/pages/home_page.dart';
// import 'package:stackz/providers/project_provider.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ProjectProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Stackz',
//         theme: AppTheme.themeData,
//         home: HomePage(),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // void main() => runApp(DrawApp());

// // class DrawApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: DrawPage(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // class DrawPage extends StatefulWidget {
// //   @override
// //   _DrawPageState createState() => _DrawPageState();
// // }

// // class _DrawPageState extends State<DrawPage> {
// //   // Store all points drawn
// //   List<Offset?> points = [];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Draw on Emulator'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.clear),
// //             onPressed: () {
// //               setState(() {
// //                 points.clear();
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //       body: LayoutBuilder(
// //         builder: (context, constraints) {
// //           return GestureDetector(
// //             onPanUpdate: (details) {
// //               setState(() {
// //                 // Convert global coordinates to local coordinates
// //                 // RenderBox box = context.findRenderObject() as RenderBox;
// //                 points.add(details.localPosition);
// //               });
// //             },
// //             onPanEnd: (_) {
// //               // Add a separator so lines don’t connect
// //               points.add(null);
// //             },
// //             child: CustomPaint(
// //               size: Size.infinite,
// //               painter: DrawPainter(points),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class DrawPainter extends CustomPainter {
// //   final List<Offset?> points;
// //   DrawPainter(this.points);

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()
// //       ..color = Colors.blue
// //       ..strokeWidth = 4.0
// //       ..strokeCap = StrokeCap.round;

// //     for (int i = 0; i < points.length - 1; i++) {
// //       if (points[i] != null && points[i + 1] != null) {
// //         canvas.drawLine(points[i]!, points[i + 1]!, paint);
// //       }
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(DrawPainter oldDelegate) => true;
// // }