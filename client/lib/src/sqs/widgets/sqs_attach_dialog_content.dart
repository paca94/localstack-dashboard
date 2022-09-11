import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/enums.dart';
import 'package:cloud_dashboard_client/src/logger.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_attach_controller_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

/// use providers
/// profileControllerProvider
///   When adding sqs, the purpose of adding a
///   temporary profile or using an existing profile.
///
/// sqsAttachControllerProvider
///   Added sqs management use.
///
/// sqsAttachListRefreshProvider
///   When sqs is added, the purpose of refreshing the list.
///

// purpose: when close widget, clear state
final _disposeProvider = Provider.autoDispose((ref) {
  ref.onDispose(() {
    ref
        .read(_queueUrlInputProvider.state)
        .state = "";
    ref
        .read(_checkboxForUseExistProfileProvider.state)
        .state = true;
    ref
        .read(_selectedProfileProvider.state)
        .state = null;
    ref
        .read(_singleUseProfileProvider.state)
        .state = null;
    ref
        .read(_queueAttachTestStateProvider.state)
        .state = null;
    ref
        .read(_queueAttachErrorProvider.state)
        .state = null;

    /// single use profile
    ref
        .read(_awsOrEtcProvider.state)
        .state = "AWS";
    ref
        .read(_notExistProfileEndpointUrlProvider.state)
        .state = null;
    ref
        .read(_notExistProfileAccessKeyProvider.state)
        .state = null;
    ref
        .read(_notExistProfileSecretAccessKeyProvider.state)
        .state = null;
    ref
        .read(_notExistProfileForAWSRegionProvider.state)
        .state = "us-east-1";
    ref
        .read(_notExistProfileForEtcRegionProvider.state)
        .state = null;
  });
  return null;
});

final _queueUrlInputProvider = StateProvider((ref) => "");
final _checkboxForUseExistProfileProvider = StateProvider<bool>((ref) => true);
final _selectedProfileProvider = StateProvider<ModelProfile?>((ref) => null);
final _singleUseProfileProvider = StateProvider<ModelProfile?>((ref) => null);

final _queueAttachTestStateProvider =
StateProvider<FutureActionEnum?>((ref) => null);
final _queueAttachErrorProvider = StateProvider<String?>((ref) => null);

/// _SingleUseProfileSelect
final _awsOrEtcProvider = StateProvider<String>((ref) => "AWS");
final _notExistProfileEndpointUrlProvider =
StateProvider<String?>((ref) => null);
final _notExistProfileAccessKeyProvider = StateProvider<String?>((ref) => null);
final _notExistProfileSecretAccessKeyProvider =
StateProvider<String?>((ref) => null);
final _notExistProfileForEtcRegionProvider =
StateProvider<String?>((ref) => null);
final _notExistProfileForAWSRegionProvider =
StateProvider<String?>((ref) => "us-east-1");

/// _AttachQueueConnectTest
final _queueAttachTestFutureProvider = FutureProvider<bool?>((ref) async {
  final queueUrl = ref.read(_queueUrlInputProvider);
  if (queueUrl.isEmpty) return null;
  final isExistProfileUse = ref.read(_checkboxForUseExistProfileProvider);
  late final ModelProfile selectProfile;
  if (isExistProfileUse) {
    selectProfile = ref.read(_selectedProfileProvider)!;
  } else {
    final awsOrEtc = ref.read(_awsOrEtcProvider);
    selectProfile = ModelProfile.forSingleUse(
      endpointUrl: ref.read(_notExistProfileEndpointUrlProvider),
      accessKey: ref.read(_notExistProfileAccessKeyProvider) ?? "",
      secretAccessKey: ref.read(_notExistProfileSecretAccessKeyProvider) ?? "",
      region: awsOrEtc == "AWS"
          ? ref.read(_notExistProfileForAWSRegionProvider) ?? ""
          : ref.read(_notExistProfileForEtcRegionProvider) ?? "",
    );
    Future.delayed(Duration.zero, () {
      ref
          .read(_singleUseProfileProvider.state)
          .state = selectProfile;
    });
  }

  final SQS sqs = SQS(
    endpointUrl: selectProfile.endpointUrl,
    region: selectProfile.region,
    credentials: AwsClientCredentials(
        accessKey: selectProfile.accessKey,
        secretKey: selectProfile.secretAccessKey),
  );
  final GetQueueAttributesResult readResult = await sqs.getQueueAttributes(
      queueUrl: queueUrl, attributeNames: [QueueAttributeName.all]);
  return readResult.attributes != null;
});

