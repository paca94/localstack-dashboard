import 'package:cloud_dashboard_client/src/common/enums.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';
import 'package:cloud_dashboard_client/src/widgets/scrollable_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _appendProfileProvider = StateProvider<ModelProfile?>((ref) => null);

final _profilesProvider = StateProvider<List<ModelProfile>>((ref) {
  final profileController = ref.watch(profileControllerProvider);
  final profileProvider = ref.watch(_appendProfileProvider);
  final items = [
    ...profileController.profiles,
  ];
  if (profileProvider != null) {
    items.add(profileProvider);
  }
  return items;
});

final _currentViewProfileIdxProvider = StateProvider<int>((ref) {
  final profiles = ref.read(_profilesProvider);
  return profiles.indexWhere((element) => element.isSelect);
});

final _supportServicesTypesProvider = StateProvider<SupportServiceTypes>((ref) {
  final profiles = ref.read(_profilesProvider);
  if (profiles.isNotEmpty) {
    final currentSelectProfile =
        profiles.firstWhere((element) => element.isSelect);
    return currentSelectProfile.profileType;
  }
  return SupportServiceTypes.other;
});

Future<bool> showProfileSettingDialog(context) async {
  final size = MediaQuery.of(context).size;
  bool? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: size.width * 2 / 3,
          height: size.height * 2 / 3,
          child: const _ProfileSetting(),
        ),
      );
    },
  );
  return result ?? false;
}

