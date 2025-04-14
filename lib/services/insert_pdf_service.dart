import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_care_app/api/chat_gpt.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class InsertPdfService {
  final NotebookService _notebookService = NotebookService();

  Future<Notebook?> handlePdfAndCreateNote(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        displayErrorMotionToast('No file selected.', context);
        return null;
      }

      PlatformFile file = result.files.first;
      Uint8List? fileBytes = file.bytes;

      if (fileBytes == null && file.path != null) {
        fileBytes = File(file.path!).readAsBytesSync();
      }

      if (fileBytes == null) {
        displayErrorMotionToast('Failed to load file bytes.', context);
        return null;
      }

      final PdfDocument document = PdfDocument(inputBytes: fileBytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);

      String text = extractor.extractText(layoutText: true);
      document.dispose();

      String response = await fetchChatGPTResponse(text, context);
      if (response.isEmpty) {
        displayErrorMotionToast('GPT response is empty.', context);
        return null;
      }

      final Notebook newNote = Notebook(
        creationDate: DateTime.now().toString(),
        noteTitle: "Chat GPT Note",
        noteContent: response.trim(),
      );

      return await _notebookService.addNote(newNote);
    } catch (e) {
      displayErrorMotionToast(
        'An error occurred while reading the PDF.',
        context,
      );
      return null;
    }
  }
}
