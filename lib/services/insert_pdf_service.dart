import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/chat_service.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class InsertPdfService {
  final NotebookService notebookService;
  final ChatService chatService;
  final FilePickerUtils filePickerUtils;

  InsertPdfService({
    NotebookService? notebookService,
    ChatService? chatService,
    FilePickerUtils? filePickerUtils,
  }) : notebookService = notebookService ?? NotebookService(),
       chatService = chatService ?? ChatService(),
       filePickerUtils = filePickerUtils ?? FilePickerUtils();

  Future<Notebook?> handlePdfAndCreateNote() async {
    try {
      // Use the injected FilePickerUtils.
      FilePickerResult? result = await filePickerUtils.pickSingleFile();

      if (result == null) {
        print('No file selected.');
        return null;
      }

      PlatformFile file = result.files.first;
      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await File(file.path!).readAsBytes();
      }
      if (fileBytes == null) {
        print('Failed to load file bytes.');
        return null;
      }

      final PdfDocument document = PdfDocument(inputBytes: fileBytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText(layoutText: true);
      document.dispose();

      String response = await chatService.fetchChatGPTResponse(text);
      if (response.isEmpty) {
        print('GPT response is empty.');
        return null;
      }

      final Notebook newNote = Notebook(
        creationDate: DateTime.now().toString(),
        noteTitle: "Chat GPT Note",
        noteContent: response.trim(),
      );

      return await notebookService.addNote(newNote);
    } catch (e) {
      print('An error occurred while reading the PDF: $e');
      return null;
    }
  }
}

class FilePickerUtils {
  final FilePicker filePicker;
  FilePickerUtils({FilePicker? filePicker})
    : filePicker = filePicker ?? FilePicker.platform;

  Future<FilePickerResult?> pickSingleFile() async {
    return await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  Future<String?> pickDirectory() async {
    return await filePicker.getDirectoryPath();
  }
}
