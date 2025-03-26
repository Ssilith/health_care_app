import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/api/chat_gpt.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class InsertPdfPage extends StatefulWidget {
  final Function(Notebook) onAdd;
  const InsertPdfPage({super.key, required this.onAdd});

  @override
  State<InsertPdfPage> createState() => _InsertPdfPageState();
}

class _InsertPdfPageState extends State<InsertPdfPage> {
  final Repository repository = RepositoryImpl();
  bool isLoading = false;

  Future readPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() => isLoading = true);

      PlatformFile file = result.files.first;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = File(file.path!).readAsBytesSync();
      }

      if (fileBytes == null) {
        setState(() => isLoading = false);
        displayErrorMotionToast('Failed to load file bytes.', context);
        return;
      }

      final PdfDocument document = PdfDocument(inputBytes: fileBytes);

      PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText(layoutText: true);
      String response = await fetchChatGPTResponse(text, context);

      setState(() => isLoading = false);

      if (response != "") {
        Notebook newNote = Notebook(
          creationDate: DateTime.now().toString(),
          noteTitle: "Chat GPT Note",
          noteContent: response.trim(),
        );
        Notebook addedNote = await repository.addNote(newNote);
        widget.onAdd(addedNote);
        Navigator.of(context).pop();
      }

      document.dispose();
    } else {
      setState(() => isLoading = false);
      displayErrorMotionToast('Failed to load file.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
      body: SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? size.height * 0.2
                        : 20,
              ),
              SvgPicture.asset(
                'assets/photos/attach.svg',
                height: size.height * 0.25,
              ),
              const SizedBox(height: 10),
              const Text(
                'Attach PDF File',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 300,
                child: RectangularButton(
                  title: "Choose a file",
                  isLoading: isLoading,
                  onPressed: () async => await readPDF(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
