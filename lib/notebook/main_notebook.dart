import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/notebook/insert_pdf_page.dart';
import 'package:health_care_app/notebook/notebook_container.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:health_care_app/notebook/notebook_form.dart';

class MainNotebook extends StatefulWidget {
  const MainNotebook({super.key});

  @override
  State<MainNotebook> createState() => _MainNotebookState();
}

class _MainNotebookState extends State<MainNotebook> {
  final NotebookService notebookService = NotebookService();
  List<Notebook> notes = [];
  Future? getNotes;

  @override
  void initState() {
    super.initState();
    getNotes = notebookService.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return BlankScaffold(
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        activeIcon: Icons.close,
        icon: Icons.add,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.plus_one),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => NotebookForm(
                          onChange: (newNote) {
                            setState(() => notes.add(newNote));
                          },
                        ),
                  ),
                ),
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.picture_as_pdf),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            visible: true,
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => InsertPdfPage(
                          onAdd: (newNote) {
                            setState(() => notes.add(newNote));
                          },
                        ),
                  ),
                ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred. Please try again later.'),
            );
          } else {
            notes = (snapshot.data ?? []) as List<Notebook>;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes found.'));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ListView.builder(
                itemCount: notes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: NotebookContainer(
                      note: notes[index],
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => NotebookForm(
                                  existingNote: notes[index],
                                  onChange: (info) {
                                    setState(() => notes[index] = info);
                                  },
                                ),
                          ),
                        );
                      },
                      onDelete: (noteId) {
                        setState(() {
                          notes.removeWhere((element) => element.id == noteId);
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
