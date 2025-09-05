import 'package:flutter/material.dart';
import 'package:stackz/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:stackz/widgets/custom_app_bar.dart';
import 'package:stackz/widgets/button.dart';

import 'package:stackz/models/room.dart';

final uuid = Uuid();

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final TextEditingController _projectNameController = TextEditingController();

  void _createProject() {
    final String projectName = _projectNameController.text.trim();
    if (projectName.isNotEmpty) {
      final newProject = Room(
        id: uuid.v4(),
        name: projectName,
        shelves: [],
      );
      context.read<ProjectProvider>().addRoom(newProject);
      Navigator.pop(context); // return new project to previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a project name.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Add New Project',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _projectNameController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _createProject(),
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Create Project',
              onPressed: _createProject,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }
}
