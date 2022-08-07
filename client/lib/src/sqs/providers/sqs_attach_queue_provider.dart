import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/database/db_provider.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/models/attach_queue.dart';

final sqsAttachControllerProvider = ChangeNotifierProvider((ref) {
  final db = ref.watch(databaseService);
  final userProfileController = ref.watch(profileControllerProvider);
  return SqsAttachQueueService(
      db.attachProfileBox, db.attachQueueBox, userProfileController);
});

class SqsAttachQueueService extends ChangeNotifier {
  final Box<ModelProfile> _attachProfileBox;
  final Box<ModelAttachQueue> _attachQueueBox;
  final UserProfileController _userProfileController;

  List<ModelAttachQueue> _currentProfileAttachQueues = <ModelAttachQueue>[];

  List<ModelAttachQueue> get queues => _currentProfileAttachQueues;

  SqsAttachQueueService(this._attachProfileBox, this._attachQueueBox,
      this._userProfileController) {
    // init list for current profile
    _initQueueProfiles();
    _currentProfileAttachQueues = _getQueueList();
  }

  // Attach profile information to target queues
  _initQueueProfiles() {
    for (final currentAttachQueue in _attachQueueBox.values) {
      if (currentAttachQueue.isSingleUseProfile) {
        final ModelProfile? profile =
            _attachProfileBox.get(currentAttachQueue.profileId);
        if (profile != null) {
          currentAttachQueue.setRealProfile(profile);
        }
      } else {
        final ModelProfile? profile =
            _userProfileController.getProfile(currentAttachQueue.profileId);
        if (profile != null) {
          currentAttachQueue.setRealProfile(profile);
        }
      }
    }
  }

  // get registered queues by user profile id
  List<ModelAttachQueue> _getQueueList() {
    final currentProfile = _userProfileController.currentProfile;
    return _attachQueueBox.values
        .where((element) => element.registerUserProfileId == currentProfile.id)
        .toList();
  }

  // attach use for exist user profile
  attachQueueForPermanentUserProfile(
      {required ModelProfile profile, required String queueUrl}) async {
    final newQueue = ModelAttachQueue(
        registerUserProfileId: _userProfileController.currentProfile.id,
        profileId: profile.id,
        isSingleUseProfile: false,
        queueUrl: queueUrl);
    await _attachQueueBox.put(newQueue.id, newQueue);

    // refresh queue list
    refreshQueues();
  }

  Future<void> attachQueueForSingleUseProfile({
    // profile
    String? endpointUrl,
    required String accessKey,
    required String secretAccessKey,
    required String region,
    // queue
    required String queueUrl,
  }) async {
    final newProfile = ModelProfile(
        alias: 'single-alias',
        profileType: 'single-profile-type',
        accessKey: accessKey,
        secretAccessKey: secretAccessKey,
        region: region,
        isSelect: false);

    final newQueue = ModelAttachQueue(
        registerUserProfileId: _userProfileController.currentProfile.id,
        profileId: newProfile.id,
        isSingleUseProfile: true,
        queueUrl: queueUrl);
    await _attachProfileBox.put(newProfile.id, newProfile);
    await _attachQueueBox.put(newQueue.id, newQueue);

    // refresh queue list
    refreshQueues();
  }

  // Attached queues cannot be deleted, only detached
  Future<void> detachQueue(ModelAttachQueue delQueue) async {
    if (delQueue.isSingleUseProfile) {
      // remove single profile
      await _attachProfileBox.delete(delQueue.profileId);
    }
    await _attachQueueBox.delete(delQueue.id);

    // refresh queue list
    refreshQueues();
  }

  refreshQueues() {
    _currentProfileAttachQueues = _getQueueList();
    notifyListeners();
  }
}
