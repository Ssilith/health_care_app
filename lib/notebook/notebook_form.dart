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
  final Function(Notebook) onAdd;
  const NotebookForm({super.key, required this.onAdd});

  @override
  State<NotebookForm> createState() => _NotebookFormState();
}

class _NotebookFormState extends State<NotebookForm> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  final Repository repository = RepositoryImpl();
  bool isLoading = false;

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
                      creationDate: DateTime.now().toString(),
                      noteTitle: title.text.trim(),
                      noteContent: content.text.trim(),
                    );

                    Notebook addedNote = await repository.addNote(newNote);
                    widget.onAdd(addedNote);
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() => isLoading = false);
                    displayErrorMotionToast(
                      'Failed to add appointment.',
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
