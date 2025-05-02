import 'package:health_care_app/services/repository_impl.dart';
import 'package:mockito/mockito.dart';
import '../../unit_tests/utils/mocks.mocks.dart';

void injectRepositoryForTests() {
  final mockRepo = MockRepository();

  when(mockRepo.getAppointments()).thenAnswer((_) async => []);
  when(mockRepo.getNotes()).thenAnswer((_) async => []);
  when(mockRepo.getIceInfos()).thenAnswer((_) async => []);

  // RepositoryImpl.globalOverride = mockRepo;
}
