import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stackz/providers/project_provider.dart';

import 'package:stackz/widgets/custom_app_bar.dart';
import 'package:stackz/widgets/button.dart';

import 'package:stackz/providers/shelf_provider.dart';
import 'package:stackz/pages/add_project_page.dart';
import 'package:stackz/pages/project_details_page.dart';
import 'package:stackz/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().rooms;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        title: Text(
          'Home Page',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ListTile(
                    title: Text(
                      project.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) => ShelfProvider(project),
                            child: ProjectDetailsPage(room: project),
                          ),
                        ),
                      );
                    },
                  );
                }
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
                color: AppTheme.buttonColor,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}