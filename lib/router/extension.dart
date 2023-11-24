import 'package:bloc_examples/router/routes.dart';
import 'package:flutter/material.dart';

extension NavigatableBuildContext on BuildContext {
  Future<T?> push<T extends Object?>(RoutePath path, {Object? arguments}) {
    return Navigator.of(this).pushNamed(path.route, arguments: arguments);
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}