import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/database/db_provider.dart';
import 'package:localstack_dashboard_client/src/profiles/widgets/profile_button.dart';
import 'package:localstack_dashboard_client/src/screens/dynamodb.dart';

import 'color_schemes.g.dart';
import 'src/screens/home.dart';
import 'src/screens/sqs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final dbService = DatabaseService();
  await dbService.init();

  runApp(ProviderScope(overrides: [
    databaseService.overrideWithValue(dbService),
  ], child: const MyApp()));
}

class DestinationInfo {
  final Icon icon;
  final Icon selectedIcon;
  final Widget label;
  final Widget screen;

  DestinationInfo(
      {required this.icon,
      required this.selectedIcon,
      required this.label,
      required this.screen});
}

final destinationProvider = Provider((_) => [
      DestinationInfo(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: const Text('Home'),
        screen: const Home(),
      ),
      DestinationInfo(
        icon: const Icon(Icons.bookmark_border),
        selectedIcon: const Icon(Icons.book),
        label: const Text('SQS'),
        screen: const Sqs(),
      ),
      DestinationInfo(
        icon: const Icon(Icons.table_chart),
        selectedIcon: const Icon(Icons.table_chart_outlined),
        label: const Text('DynamoDB'),
        screen: const DynamoDBScreen(),
      ),
    ]);
final navigationProvider = StateProvider((_) => 0);

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(navigationProvider);
    final destinations = ref.watch(destinationProvider);
    return MaterialApp(
      title: 'LocalStack Dashboard',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: buildAfterLoading(ref, selectedIndex, destinations),
      ),
    );
  }

  Row buildAfterLoading(
      WidgetRef ref, int selectedIndex, List<DestinationInfo> destinations) {
    return Row(
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
          child: destinations[selectedIndex].screen,
        )
      ],
    );
  }
}
