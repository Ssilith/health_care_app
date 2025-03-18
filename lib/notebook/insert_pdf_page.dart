// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/api/chat_gpt.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/simple_button.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

class InsertPdfPage extends StatefulWidget {
  final Function(String) response;
  const InsertPdfPage({super.key, required this.response});

  @override
  State<InsertPdfPage> createState() => _InsertPdfPageState();
}

class _InsertPdfPageState extends State<InsertPdfPage> {
  bool isLoading = false;

  Future readPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        isLoading = true;
      });

      PlatformFile file = result.files.first;

      final PdfDocument document =
          PdfDocument(inputBytes: File(file.path!).readAsBytesSync());

      // final PdfDocument document =
      //     PdfDocument(inputBytes: await readDocumentData('report.pdf'));

      PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText(layoutText: true);
      String response = await fetchChatGPTResponse(text, context);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();

      widget.response(response);

      document.dispose();
    } else {
      displayErrorMotionToast('Failed to load file.', context);
    }
  }

  Future<List<int>> readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
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
                      height: MediaQuery.of(context).viewInsets.bottom == 0
                          ? size.height * 0.2
                          : 20),
                  SvgPicture.asset(
                    'assets/undraw_attached_file_re_0n9b.svg',
                    height: size.height * 0.25,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Attach PDF File',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (!isLoading)
                    SimpleButton(
                      title: "Choose a file",
                      onPressed: readPDF,
                      width: 150,
                    )
                  else
                    const CircularProgressIndicator()
                ],
              ),
            )));
  }
}
