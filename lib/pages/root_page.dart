import 'package:bloc_examples/router/extension.dart';
import 'package:bloc_examples/router/routes.dart';
import 'package:bloc_examples/widgets/base_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  RootPage({super.key});

  final pages = {
    'Basic Bloc': RoutePath.counter,
  };

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'BLoC Examples',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemBuilder: (_, i) {
            final entriesList = pages.entries.toList();
            final title = entriesList[i].key;
            final route = entriesList[i].value;

            return MaterialButton(
              child: Text(title),
              onPressed: () {
                context.push(route);
              },
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
          itemCount: pages.length,
        ),
      ),
    );
  }
}
