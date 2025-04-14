import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:mockito/mockito.dart';
import '../utils/benchmark_helper.dart';
import '../utils/mocks.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late NotebookService notebookService;

  setUp(() {
    mockRepository = MockRepository();
    notebookService = NotebookService.withRepository(mockRepository);
  });

  group('NotebookService Tests', () {
    test('getAllNotes returns list of Notebook', () async {
      final notes = [
        Notebook(
          id: '1',
          userId: 'user1',
          creationDate: '2022-01-01',
          noteTitle: 'Note 1',
          noteContent: 'Content 1',
        ),
        Notebook(
          id: '2',
          userId: 'user1',
          creationDate: '2022-02-01',
          noteTitle: 'Note 2',
          noteContent: 'Content 2',
        ),
      ];

      when(mockRepository.getNotes()).thenAnswer((_) => Future.value(notes));

      await runBenchmark(() async {
        await notebookService.getAllNotes();
      }, testName: 'notebook_getAllNotes');

      reset(mockRepository);
      when(mockRepository.getNotes()).thenAnswer((_) => Future.value(notes));

      final result = await notebookService.getAllNotes();

      expect(result, notes);
      verify(mockRepository.getNotes()).called(1);
    });

    test('addNote returns added Notebook', () async {
      final newNote = Notebook(
        id: '3',
        userId: 'user1',
        creationDate: '2022-03-01',
        noteTitle: 'Note 3',
        noteContent: 'Content 3',
      );

      when(
        mockRepository.addNote(newNote),
      ).thenAnswer((_) => Future.value(newNote));

      await runBenchmark(() async {
        await notebookService.addNote(newNote);
      }, testName: 'notebook_addNote');

      reset(mockRepository);
      when(
        mockRepository.addNote(newNote),
      ).thenAnswer((_) => Future.value(newNote));

      final result = await notebookService.addNote(newNote);

      expect(result, newNote);
      verify(mockRepository.addNote(newNote)).called(1);
    });

    test('editNote returns edited Notebook', () async {
      final updatedNote = Notebook(
        id: '1',
        userId: 'user1',
        creationDate: '2022-01-01',
        noteTitle: 'Note 1 Updated',
        noteContent: 'Content 1 Updated',
      );

      when(
        mockRepository.editNote(updatedNote),
      ).thenAnswer((_) => Future.value(updatedNote));

      await runBenchmark(() async {
        await notebookService.editNote(updatedNote);
      }, testName: 'notebook_editNote');

      reset(mockRepository);
      when(
        mockRepository.editNote(updatedNote),
      ).thenAnswer((_) => Future.value(updatedNote));

      final result = await notebookService.editNote(updatedNote);

      expect(result, updatedNote);
      verify(mockRepository.editNote(updatedNote)).called(1);
    });

    test('deleteNote completes successfully', () async {
      when(mockRepository.deleteNote('1')).thenAnswer((_) => Future.value());

      await runBenchmark(() async {
        await notebookService.deleteNote('1');
      }, testName: 'notebook_deleteNote');

      reset(mockRepository);
      when(mockRepository.deleteNote('1')).thenAnswer((_) => Future.value());

      await notebookService.deleteNote('1');

      verify(mockRepository.deleteNote('1')).called(1);
    });
  });
}
