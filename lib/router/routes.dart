import 'package:bloc_examples/pages/example_counter/page.dart';
import 'package:bloc_examples/pages/root_page.dart';
import 'package:flutter/material.dart';


enum RoutePath {
  root('/'),
  counter('/counter');

  final String route;

  const RoutePath(this.route);
}

Map<String, Widget Function(BuildContext)> get appRouter => {
  RoutePath.root.route: (_) => RootPage(),
  RoutePath.counter.route: (_) => const ExampleCounterBlocWrapper(),
};