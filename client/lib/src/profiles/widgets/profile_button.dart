import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';

class ProfileButton extends HookConsumerWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerProvider);
    return PopupMenuButton(
      tooltip: "Show Profiles",
      onSelected: (ModelProfile value) {
        profileController.changeProfile(value);
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<ModelProfile>>[
          ...profileController.profiles.map(
            (e) => PopupMenuItem<ModelProfile>(
              value: e,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 0),
                    child: e.isSelect
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                  ),
                  Text(e.alias),
                ],
              ),
            ),
          )
        ];
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.people),
      ),
    );
  }
}
