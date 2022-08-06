import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';

//** DATABASE CLASS */
final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late final Box<ModelProfile> profileBox;
  late final _encryptionKey;

  init() async {
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

    // del all hive data
    // await Hive.deleteFromDisk();
    
    await initProfile();
  }

  Future<void> initProfile() async {
    Hive.registerAdapter(ProfileAdapter());
    profileBox = await Hive.openBox<ModelProfile>('profile',
        encryptionCipher: HiveAesCipher(_encryptionKey));

    //first time loading
    if (profileBox.values.isEmpty) {
      final defaultProfile = ModelProfile(
          id: ModelProfile.genId(),
          alias: "localstack",
          profileType: "localStack",
          endpointUrl: "http://localhost:4566",
          accessKey: "fake",
          secretAccessKey: "fake",
          region: "ap-northeast-2",
          isSelect: true);
      await profileBox.put(defaultProfile.id, defaultProfile);
      final defaultProfile2 = ModelProfile(
          id: ModelProfile.genId(),
          alias: "localstack2",
          profileType: "localStack",
          endpointUrl: "http://localhost:4567",
          accessKey: "fake",
          secretAccessKey: "fake",
          region: "ap-northeast-2",
          isSelect: false);
      await profileBox.put(defaultProfile2.id, defaultProfile2);
    }
  }
}
