import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/insert_pdf_service.dart';
import '../utils/benchmark_helper.dart';
import '../utils/fakes_and_mocks.dart';

void main() {
  group('InsertPdfService Tests', () {
    late FakeFilePickerUtils fakeFilePickerUtils;
    setUp(() {
      fakeFilePickerUtils = FakeFilePickerUtils();
    });

    test(
      'handlePdfAndCreateNote returns a Notebook with expected content',
      () async {
        final fakeChatService = FakeChatService();
        final fakeNotebookService = FakeNotebookService();
        final insertPdfService = InsertPdfService(
          notebookService: fakeNotebookService,
          chatService: fakeChatService,
          filePickerUtils: fakeFilePickerUtils,
        );

        await runPerf(() async {
          await insertPdfService.handlePdfAndCreateNote();
        }, name: 'insertPdf_handlePdfAndCreateNote');

        final Notebook? note = await insertPdfService.handlePdfAndCreateNote();

        expect(note, isNotNull);
        expect(note!.noteTitle, equals("Chat GPT Note"));
        expect(note.noteContent, equals("Fake GPT response"));
      },
    );
  });
}
