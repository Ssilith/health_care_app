// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class NotebookForm extends StatefulWidget {
  final Notebook? existingNote;
  final Function(Notebook) onChange;
  const NotebookForm({super.key, required this.onChange, this.existingNote});

  @override
  State<NotebookForm> createState() => _NotebookFormState();
}

class _NotebookFormState extends State<NotebookForm> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();

  final Repository repository = RepositoryImpl();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.existingNote != null) {
      final note = widget.existingNote!;
      title.text = note.noteTitle;
      content.text = note.noteContent;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? size.height * 0.2
                      : 20,
            ),
            SvgPicture.asset(
              'assets/photos/notebook.svg',
              height: size.height * 0.25,
            ),
            const SizedBox(height: 10),
            const Text(
              'New Note Form',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Title',
              controller: title,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Content',
              controller: content,
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: RectangularButton(
                title: 'SUBMIT',
                isLoading: isLoading,
                onPressed: () async {
                  if (title.text.isEmpty || content.text.isEmpty) {
                    displayErrorMotionToast('Fill in all the data.', context);
                    return;
                  }

                  try {
                    setState(() => isLoading = true);
                    Notebook newNote = Notebook(
                      id: widget.existingNote?.id,
                      userId: widget.existingNote?.userId,
                      creationDate:
                          widget.existingNote?.creationDate ??
                          DateTime.now().toString(),
                      noteTitle: title.text.trim(),
                      noteContent: content.text.trim(),
                    );

                    Notebook addedNote =
                        widget.existingNote != null
                            ? await repository.editNote(newNote)
                            : await repository.addNote(newNote);
                    widget.onChange(addedNote);
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() => isLoading = false);
                    displayErrorMotionToast(
                      'Failed to ${widget.existingNote != null ? "edit" : "add"} appointment.',
                      context,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
