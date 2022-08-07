import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/enums.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_controller_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

// purpose: when close widget, clear state
final disposeProvider = Provider.autoDispose((ref) {
  ref.onDispose(() {
    ref.read(queueUrlInputProvider.state).state = "";
    ref.read(checkboxForUseExistProfileProvider.state).state = true;
    ref.read(selectedProfileProvider.state).state = null;
    ref.read(singleUseProfileProvider.state).state = null;
    ref.read(queueAttachTestStateProvider.state).state = null;
    ref.read(queueAttachErrorProvider.state).state = null;
  });
  return null;
});

final queueUrlInputProvider = StateProvider((ref) => "");
final checkboxForUseExistProfileProvider = StateProvider<bool>((ref) => true);
final selectedProfileProvider = StateProvider<ModelProfile?>((ref) => null);
final singleUseProfileProvider = StateProvider<ModelProfile?>((ref) => null);

final queueAttachTestStateProvider =
    StateProvider<FutureActionEnum?>((ref) => null);
final queueAttachErrorProvider = StateProvider<String?>((ref) => null);

final queueAttachTestFutureProvider = FutureProvider<bool?>((ref) async {
  final queueUrl = ref.read(queueUrlInputProvider);
  if (queueUrl.isEmpty) return null;
  final isExistProfileUse = ref.read(checkboxForUseExistProfileProvider);
  late final ModelProfile selectProfile;
  if (isExistProfileUse) {
    selectProfile = ref.read(selectedProfileProvider)!;
  } else {
    selectProfile = ref.read(singleUseProfileProvider)!;
  }

  final SQS sqs = SQS(
    endpointUrl: selectProfile.endpointUrl,
    region: selectProfile.region,
    credentials: AwsClientCredentials(
        secretKey: selectProfile.accessKey,
        accessKey: selectProfile.secretAccessKey),
  );
  final GetQueueAttributesResult readResult = await sqs.getQueueAttributes(
      queueUrl: queueUrl, attributeNames: [QueueAttributeName.all]);
  return readResult.attributes != null;
});

class SqsAttachDialogContent extends HookConsumerWidget {
  const SqsAttachDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    ref.watch(disposeProvider);
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
    final connectionTestResult = ref.watch(queueAttachTestStateProvider);
    return TextButton(
      onPressed: connectionTestResult == FutureActionEnum.success
          ? () async {
              final queueUrl = ref.read(queueUrlInputProvider);

              final isExistProfileUse =
                  ref.read(checkboxForUseExistProfileProvider);
              final controller = ref.read(sqsAttachControllerProvider);

              try {
                if (isExistProfileUse) {
                  final ModelProfile currentProfile =
                      ref.read(selectedProfileProvider)!;
                  await controller.attachQueueForPermanentUserProfile(
                      profile: currentProfile, queueUrl: queueUrl);
                } else {
                  final ModelProfile currentProfile =
                      ref.read(singleUseProfileProvider)!;
                  await controller.attachQueueForSingleUseProfile(
                      accessKey: currentProfile.accessKey,
                      secretAccessKey: currentProfile.secretAccessKey,
                      region: currentProfile.region,
                      queueUrl: queueUrl);
                }
                ref.refresh(sqsAttachListRefreshProvider);
                Navigator.of(context).pop(true);
              } catch (e) {
                ref.read(queueAttachTestStateProvider.state).state =
                    FutureActionEnum.fail;
                ref.read(queueAttachErrorProvider.state).state =
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
        ref.read(queueUrlInputProvider.state).state = newUrl;
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
          value: ref.watch(checkboxForUseExistProfileProvider),
          onChanged: (bool? value) {
            ref.read(checkboxForUseExistProfileProvider.state).state = value!;
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
    final isUseExistProfile = ref.watch(checkboxForUseExistProfileProvider);
    final selectedProfile = ref.watch(selectedProfileProvider);
    if (isUseExistProfile) {
      return DropdownButton<ModelProfile>(
        value: selectedProfile,
        items: [
          ...profileController.profiles.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e.alias),
              ),
            ),
          )
        ],
        onChanged: (ModelProfile? newValue) {
          ref.read(selectedProfileProvider.state).state = newValue!;
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
    final isUseExistProfile = ref.watch(checkboxForUseExistProfileProvider);
    if (!isUseExistProfile) {
      return const Text("??");
    }
    return Container();
  }
}

class _AttachQueueConnectTest extends HookConsumerWidget {
  const _AttachQueueConnectTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAttachTest = ref.watch(queueAttachTestStateProvider);
    ref.listen(
      queueAttachTestFutureProvider,
      (previous, next) {
        if (next is AsyncLoading) {
          ref.read(queueAttachTestStateProvider.state).state =
              FutureActionEnum.loading;
          return;
        }
        if (next is AsyncData) {
          if (next.value == null) {
            ref.read(queueAttachTestStateProvider.state).state = null;
            // ref.read(queueAttachTestStateProvider.state).state =
            //     FutureActionEnum.fail;
            // ref.read(queueAttachTestErrorProvider.state).state = "Require Url";
          } else {
            ref.read(queueAttachTestStateProvider.state).state =
                FutureActionEnum.success;
          }
        }

        if (next is AsyncError) {
          ref.read(queueAttachTestStateProvider.state).state =
              FutureActionEnum.fail;
          ref.read(queueAttachErrorProvider.state).state = '${next.error}';
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
              ref.refresh(queueAttachTestFutureProvider);
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
    final testState = ref.watch(queueAttachTestStateProvider);
    final queueAttachError = ref.read(queueAttachErrorProvider);
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
