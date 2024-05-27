import 'dart:convert';

import 'package:app1/model/give.dart';
import 'package:app1/page/drink.dart';
import 'package:app1/page/home.dart';
import 'package:app1/page/search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Home();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'list',
          builder: (BuildContext context, GoRouterState state) {
            return const BebidasLink();
          },
        ),
        GoRoute(
          path: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPage();
          },
        )
      ],
    ),
  ],
);
