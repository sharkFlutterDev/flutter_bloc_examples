import 'package:bloc_examples/pages/example_counter/counter_bloc/counter_bloc.dart';
import 'package:bloc_examples/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExampleCounterBlocWrapper extends StatelessWidget {
  const ExampleCounterBlocWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const ExampleCounter(),
    );
  }
}

class ExampleCounter extends StatelessWidget {
  const ExampleCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Counter',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  state.value.toString(),
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<CounterBloc>(context).add(CounterIncrementEvent());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
