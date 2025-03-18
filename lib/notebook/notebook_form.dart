import 'package:flutter/material.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/widgets/simple_button.dart';

class NotebookForm extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final Function(Notebook) onNoteAdded;

  NotebookForm({super.key, required this.onNoteAdded});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add New Note',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SimpleButton(
              width: 120,
              title: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 5),
            SimpleButton(
              width: 120,
              title: 'Add',
              onPressed: () {
                _addNote(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _addNote(BuildContext context) {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    Notebook newNote = Notebook(
      creationDate: DateTime.now().toString(),
      noteTitle: titleController.text.trim(),
      noteContent: contentController.text.trim(),
    );
    onNoteAdded(newNote);
    Navigator.of(context).pop();
  }
}
