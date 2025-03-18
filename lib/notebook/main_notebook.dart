// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/notebook/insert_pdf_page.dart';
import 'package:health_care_app/notebook/notebook_detail.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/notebook/notebook_form.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/simple_button.dart';

class MainNotebook extends StatefulWidget {
  const MainNotebook({super.key});

  @override
  State<MainNotebook> createState() => _MainNotebookState();
}

class _MainNotebookState extends State<MainNotebook> {
  final Repository repository = RepositoryImpl();
  List<Notebook> notes = [];
  Future? getNotes;

  @override
  void initState() {
    super.initState();
    getNotes = repository.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return BlankScaffold(
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        activeIcon: Icons.close,
        icon: Icons.add,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.plus_one),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            onTap: () {
              _showAddNoteDialog(context);
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.picture_as_pdf),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            visible: true,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InsertPdfPage(
                      response: (summary) {
                        if (summary != "") {
                          Notebook newNote = Notebook(
                              creationDate: DateTime.now().toString(),
                              noteTitle: "Chat GPT Note",
                              noteContent: summary.trim());

                          repository.addNote(newNote).then((_) {
                            setState(() {
                              getNotes = repository.getNotes();
                            });
                          });
                        } else {
                          displayErrorMotionToast(
                              'Failed to fetch response.', context);
                        }
                      },
                    ))),
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
              child: Text('An error occured. Please try again later.'),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No notes found.'));
          } else {
            notes = snapshot.data as List<Notebook>;
            return Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Delete Note",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "Do you really want to delete this note?",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SimpleButton(
                                  width: 120,
                                  title: 'Cancel',
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const SizedBox(width: 5),
                                SimpleButton(
                                  width: 120,
                                  title: 'Delete',
                                  onPressed: () async {
                                    await repository
                                        .deleteNote(notes[index].id!);
                                    setState(() {
                                      notes.removeAt(index);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              NoteDetailPage(note: notes[index]),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 180,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    notes[index].noteTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Data utworzenia: ${notes[index].creationDate}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      notes[index].noteContent,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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

  void _showAddNoteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return NotebookForm(
          onNoteAdded: (newNote) {
            repository.addNote(newNote).then((_) {
              setState(() {
                getNotes = repository.getNotes();
              });
            });
          },
        );
      },
    );
  }
}
