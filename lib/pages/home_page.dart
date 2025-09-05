import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stackz/widgets/custom_app_bar.dart';
import 'package:stackz/widgets/button.dart';

import 'package:stackz/providers/shelf_provider.dart';
import 'package:stackz/models/room.dart';
import 'package:stackz/pages/add_project_page.dart';
import 'package:stackz/pages/project_details_page.dart';

class HomePage extends StatefulWidget {
  final List<Room> projects;
  const HomePage({super.key, required this.projects});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Home Page',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Home Page!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Text(
                'Get started by creating a new project or exploring existing ones.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var project in widget.projects)
                    ListTile(
                      title: Text(
                        project.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onTap: () {
                        // Navigate to the project details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChangeNotifierProvider(
                            create: (_) => ShelfProvider(project),
                            child: ProjectDetailsPage(room: project),
                          ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const Divider(),
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProjectPage()),
                   ); // Navigate to the new project creation page
                },
                label: 'Start New Project',
              ),
            ],
          ),
        ),
      ),
    );
  }
}