import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';

class NotebookService {
  final Repository _repository;

  NotebookService() : _repository = RepositoryImpl();
  NotebookService.withRepository(this._repository);

  Future<List<Notebook>> getAllNotes() async {
    return await _repository.getNotes();
  }

  Future<Notebook> addNote(Notebook note) async {
    return await _repository.addNote(note);
  }

  Future<Notebook> editNote(Notebook note) async {
    return await _repository.editNote(note);
  }

  Future<void> deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
  }
}
