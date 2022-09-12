import 'package:cloud_dashboard_client/src/router/root_layout.dart';
import 'package:cloud_dashboard_client/src/screens/dynamodb.dart';
import 'package:cloud_dashboard_client/src/screens/home.dart';
import 'package:cloud_dashboard_client/src/screens/sqs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

materialPage(Widget child) {
  return MaterialPage<void>(
    key: _pageKey,
    child: RootLayout(
      key: _scaffoldKey,
      child: child,
    ),
  );
}

final GoRouter appRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return materialPage(const Home());
      },
    ),
    GoRoute(
      path: '/aws/sqs',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return materialPage(const Sqs());
      },
    ),
    GoRoute(
      path: '/aws/dynamodb',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return materialPage(const DynamoDBScreen());
      },
    ),
  ],
);