class _ProfileSetting extends HookConsumerWidget {
  const _ProfileSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentViewProfileIdx = ref.watch(_currentViewProfileIdxProvider);
    final appendProfile = ref.watch(_appendProfileProvider);
    final profiles = ref.watch(_profilesProvider);
    return Row(
      children: [
        // https://stackoverflow.com/questions/61874835/scrollable-navigation-rail-in-flutter
        // We don't use navigationrail because the number of items must exceed 2.
        // LayoutBuilder(
        //   builder: (layoutContext, constraint) => SingleChildScrollView(
        //     controller: ScrollController(),
        //     child: ConstrainedBox(
        //       constraints: BoxConstraints(minHeight: constraint.maxHeight),
        //       child: IntrinsicHeight(
        //         child: NavigationRail(
        //           onDestinationSelected: (int index) {
        //             ref.read(_currentViewProfileIdxProvider.state).state =
        //                 index;
        //             ref.read(_supportServicesTypesProvider.state).state =
        //                 profiles[index].profileType;
        //           },
        //           selectedIndex: currentViewProfileIdx,
        //           useIndicator: false,
        //           labelType: NavigationRailLabelType.selected,
        //           destinations: [
        //             ...profiles.map(
        //               (e) => NavigationRailDestination(
        //                 icon: Text(e.alias),
        //                 label: const Icon(Icons.check),
        //                 padding: const EdgeInsets.all(8),
        //               ),
        //             ),
        //           ],
        //           leading: IconButton(
        //             icon: const Icon(Icons.add),
        //             onPressed: () {
        //               if (appendProfile != null) return;
        //               ref.read(_appendProfileProvider.state).state =
        //                   ModelProfile.forCreateDefault();
        //             },
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        ScrollableNavigationRail(
          onSelect: (int index) {
            ref.read(_currentViewProfileIdxProvider.state).state = index;
            ref.read(_supportServicesTypesProvider.state).state =
                profiles[index].profileType;
          },
          selectedIndex: currentViewProfileIdx,
          items: [
            ...profiles.map(
              (e) => NavigationRailDestination(
                icon: Text(e.alias),
                label: const Icon(Icons.check),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (appendProfile != null) return;
              ref.read(_appendProfileProvider.state).state =
                  ModelProfile.forCreateDefault();
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ProfileDialogContent(
                    currentViewProfile: profiles[currentViewProfileIdx],
                    isTemp: profiles[currentViewProfileIdx] == appendProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileDialogContent extends HookConsumerWidget {
  final ModelProfile currentViewProfile;
  final bool isTemp;
  late final TextEditingController _aliasController =
      TextEditingController(text: currentViewProfile.alias);
  late final TextEditingController _endpointUrlController =
      TextEditingController(text: currentViewProfile.endpointUrl);
  late final TextEditingController _accessKeyController =
      TextEditingController(text: currentViewProfile.accessKey);
  late final TextEditingController _secretAccessKeyController =
      TextEditingController(text: currentViewProfile.secretAccessKey);
  late final TextEditingController _regionController =
      TextEditingController(text: currentViewProfile.region);

  _ProfileDialogContent({
    Key? key,
    required this.currentViewProfile,
    this.isTemp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportServicesType = ref.watch(_supportServicesTypesProvider);
    final currentViewProfileIdx = ref.watch(_currentViewProfileIdxProvider);
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CardButton(
                child: const Text('Save'),
                onTap: () async {
                  final profileController = ref.read(profileControllerProvider);
                  if (isTemp) {
                    await profileController.addProfile(
                      alias: _aliasController.text,
                      profileType: supportServicesType,
                      endpointUrl:
                          supportServicesType == SupportServiceTypes.aws
                              ? null
                              : _endpointUrlController.text,
                      accessKey: _accessKeyController.text,
                      secretAccessKey: _secretAccessKeyController.text,
                      region: _regionController.text,
                      isSelect: false,
                    );
                  } else {
                    await profileController.updateProfile(
                      ModelProfile.fromExist(
                        id: currentViewProfile.id,
                        alias: _aliasController.text,
                        profileType: supportServicesType,
                        endpointUrl:
                            supportServicesType == SupportServiceTypes.aws
                                ? null
                                : _endpointUrlController.text,
                        accessKey: _accessKeyController.text,
                        secretAccessKey: _secretAccessKeyController.text,
                        region: _regionController.text,
                        isSelect: currentViewProfile.isSelect,
                      ),
                    );
                  }
                  ref.read(_appendProfileProvider.state).state = null;
                  ref.refresh(_profilesProvider);
                },
              ),
              CardButton(
                child: const Text('Delete'),
                onTap: () async {
                  if (isTemp) {
                    ref.read(_appendProfileProvider.state).state = null;
                  } else {
                    await ref
                        .read(profileControllerProvider)
                        .removeProfile(currentViewProfile);
                  }
                  ref.read(_currentViewProfileIdxProvider.state).state =
                      currentViewProfileIdx - 1;
                  ref.refresh(_profilesProvider);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DropdownButton<SupportServiceTypes>(
            value: supportServicesType,
            items: [
              ...SupportServiceTypes.values.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              ),
            ],
            onChanged: (SupportServiceTypes? value) {
              ref.read(_supportServicesTypesProvider.state).state = value!;
            },
          ),
          TextField(
            controller: _aliasController,
            decoration: const InputDecoration(
              labelText: 'Alias',
            ),
          ),
          ...buildContents(supportServicesType),
        ],
      ),
    );
  }

  buildContents(SupportServiceTypes supportServicesType) {
    if (supportServicesType == SupportServiceTypes.empty) {
      return [];
    }
    return [
      if (supportServicesType == SupportServiceTypes.other)
        TextField(
          controller: _endpointUrlController,
          decoration: const InputDecoration(
            labelText: 'Endpoint URL',
          ),
        ),
      TextField(
        controller: _accessKeyController,
        decoration: const InputDecoration(
          labelText: 'Access Key',
        ),
      ),
      TextField(
        controller: _secretAccessKeyController,
        decoration: const InputDecoration(
          labelText: 'Secret Access Key',
        ),
      ),
      TextField(
        controller: _regionController,
        decoration: const InputDecoration(
          labelText: 'Region',
        ),
      ),
    ];
  }
}