class SqsAttachDialogContent extends HookConsumerWidget {
  const SqsAttachDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    ref.watch(_disposeProvider);
    return SizedBox(
      width: size.width / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("Attach Dialog"),
          // exist profile use checker
          _UseExistProfile(),
          _ExistProfileSelect(),
          _SingleUseProfileSelect(),

          _QueueUrlInput(),
          _AttachQueueConnectTest(),
          _AttachQueueConnectFailReason(),
        ],
      ),
    );
  }
}

class SqsAttachDialogOkButton extends HookConsumerWidget {
  const SqsAttachDialogOkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionTestResult = ref.watch(_queueAttachTestStateProvider);
    return TextButton(
      onPressed: connectionTestResult == FutureActionEnum.success
          ? () async {
        final queueUrl = ref.read(_queueUrlInputProvider);

        final isExistProfileUse =
        ref.read(_checkboxForUseExistProfileProvider);
        final controller = ref.read(sqsAttachControllerProvider);

        try {
          if (isExistProfileUse) {
            final ModelProfile currentProfile =
            ref.read(_selectedProfileProvider)!;
            await controller.attachQueueForPermanentUserProfile(
                profile: currentProfile, queueUrl: queueUrl);
          } else {
            final ModelProfile currentProfile =
            ref.read(_singleUseProfileProvider)!;
            await controller.attachQueueForSingleUseProfile(
                profileType: currentProfile.profileType,
                accessKey: currentProfile.accessKey,
                secretAccessKey: currentProfile.secretAccessKey,
                region: currentProfile.region,
                queueUrl: queueUrl);
          }
          ref.refresh(sqsAttachListRefreshProvider);
          Navigator.of(context).pop(true);
        } catch (e, stack) {
          ref
              .read(_queueAttachTestStateProvider.state)
              .state =
              FutureActionEnum.fail;
          ref
              .read(_queueAttachErrorProvider.state)
              .state =
          'Duplicated QueueUrl!';
        }
      }
          : null,
      child: const Text('Ok'),
    );
  }
}

class _QueueUrlInput extends HookConsumerWidget {
  const _QueueUrlInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: const InputDecoration(
          hintText:
          "https://sqs.ap-northeast-2.amazonaws.com/{account_id}/{quque_name}",
          labelText: 'Queue Url'),
      onChanged: (String newUrl) {
        ref
            .read(_queueUrlInputProvider.state)
            .state = newUrl;
      },
    );
  }
}

class _UseExistProfile extends HookConsumerWidget {
  const _UseExistProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          value: ref.watch(_checkboxForUseExistProfileProvider),
          onChanged: (bool? value) {
            ref
                .read(_checkboxForUseExistProfileProvider.state)
                .state = value!;
          },
        ),
        const Text("Use Exist Profile"),
      ],
    );
  }
}

class _ExistProfileSelect extends HookConsumerWidget {
  const _ExistProfileSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileController = ref.watch(profileControllerProvider);
    final isUseExistProfile = ref.watch(_checkboxForUseExistProfileProvider);
    final selectedProfile = ref.watch(_selectedProfileProvider);
    if (isUseExistProfile) {
      return DropdownButton<ModelProfile>(
        value: selectedProfile,
        items: [
          ...profileController.profiles.map(
                (e) =>
                DropdownMenuItem(
                  value: e,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.alias),
                  ),
                ),
          )
        ],
        onChanged: (ModelProfile? newValue) {
          ref
              .read(_selectedProfileProvider.state)
              .state = newValue!;
        },
      );
    }
    return Container();
  }
}

