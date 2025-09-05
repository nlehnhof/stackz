import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:stackz/widgets/custom_app_bar.dart';
import 'package:stackz/widgets/button.dart';
import 'package:stackz/models/room.dart';
import 'package:stackz/models/item.dart';
import 'package:stackz/models/shelf.dart';
import 'package:stackz/models/levels.dart';
import 'package:stackz/providers/project_provider.dart';
import 'package:stackz/views/editable_room_view.dart';

final uuid = Uuid();

class ProjectDetailsPage extends StatefulWidget {
  final Room room;

  const ProjectDetailsPage({super.key, required this.room});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  Shelf? selectedShelf;
  bool addingShelf = false;
  bool addingLevelMode = false;

  // Item and search controllers
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _searchItemController = TextEditingController();
  String _searchResult = "";

  // --- ITEM DIALOG ---
  void _addItem() {
    String? selectedShelfId;
    String? selectedLevelId;

    showDialog(
      context: context,
      builder: (context) {
        final project = widget.room;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Add New Item',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _itemDescriptionController,
                    decoration: const InputDecoration(labelText: 'Item Description'),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedShelfId,
                    decoration: const InputDecoration(labelText: "Select Shelf"),
                    items: project.shelves
                        .map((shelf) => DropdownMenuItem(
                              value: shelf.id,
                              child: Text(shelf.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedShelfId = value;
                        selectedLevelId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (selectedShelfId != null)
                    DropdownButtonFormField<String>(
                      value: selectedLevelId,
                      decoration: const InputDecoration(labelText: "Select Level"),
                      items: project.shelves
                          .firstWhere((s) => s.id == selectedShelfId!)
                          .levels
                          .map((level) => DropdownMenuItem(
                                value: level.id,
                                child: Text("Level ${level.height}"),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => selectedLevelId = value),
                    ),
                ],
              ),
              actions: [
                CustomButton(
                  label: 'Add',
                  onPressed: () {
                    final name = _itemNameController.text.trim();
                    final description = _itemDescriptionController.text.trim();
                    if (name.isNotEmpty &&
                        selectedShelfId != null &&
                        selectedLevelId != null) {
                      final newItem = Item(
                        id: uuid.v4(),
                        name: name,
                        description: description,
                      );
                      context.read<ProjectProvider>().addItemToLevel(
                            widget.room.id,
                            selectedShelfId!,
                            selectedLevelId!,
                            newItem,
                          );
                      _itemNameController.clear();
                      _itemDescriptionController.clear();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- SEARCH ITEM ---
  void _findItem() {
    final query = _searchItemController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResult = "Please enter an item name.");
      return;
    }
    String result = "Item not found.";
    for (var shelf in widget.room.shelves) {
      for (var level in shelf.levels) {
        for (var item in level.items) {
          if (item.name.toLowerCase() == query) {
            result =
                "Item '$query' found in Shelf: ${shelf.name}, Level: ${level.height}";
            break;
          }
        }
      }
    }
    setState(() => _searchResult = result);
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.read<ProjectProvider>();

    void handleShelfSelected(Shelf shelf) {
      setState(() {
        selectedShelf = shelf;
      });
    }

    void handleAddLevel(Shelf shelf) {
      projectProvider.addLevelToShelf(
          widget.room.id, shelf.id, Levels(id: uuid.v4(), height: 1));
      setState(() {
        selectedShelf = shelf;
      });
      Future.delayed(const Duration(seconds: 1),
          () => setState(() => selectedShelf = null));
    }

    void handleAddShelf(Shelf shelf) {
      projectProvider.addShelfToRoom(widget.room.id, shelf);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.room.name, style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Column(
        children: [
          // Toolbar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children: [
                CustomButton(
                  label: addingShelf ? "Cancel Shelf" : "Draw Shelf",
                  onPressed: () => setState(() {
                    addingShelf = !addingShelf;
                    addingLevelMode = false;
                  }),
                ),
                CustomButton(
                  label: addingLevelMode ? "Stop Adding Levels" : "Add Level",
                  onPressed: () => setState(() {
                    addingLevelMode = !addingLevelMode;
                    addingShelf = false;
                  }),
                ),
                CustomButton(label: 'Add Item', onPressed: _addItem),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _searchItemController,
                    decoration: const InputDecoration(
                      labelText: "Search Item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                CustomButton(label: 'Find Item', onPressed: _findItem),
              ],
            ),
          ),

          // Search result
          if (_searchResult.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(_searchResult, style: Theme.of(context).textTheme.bodyLarge),
            ),

          // Editable room view
          Expanded(
            child: EditableRoomView(
              room: widget.room,
              highlightItemName: _searchItemController.text.trim().isEmpty
                  ? null
                  : _searchItemController.text.trim(),
              addingShelf: addingShelf,
              addingLevelMode: addingLevelMode,
              selectedShelf: selectedShelf,
              onShelfSelected: handleShelfSelected,
              onAddLevel: handleAddLevel,
              onAddShelf: handleAddShelf,
            ),
          ),
        ],
      ),
    );
  }
}
