import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/insert_pdf_service.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';

class InsertPdfPage extends StatefulWidget {
  final Function(Notebook) onAdd;
  const InsertPdfPage({super.key, required this.onAdd});

  @override
  State<InsertPdfPage> createState() => _InsertPdfPageState();
}

class _InsertPdfPageState extends State<InsertPdfPage> {
  final InsertPdfService insertPdfService = InsertPdfService();
  bool isLoading = false;

  Future<void> readPDF() async {
    setState(() => isLoading = true);

    final note = await insertPdfService.handlePdfAndCreateNote(context);

    setState(() => isLoading = false);

    if (note != null) {
      widget.onAdd(note);
      Navigator.of(context).pop();
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
