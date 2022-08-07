import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstack_dashboard_client/src/database/hive_types.dart';
import 'package:localstack_dashboard_client/src/utils/generate_utils.dart';

class ProfileAdapter extends TypeAdapter<ModelProfile> {
  @override
  final typeId = HiveTypes.profile;

  @override
  ModelProfile read(BinaryReader reader) {
    return ModelProfile.fromExist(
        id: reader.read(),
        alias: reader.read(),
        profileType: reader.read(),
        endpointUrl: reader.read(),
        accessKey: reader.read(),
        secretAccessKey: reader.read(),
        region: reader.read(),
        isSelect: reader.readBool());
  }

  @override
  void write(BinaryWriter writer, ModelProfile obj) {
    writer.write(obj.id);
    writer.write(obj.alias);
    writer.write(obj.profileType);
    writer.write(obj.endpointUrl);
    writer.write(obj.accessKey);
    writer.write(obj.secretAccessKey);
    writer.write(obj.region);
    writer.writeBool(obj.isSelect);
  }
}

@HiveType(typeId: HiveTypes.profile)
class ModelProfile {
  ModelProfile(
      {required this.alias,
      required this.profileType,
      this.endpointUrl,
      required this.accessKey,
      required this.secretAccessKey,
      required this.region,
      required this.isSelect})
      : id = GenerateUtils.genId();

  ModelProfile.fromExist(
      {required this.id,
      required this.alias,
      required this.profileType,
      this.endpointUrl,
      required this.accessKey,
      required this.secretAccessKey,
      required this.region,
      required this.isSelect});

  ModelProfile.forSingleUse(
      {this.endpointUrl,
      required this.accessKey,
      required this.secretAccessKey,
      required this.region,
      required this.isSelect})
      : id = GenerateUtils.genId(),
        alias = "singleUseProfile",
        profileType = "temp";

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String alias;
  @HiveField(2)
  final String profileType;
  @HiveField(3)
  final String? endpointUrl;
  @HiveField(4)
  final String accessKey;
  @HiveField(5)
  final String secretAccessKey;
  @HiveField(6)
  final String region;
  @HiveField(7)
  bool isSelect;
}
