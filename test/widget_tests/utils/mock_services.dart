import 'package:health_care_app/services/appointment_service.dart';
import 'package:health_care_app/services/ice_service.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'mock_repository.dart';

class MockAppointmentService extends AppointmentService {
  MockAppointmentService() : super.withRepository(MockRepository());
}

class MockNotebookService extends NotebookService {
  MockNotebookService() : super.withRepository(MockRepository());
}

class MockIceService extends IceService {
  MockIceService() : super.withRepository(MockRepository());
}
