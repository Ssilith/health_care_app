import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/chat_service.dart';
import 'package:health_care_app/services/geo_service.dart';
import 'package:health_care_app/services/insert_pdf_service.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:mockito/mockito.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#createUserWithEmailAndPassword, [], {
              #email: email,
              #password: password,
            }),
            returnValue: Future<UserCredential>.value(MockUserCredential()),
          )
          as Future<UserCredential>;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#signInWithEmailAndPassword, [], {
              #email: email,
              #password: password,
            }),
            returnValue: Future<UserCredential>.value(MockUserCredential()),
          )
          as Future<UserCredential>;

  @override
  Future<void> sendPasswordResetEmail({
    ActionCodeSettings? actionCodeSettings,
    required String email,
  }) =>
      super.noSuchMethod(
            Invocation.method(#sendPasswordResetEmail, [], {
              #actionCodeSettings: actionCodeSettings,
              #email: email,
            }),
            returnValue: Future<void>.value(),
          )
          as Future<void>;
}

class MockUserCredential extends Mock implements UserCredential {}

class FakeNotebookService extends Fake implements NotebookService {
  @override
  Future<Notebook> addNote(Notebook note) async => note;
}

class FakeChatService extends Fake implements ChatService {
  @override
  Future<String> fetchChatGPTResponse(String prompt) async {
    return "Fake GPT response";
  }

  @override
  Future<String> sendPrompt(String prompt) async {
    return "Fake prompt reply";
  }
}

class FakeFilePickerUtils extends Fake implements FilePickerUtils {
  @override
  Future<FilePickerResult?> pickSingleFile() async {
    final PdfDocument document = PdfDocument();
    document.pages.add();
    final Uint8List pdfBytes = Uint8List.fromList(await document.save());
    document.dispose();

    return FilePickerResult([
      PlatformFile(name: "dummy.pdf", size: pdfBytes.length, bytes: pdfBytes),
    ]);
  }
}

class FakeGeoService extends GeoService {
  FakeGeoService({super.client});
  @override
  Future<String> getApiKey() async => "fake_geo_key";
}
