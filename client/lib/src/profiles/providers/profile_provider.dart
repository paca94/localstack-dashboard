import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/database/db_provider.dart';
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

  Iterable<ModelProfile> get profiles => _profiles;

  ModelProfile get currentProfile => _currentProfile;

  Future<void> changeProfile(ModelProfile afterProfile) async {
    _currentProfile.isSelect = false;
    afterProfile.isSelect = true;

    await profileBox.put(_currentProfile.id, _currentProfile);
    await profileBox.put(afterProfile.id, afterProfile);

    _currentProfile = afterProfile;
    notifyListeners();
  }

  Future<void> addProfile(
      {required int id,
      required String alias,
      required String profileType,
      String? endpointUrl,
      required String accessKey,
      required String secretAccessKey,
      required String region,
      required bool isSelect}) async {
    final newProfile = ModelProfile(
        id: id,
        alias: alias,
        profileType: profileType,
        accessKey: accessKey,
        secretAccessKey: secretAccessKey,
        region: region,
        isSelect: isSelect);
    await profileBox.put(newProfile.id, newProfile);
    _profiles = profileBox.values.toList();
  }

  Future<void> removeProfile(ModelProfile removeProfile) async {
    await profileBox.delete(removeProfile.id);
    _profiles = profileBox.values.toList();
  }
}
