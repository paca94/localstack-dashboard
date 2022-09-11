import 'dart:convert';

import 'package:cloud_dashboard_client/src/enums.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_attach_queue.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//** DATABASE CLASS */
final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late final Box<ModelProfile> profileBox;
  late final Box<ModelProfile> attachProfileBox;
  late final Box<ModelSqsAttachQueue> attachQueueBox;
  late final _encryptionKey;

  init() async {
    await initSecure();

    // del all hive data
    // await Hive.deleteBoxFromDisk('profile');
    // await Hive.deleteBoxFromDisk('attach_profile');
    // await Hive.deleteBoxFromDisk('attach_sqs_queues');
    // await Hive.deleteFromDisk();
    await initProfiles();
    await initAttachProfiles();
    await initAttachQueues();
  }

  Future<void> initSecure() async {
    const secureStorage = FlutterSecureStorage();
    // if key not exists return null
    final encryprionKey = await secureStorage.read(key: 'key');
    if (encryprionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );
    }
    final key = await secureStorage.read(
      key: 'key',
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: const IOSOptions(
        accountName: 'hello',
      ),
    );
    _encryptionKey = base64Url.decode(key!);
  }

  Future<void> initProfiles() async {
    Hive.registerAdapter(ProfileAdapter());
    profileBox = await Hive.openBox<ModelProfile>('profile',
        encryptionCipher: HiveAesCipher(_encryptionKey));

    //first time loading
    if (profileBox.values.isEmpty) {
      final defaultProfile = ModelProfile(
          alias: "localstack",
          profileType: SupportServiceTypes.other,
          endpointUrl: "http://localhost:4566",
          accessKey: "fake",
          secretAccessKey: "fake",
          region: "ap-northeast-2",
          isSelect: true);
      await profileBox.put(defaultProfile.id, defaultProfile);
      final defaultProfile2 = ModelProfile(
          alias: "localstack2",
          profileType: SupportServiceTypes.other,
          endpointUrl: "http://localhost:4567",
          accessKey: "fake",
          secretAccessKey: "fake",
          region: "ap-northeast-2",
          isSelect: false);
      await profileBox.put(defaultProfile2.id, defaultProfile2);
    }
  }

  Future<void> initAttachProfiles() async {
    attachProfileBox = await Hive.openBox<ModelProfile>('attach_profile',
        encryptionCipher: HiveAesCipher(_encryptionKey));
  }

  Future<void> initAttachQueues() async {
    Hive.registerAdapter(SqsAttachQueueAdapter());
    attachQueueBox = await Hive.openBox<ModelSqsAttachQueue>(
        'attach_sqs_queues',
        encryptionCipher: HiveAesCipher(_encryptionKey));
  }
}
