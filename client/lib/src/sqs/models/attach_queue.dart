import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstack_dashboard_client/src/database/hive_types.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
import 'package:localstack_dashboard_client/src/utils/generate_utils.dart';

class AttachQueueAdapter extends TypeAdapter<ModelAttachQueue> {
  @override
  final typeId = HiveTypes.sqsAttachQueue;

  @override
  ModelAttachQueue read(BinaryReader reader) {
    return ModelAttachQueue.fromExist(
        id: reader.read(),
        registerUserProfileId: reader.read(),
        profileId: reader.read(),
        isSingleUseProfile: reader.readBool(),
        queueUrl: reader.read());
  }

  @override
  void write(BinaryWriter writer, ModelAttachQueue obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.registerUserProfileId);
    writer.writeInt(obj.profileId);
    writer.writeBool(obj.isSingleUseProfile);
    writer.write(obj.queueUrl);
  }
}

@HiveType(typeId: HiveTypes.sqsAttachQueue)
class ModelAttachQueue {
  @HiveField(0)
  late final int id;

  // user permanent profile id
  @HiveField(1)
  late final int registerUserProfileId;
  @HiveField(2)
  late final int profileId;
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
  ModelAttachQueue(
      {required this.registerUserProfileId,
      required this.profileId,
      required this.isSingleUseProfile,
      required this.queueUrl})
      : id = GenerateUtils.genId();

  ModelAttachQueue.fromExist(
      {required this.id,
      required this.registerUserProfileId,
      required this.profileId,
      required this.isSingleUseProfile,
      required this.queueUrl});

  setRealProfile(ModelProfile settingProfile) {
    _profile = settingProfile;
  }
}
