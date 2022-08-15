import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/database/db_provider.dart';
import 'package:localstack_dashboard_client/src/enums.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';

final profileControllerProvider =
    ChangeNotifierProvider<UserProfileController>((ref) {
  final db = ref.watch(databaseService);
  return UserProfileController(db.profileBox);
});

class UserProfileController with ChangeNotifier {
  UserProfileController(this.profileBox)
      : _currentProfile =
            profileBox.values.firstWhere((element) => element.isSelect),
        _profiles = profileBox.values.toList();

  final Box<ModelProfile> profileBox;

  ModelProfile _currentProfile;
  List<ModelProfile> _profiles;

  List<ModelProfile> get profiles => _profiles;

  ModelProfile get currentProfile => _currentProfile;

  refreshProfiles() {
    _profiles = profileBox.values.toList();
    notifyListeners();
  }

  Future<void> changeProfile(ModelProfile afterProfile) async {
    _currentProfile.isSelect = false;
    afterProfile.isSelect = true;

    await profileBox.put(_currentProfile.id, _currentProfile);
    await profileBox.put(afterProfile.id, afterProfile);

    _currentProfile = afterProfile;
    refreshProfiles();
  }

  Future<void> updateProfile(ModelProfile afterProfile) async {
    if (afterProfile.isSelect) {
      _currentProfile.isSelect = false;
      afterProfile.isSelect = true;
    }

    await profileBox.put(_currentProfile.id, _currentProfile);
    await profileBox.put(afterProfile.id, afterProfile);

    if (afterProfile.isSelect) _currentProfile = afterProfile;
    refreshProfiles();
  }

  Future<void> addProfile(
      {required String alias,
      required SupportServiceTypes profileType,
      String? endpointUrl,
      required String accessKey,
      required String secretAccessKey,
      required String region,
      required bool isSelect}) async {
    final newProfile = ModelProfile(
        alias: alias,
        profileType: profileType,
        endpointUrl: endpointUrl,
        accessKey: accessKey,
        secretAccessKey: secretAccessKey,
        region: region,
        isSelect: isSelect);
    await profileBox.put(newProfile.id, newProfile);
    refreshProfiles();
  }

  Future<void> removeProfile(ModelProfile removeProfile) async {
    if (removeProfile.isSelect) {
      profiles.first.isSelect = true;
    }
    await profileBox.delete(removeProfile.id);
    refreshProfiles();
  }

  ModelProfile? getProfile(int profileId) {
    return _profiles.firstWhere((element) => element.id == profileId);
  }
}
