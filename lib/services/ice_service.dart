import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';

class IceService {
  final Repository _repository;

  IceService() : _repository = RepositoryImpl();
  IceService.withRepository(this._repository);

  Future<List<IceInfo>> getAllIceInfos() async {
    return await _repository.getIceInfos();
  }

  Future<IceInfo> addIceInfo(IceInfo note) async {
    return await _repository.addIceInfo(note);
  }

  Future<IceInfo> editIceInfo(IceInfo note) async {
    return await _repository.editIceInfo(note);
  }

  Future<void> deleteIceInfo(String noteId) async {
    await _repository.deleteIceInfo(noteId);
  }
}
