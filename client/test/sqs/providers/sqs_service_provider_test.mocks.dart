// Mocks generated by Mockito 5.3.0 from annotations
// in localstack_dashboard_client/test/sqs/providers/sqs_service_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:ui' as _i7;

import 'package:hive_flutter/hive_flutter.dart' as _i2;
import 'package:localstack_dashboard_client/src/enums.dart' as _i6;
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart'
    as _i3;
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBox_0<E> extends _i1.SmartFake implements _i2.Box<E> {
  _FakeBox_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeModelProfile_1 extends _i1.SmartFake implements _i3.ModelProfile {
  _FakeModelProfile_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [UserProfileController].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserProfileController extends _i1.Mock
    implements _i4.UserProfileController {
  MockUserProfileController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Box<_i3.ModelProfile> get profileBox => (super.noSuchMethod(
      Invocation.getter(#profileBox),
      returnValue: _FakeBox_0<_i3.ModelProfile>(
          this, Invocation.getter(#profileBox))) as _i2.Box<_i3.ModelProfile>);
  @override
  List<_i3.ModelProfile> get profiles =>
      (super.noSuchMethod(Invocation.getter(#profiles),
          returnValue: <_i3.ModelProfile>[]) as List<_i3.ModelProfile>);
  @override
  _i3.ModelProfile get currentProfile =>
      (super.noSuchMethod(Invocation.getter(#currentProfile),
              returnValue:
                  _FakeModelProfile_1(this, Invocation.getter(#currentProfile)))
          as _i3.ModelProfile);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i5.Future<void> changeProfile(_i3.ModelProfile? afterProfile) =>
      (super.noSuchMethod(Invocation.method(#changeProfile, [afterProfile]),
              returnValue: _i5.Future<void>.value(),
              returnValueForMissingStub: _i5.Future<void>.value())
          as _i5.Future<void>);
  @override
  _i5.Future<void> updateProfile(_i3.ModelProfile? afterProfile) =>
      (super.noSuchMethod(Invocation.method(#updateProfile, [afterProfile]),
              returnValue: _i5.Future<void>.value(),
              returnValueForMissingStub: _i5.Future<void>.value())
          as _i5.Future<void>);
  @override
  _i5.Future<void> addProfile(
          {String? alias,
          _i6.SupportServiceTypes? profileType,
          String? endpointUrl,
          String? accessKey,
          String? secretAccessKey,
          String? region,
          bool? isSelect}) =>
      (super.noSuchMethod(
              Invocation.method(#addProfile, [], {
                #alias: alias,
                #profileType: profileType,
                #endpointUrl: endpointUrl,
                #accessKey: accessKey,
                #secretAccessKey: secretAccessKey,
                #region: region,
                #isSelect: isSelect
              }),
              returnValue: _i5.Future<void>.value(),
              returnValueForMissingStub: _i5.Future<void>.value())
          as _i5.Future<void>);
  @override
  _i5.Future<void> removeProfile(_i3.ModelProfile? removeProfile) =>
      (super.noSuchMethod(Invocation.method(#removeProfile, [removeProfile]),
              returnValue: _i5.Future<void>.value(),
              returnValueForMissingStub: _i5.Future<void>.value())
          as _i5.Future<void>);
  @override
  _i3.ModelProfile? getProfile(int? profileId) =>
      (super.noSuchMethod(Invocation.method(#getProfile, [profileId]))
          as _i3.ModelProfile?);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
