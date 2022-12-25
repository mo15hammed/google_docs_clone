import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AppRouter {
  static final loggedOutRoute = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: LoginScreen()),
  });

  static final loggedInRoute = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: HomeScreen()),
  });
}
