import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/main.dart';
import 'package:inspired_senior_care_app/view/pages/categories.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard.dart';
import 'package:inspired_senior_care_app/view/pages/deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/profile.dart';
import 'package:inspired_senior_care_app/view/pages/view_member.dart';

class MyRouter {
  late final router = GoRouter(
      initialLocation: '/',
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      // errorPageBuilder: ,
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const MyHomePage()),
        ),
        GoRoute(
          name: 'categories',
          path: '/categories',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: Categories()),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Profile()),
        ),
        GoRoute(
          name: 'dashboard',
          path: '/dashboard',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Dashboard()),
        ),
        GoRoute(
          name: 'view-member',
          path: '/view-member',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const ViewMember()),
        ),
        GoRoute(
          name: 'deck-page',
          path: '/deck-page',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const DeckPage()),
        ),
      ]);
}
