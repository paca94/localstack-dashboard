// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:localstack_dashboard_client/src/enums.dart';
// import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
// import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
//
// class MockUserProfileController implements UserProfileController {
//   final List<ModelProfile> _profiles = [];
//
//   @override
//   void addListener(VoidCallback listener) {
//     // TODO: implement addListener
//   }
//
//   @override
//   Future<void> addProfile(
//       {required String alias,
//       required SupportServiceTypes profileType,
//       String? endpointUrl,
//       required String accessKey,
//       required String secretAccessKey,
//       required String region,
//       required bool isSelect}) async {
//     // TODO: implement addProfile
//     _profiles.add(ModelProfile(
//         alias: alias,
//         profileType: profileType,
//         accessKey: accessKey,
//         secretAccessKey: secretAccessKey,
//         region: region,
//         isSelect: isSelect));
//   }
//
//   @override
//   Future<void> changeProfile(ModelProfile afterProfile) {
//     // TODO: implement changeProfile
//     throw UnimplementedError();
//   }
//
//   @override
//   // TODO: implement currentProfile
//   ModelProfile get currentProfile => _profiles.first;
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//   }
//
//   @override
//   ModelProfile? getProfile(int profileId) {
//     // TODO: implement getProfile
//     throw UnimplementedError();
//   }
//
//   @override
//   // TODO: implement hasListeners
//   bool get hasListeners => throw UnimplementedError();
//
//   @override
//   void notifyListeners() {
//     // TODO: implement notifyListeners
//   }
//
//   @override
//   // TODO: implement profileBox
//   Box<ModelProfile> get profileBox => throw UnimplementedError();
//
//   @override
//   // TODO: implement profiles
//   List<ModelProfile> get profiles => _profiles;
//
//   @override
//   refreshProfiles() {
//     // TODO: implement refreshProfiles
//     throw UnimplementedError();
//   }
//
//   @override
//   void removeListener(VoidCallback listener) {
//     // TODO: implement removeListener
//   }
//
//   @override
//   Future<void> removeProfile(ModelProfile removeProfile) {
//     // TODO: implement removeProfile
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> updateProfile(ModelProfile afterProfile) {
//     // TODO: implement updateProfile
//     throw UnimplementedError();
//   }
// }
