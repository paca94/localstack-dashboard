import 'package:cloud_dashboard_client/src/profiles/widgets/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DestinationInfo {
  final Icon icon;
  final Icon selectedIcon;
  final Widget label;
  final String routeName;

  DestinationInfo({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.routeName,
  });
}

final destinationProvider = Provider((_) => [
      DestinationInfo(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: const Text('Home'),
        routeName: "/",
      ),
      DestinationInfo(
        icon: const Icon(Icons.bookmark_border),
        selectedIcon: const Icon(Icons.book),
        label: const Text('SQS'),
        routeName: "/aws/sqs",
      ),
      DestinationInfo(
        icon: const Icon(Icons.table_chart),
        selectedIcon: const Icon(Icons.table_chart_outlined),
        label: const Text('DynamoDB'),
        routeName: "/aws/dynamodb",
      ),
    ]);

final navigationProvider = StateProvider((_) => 0);

class RootLayout extends HookConsumerWidget {
  final Widget child;

  const RootLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final int selectedIndex = ref.watch(navigationProvider);
    final destinations = ref.watch(destinationProvider);
    return Scaffold(
      body: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ProfileButton(),
              Expanded(
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (int index) {
                    ref.read(navigationProvider.state).state = index;
                    final destination = destinations[index];
                    context.go(destination.routeName);
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: destinations
                      .map(
                        (DestinationInfo e) => NavigationRailDestination(
                          icon: e.icon,
                          selectedIcon: e.selectedIcon,
                          label: e.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