class _SingleUseProfileSelect extends HookConsumerWidget {
  const _SingleUseProfileSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUseExistProfile = ref.watch(_checkboxForUseExistProfileProvider);
    final awsOrEtc = ref.watch(_awsOrEtcProvider);
    if (!isUseExistProfile) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: "AWS",
                    groupValue: awsOrEtc,
                    onChanged: (v) {
                      ref
                          .read(_awsOrEtcProvider.state)
                          .state = v!;
                    },
                  ),
                  const Text("AWS"),
                  Radio<String>(
                    value: "ETC",
                    groupValue: awsOrEtc,
                    onChanged: (v) {
                      ref
                          .read(_awsOrEtcProvider.state)
                          .state = v!;
                    },
                  ),
                  const Text("ETC"),
                ],
              ),
              // endpoint
              if (awsOrEtc == "ETC")
                TextField(
                  decoration: const InputDecoration(labelText: 'Endpoint Url'),
                  onChanged: (String newUrl) {
                    ref
                        .read(_notExistProfileEndpointUrlProvider.state)
                        .state =
                        newUrl;
                  },
                ),
              // access
              TextField(
                decoration: const InputDecoration(labelText: 'AccessKey'),
                onChanged: (String newValue) {
                  ref
                      .read(_notExistProfileAccessKeyProvider.state)
                      .state =
                      newValue;
                },
              ),
              // secret
              TextField(
                decoration: const InputDecoration(labelText: 'SecretAccessKey'),
                onChanged: (String newValue) {
                  ref
                      .read(_notExistProfileSecretAccessKeyProvider.state)
                      .state = newValue;
                },
              ),
              // region
              awsOrEtc == "ETC"
                  ? TextField(
                decoration: const InputDecoration(labelText: 'Region'),
                onChanged: (String newValue) {
                  ref
                      .read(_notExistProfileForEtcRegionProvider.state)
                      .state = newValue;
                },
                controller: TextEditingController(
                    text:
                    ref.watch(_notExistProfileForEtcRegionProvider)),
              )
                  : Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Region"),
                  ),
                  DropdownButton<String>(
                    value:
                    ref.watch(_notExistProfileForAWSRegionProvider),
                    items: [
                      "us-east-1",
                      "ap-northeast-2",
                    ]
                        .map(
                          (e) =>
                          DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                    )
                        .toList(),
                    onChanged: (value) {
                      ref
                          .read(
                          _notExistProfileForAWSRegionProvider.state)
                          .state = value;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}

class _AttachQueueConnectTest extends HookConsumerWidget {
  const _AttachQueueConnectTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAttachTest = ref.watch(_queueAttachTestStateProvider);
    ref.listen(
      _queueAttachTestFutureProvider,
          (previous, next) {
        if (next is AsyncLoading) {
          ref
              .read(_queueAttachTestStateProvider.state)
              .state =
              FutureActionEnum.loading;
          return;
        }
        if (next is AsyncData) {
          if (next.value == null) {
            ref
                .read(_queueAttachTestStateProvider.state)
                .state = null;
          } else {
            ref
                .read(_queueAttachTestStateProvider.state)
                .state =
                FutureActionEnum.success;
          }
        }

        if (next is AsyncError) {
          logger.e(next);
          ref
              .read(_queueAttachTestStateProvider.state)
              .state =
              FutureActionEnum.fail;
          ref
              .read(_queueAttachErrorProvider.state)
              .state = '${next.error}';
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CardButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Connection Test'),
                buildButtonAppend(queueAttachTest),
              ],
            ),
            onTap: () {
              if (queueAttachTest == FutureActionEnum.loading) return;
              ref.refresh(_queueAttachTestFutureProvider);
            },
          ),
        ],
      ),
    );
  }

  buildButtonAppend(queueAttachTest) {
    Widget? item;
    if (queueAttachTest == FutureActionEnum.loading) {
      item = const CupertinoActivityIndicator();
    }
    if (queueAttachTest == FutureActionEnum.fail) {
      item = const Icon(Icons.close);
    }
    if (queueAttachTest == FutureActionEnum.success) {
      item = const Icon(Icons.check);
    }
    return Container(
      padding: item != null ? const EdgeInsets.fromLTRB(4, 0, 4, 0) : null,
      width: item != null ? 32 : 0,
      height: 32,
      child: item,
    );
  }
}

class _AttachQueueConnectFailReason extends HookConsumerWidget {
  const _AttachQueueConnectFailReason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(_queueAttachTestStateProvider);
    final queueAttachError = ref.read(_queueAttachErrorProvider);
    return RemoveFoldWidget(
      expand: testState == FutureActionEnum.fail,
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Error: $queueAttachError",
          ),
        ),
      ),
    );
  }
}

class RemoveFoldWidget extends StatefulWidget {
  final bool expand;
  final Widget child;

  const RemoveFoldWidget({Key? key, required this.expand, required this.child})
      : super(key: key);

  @override
  State<RemoveFoldWidget> createState() => _RemoveFoldWidgetState();
}

class _RemoveFoldWidgetState extends State<RemoveFoldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(RemoveFoldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: animation,
      child: widget.child,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }
}
