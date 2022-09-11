import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:cloud_dashboard_client/src/profiles/widgets/profile_setting_dialog.dart';

class ProfileButton extends HookConsumerWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerProvider);
    return PopupMenuButton(
      tooltip: "Show Profiles",
      onSelected: (Object value) {
        if (value is ModelProfile) {
          profileController.selectProfile(value);
        }

        if (value is String) {
          if (value == "SETTING") {
            showProfileSettingDialog(context);
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Object>>[
          ...profileController.profiles.map(
                (e) =>
                PopupMenuItem<Object>(
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
          ),
          const PopupMenuItem<Object>(
            value: "SETTING",
            child: Center(child: Icon(Icons.settings)),
          ),
        ];
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.people),
      ),
    );
  }
}
