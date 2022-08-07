import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/database/db_provider.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_attach_queue.dart';

final sqsAttachControllerProvider = ChangeNotifierProvider((ref) {
  final db = ref.watch(databaseService);
  final userProfileController = ref.watch(profileControllerProvider);
  return SqsAttachQueueService(
      db.attachProfileBox, db.attachQueueBox, userProfileController);
});

class SqsAttachQueueService extends ChangeNotifier {
  final Box<ModelProfile> _attachProfileBox;
  final Box<ModelSqsAttachQueue> _attachQueueBox;
  final UserProfileController _userProfileController;

  List<ModelSqsAttachQueue> _currentProfileAttachQueues =
      <ModelSqsAttachQueue>[];

  List<ModelSqsAttachQueue> get queues => _currentProfileAttachQueues;

  SqsAttachQueueService(this._attachProfileBox, this._attachQueueBox,
      this._userProfileController) {
    // init list for current profile
    _currentProfileAttachQueues = _getQueueList();
    _initQueueProfiles();
  }

  // Attach profile information to target queues
  _initQueueProfiles() {
    for (final currentAttachQueue in _currentProfileAttachQueues) {
      _setQueueProfile(currentAttachQueue);
    }
  }

  _setQueueProfile(ModelSqsAttachQueue attachQueue) {
    if (attachQueue.isSingleUseProfile) {
      final ModelProfile? profile =
          _attachProfileBox.get(attachQueue.profileId);
      if (profile != null) {
        attachQueue.setRealProfile(profile);
      }
    } else {
      final ModelProfile? profile =
          _userProfileController.getProfile(attachQueue.profileId);
      if (profile != null) {
        attachQueue.setRealProfile(profile);
      }
    }
  }

  // get registered queues by user profile id
  List<ModelSqsAttachQueue> _getQueueList() {
    final currentProfile = _userProfileController.currentProfile;
    return _attachQueueBox.values
        .where((element) => element.registerUserProfileId == currentProfile.id)
        .toList();
  }

  // attach use for exist user profile
  attachQueueForPermanentUserProfile(
      {required ModelProfile profile, required String queueUrl}) async {
    _checkDuplicatedRegister(queueUrl);
    final newQueue = ModelSqsAttachQueue(
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
    _checkDuplicatedRegister(queueUrl);
    final newProfile = ModelProfile(
        alias: 'single-alias',
        profileType: 'single-profile-type',
        accessKey: accessKey,
        secretAccessKey: secretAccessKey,
        region: region,
        isSelect: false);

    final newQueue = ModelSqsAttachQueue(
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
  Future<void> detachQueue(int queueId) async {
    final delQueue = _attachQueueBox.get(queueId)!;
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
    _initQueueProfiles();
    notifyListeners();
  }

  ModelSqsAttachQueue getQueue(int queueId) {
    final queue = _attachQueueBox.get(queueId)!;
    _setQueueProfile(queue);
    return queue;
  }

  _checkDuplicatedRegister(String queueUrl) {
    try {
      _currentProfileAttachQueues
          .firstWhere((element) => element.queueUrl == queueUrl);
      throw "duplicated!";
    } catch (e) {
      if (e is StateError) {
      } else {
        rethrow;
      }
    }
  }
}
