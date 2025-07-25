// Mocks generated by Mockito 5.4.5 from annotations
// in health_care_app/test/unit_tests/utils/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:health_care_app/model/appointment.dart' as _i2;
import 'package:health_care_app/model/ice_info.dart' as _i4;
import 'package:health_care_app/model/notebook.dart' as _i3;
import 'package:health_care_app/services/repository.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAppointment_0 extends _i1.SmartFake implements _i2.Appointment {
  _FakeAppointment_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeNotebook_1 extends _i1.SmartFake implements _i3.Notebook {
  _FakeNotebook_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeIceInfo_2 extends _i1.SmartFake implements _i4.IceInfo {
  _FakeIceInfo_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [Repository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRepository extends _i1.Mock implements _i5.Repository {
  MockRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Appointment> addAppointment(_i2.Appointment? appointment) =>
      (super.noSuchMethod(
            Invocation.method(#addAppointment, [appointment]),
            returnValue: _i6.Future<_i2.Appointment>.value(
              _FakeAppointment_0(
                this,
                Invocation.method(#addAppointment, [appointment]),
              ),
            ),
          )
          as _i6.Future<_i2.Appointment>);

  @override
  _i6.Future<_i2.Appointment> editAppointment(_i2.Appointment? appointment) =>
      (super.noSuchMethod(
            Invocation.method(#editAppointment, [appointment]),
            returnValue: _i6.Future<_i2.Appointment>.value(
              _FakeAppointment_0(
                this,
                Invocation.method(#editAppointment, [appointment]),
              ),
            ),
          )
          as _i6.Future<_i2.Appointment>);

  @override
  _i6.Future<List<_i2.Appointment>> getAppointments() =>
      (super.noSuchMethod(
            Invocation.method(#getAppointments, []),
            returnValue: _i6.Future<List<_i2.Appointment>>.value(
              <_i2.Appointment>[],
            ),
          )
          as _i6.Future<List<_i2.Appointment>>);

  @override
  _i6.Future<void> deleteAppointment(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteAppointment, [id]),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  _i6.Future<_i3.Notebook> addNote(_i3.Notebook? note) =>
      (super.noSuchMethod(
            Invocation.method(#addNote, [note]),
            returnValue: _i6.Future<_i3.Notebook>.value(
              _FakeNotebook_1(this, Invocation.method(#addNote, [note])),
            ),
          )
          as _i6.Future<_i3.Notebook>);

  @override
  _i6.Future<_i3.Notebook> editNote(_i3.Notebook? note) =>
      (super.noSuchMethod(
            Invocation.method(#editNote, [note]),
            returnValue: _i6.Future<_i3.Notebook>.value(
              _FakeNotebook_1(this, Invocation.method(#editNote, [note])),
            ),
          )
          as _i6.Future<_i3.Notebook>);

  @override
  _i6.Future<List<_i3.Notebook>> getNotes() =>
      (super.noSuchMethod(
            Invocation.method(#getNotes, []),
            returnValue: _i6.Future<List<_i3.Notebook>>.value(<_i3.Notebook>[]),
          )
          as _i6.Future<List<_i3.Notebook>>);

  @override
  _i6.Future<void> deleteNote(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteNote, [id]),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  _i6.Future<_i4.IceInfo> addIceInfo(_i4.IceInfo? info) =>
      (super.noSuchMethod(
            Invocation.method(#addIceInfo, [info]),
            returnValue: _i6.Future<_i4.IceInfo>.value(
              _FakeIceInfo_2(this, Invocation.method(#addIceInfo, [info])),
            ),
          )
          as _i6.Future<_i4.IceInfo>);

  @override
  _i6.Future<_i4.IceInfo> editIceInfo(_i4.IceInfo? info) =>
      (super.noSuchMethod(
            Invocation.method(#editIceInfo, [info]),
            returnValue: _i6.Future<_i4.IceInfo>.value(
              _FakeIceInfo_2(this, Invocation.method(#editIceInfo, [info])),
            ),
          )
          as _i6.Future<_i4.IceInfo>);

  @override
  _i6.Future<List<_i4.IceInfo>> getIceInfos() =>
      (super.noSuchMethod(
            Invocation.method(#getIceInfos, []),
            returnValue: _i6.Future<List<_i4.IceInfo>>.value(<_i4.IceInfo>[]),
          )
          as _i6.Future<List<_i4.IceInfo>>);

  @override
  _i6.Future<void> deleteIceInfo(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteIceInfo, [id]),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  String getUserId() =>
      (super.noSuchMethod(
            Invocation.method(#getUserId, []),
            returnValue: _i7.dummyValue<String>(
              this,
              Invocation.method(#getUserId, []),
            ),
          )
          as String);
}
