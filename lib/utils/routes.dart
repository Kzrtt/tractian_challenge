import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tractian_challenge/screens/assetsScreen.dart';
import 'package:tractian_challenge/screens/homeScreen.dart';

final routes = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: "/assets/:companyId",
      builder: (context, state) {
        return AssetsScreen(companyId: state.pathParameters['companyId'].toString());
      },
    )
  ],
);
