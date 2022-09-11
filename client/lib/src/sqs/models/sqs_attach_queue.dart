import 'package:cloud_dashboard_client/src/database/hive_types.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/utils/generate_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SqsAttachQueueAdapter extends TypeAdapter<ModelSqsAttachQueue> {
  @override
  final typeId = HiveTypes.sqsAttachQueue;

  @override
  ModelSqsAttachQueue read(BinaryReader reader) {
    return ModelSqsAttachQueue.fromExist(
        id: reader.readString(),
        registerUserProfileId: reader.readString(),
        profileId: reader.readString(),
        isSingleUseProfile: reader.readBool(),
        queueUrl: reader.read());
  }

  @override
  void write(BinaryWriter writer, ModelSqsAttachQueue obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.registerUserProfileId);
    writer.writeString(obj.profileId);
    writer.writeBool(obj.isSingleUseProfile);
    writer.write(obj.queueUrl);
  }
}

@HiveType(typeId: HiveTypes.sqsAttachQueue)
class ModelSqsAttachQueue {
  @HiveField(0)
  late final String id;

  // user permanent profile id
  @HiveField(1)
  late final String registerUserProfileId;
  @HiveField(2)
  late final String profileId;
  @HiveField(3)
  late final bool isSingleUseProfile;
  @HiveField(4)
  late final String queueUrl;

  // value for
  late ModelProfile _profile;

  // has auth profile
  ModelProfile? get profile {
    return _profile;
  }

  // only for AttachQueueAdapter. don't use other place
  ModelSqsAttachQueue(
      {required this.registerUserProfileId,
      required this.profileId,
      required this.isSingleUseProfile,
      required this.queueUrl})
      : id = GenerateUtils.genId();

  ModelSqsAttachQueue.fromExist(
      {required this.id,
      required this.registerUserProfileId,
      required this.profileId,
      required this.isSingleUseProfile,
      required this.queueUrl});

  setRealProfile(ModelProfile settingProfile) {
    _profile = settingProfile;
  }
}
