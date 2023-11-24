# Counter

This is an example for the infamous Flutter's default project, remade
with using BLoC. It's a good example to learn the basic features of BLoC.

By default, Bloc consists of three parts: Bloc itself, Events and States.

- Events: are the objects that we send to the Bloc that notify it about an
  event that has occurred in the app that it needs to react to. Usually
  it consists of a base Event class that is used as a first type parameter
  of its Bloc, and a list of implementations that define different kinds of
  events this Bloc reacts to. These may contain extra data to elaborate a 
  particular event, e.g. a number by which we should increase the displayed
  one.
- States: are objects that define what state should the app have, usually
  (not necessarily always) as a reaction to the obtained event. States can
  be represented as a singular class with a bunch of data, or a number of
  classes extending the base State, each representing their own particular
  state of the app. The second option is preferable for complex flows that
  contain multiple subpages within the same route, as you can specify this
  cross-subpage "navigation" inside the Bloc and only leave the UI to just
  map the necessary subpage widgets to specific states. The first option is
  good for "data-blocs" and simple request pages - that just show the data
  returned by one or multiple related backend API responses.
- Bloc: the class that actually reacting to the events and giving out states.
  It can house the data repositories to conceal them from UI, contain the
  business logic of the app, and in general might be used to describe the
  actual structure of a page or flow without writing the UI itself.


The basic structure of a Bloc:

```dart
// --- mybloc.dart ---

// Definition of Bloc class. It is parametrized with the 
// basic types of events and states, with which it works.
class MyBloc extends Bloc<MyEvent, MyState> {
  // super constructor specifies the initial state of the
  // app.
  CounterBloc() : super(const MyState()) {
    // List of callbacks that define the reactions to
    // events and providing a function to emit the new
    // states.
    on<MyParticularEvent>((event, emit) {
      // ... some logic...
      
      // Emitting the new state
      emit(MyState());
    });
    // Callbacks can be asynchronous, to house async
    // operations, e.g. backend requests.
    // Important note(!) `emit` is tightly bound to the
    // callback and can only be run within it. This means
    // that you cannot run some unawaited async function
    // and emit a state inside its `then()` potentially
    // after the callback itself has finished. In such case
    // the library will throw out an error.
    on<MyOtherEvent>((event, emit) async {
      // ... some async logic...

      // Emitting the new state
      emit(MyState());
    });
  }
}


// --- myevent.dart ---

// Base event of the Bloc, used as a type parameter for it.
abstract class MyEvent {}

// Different event classes that describe events it should 
// react to.
class MyParticularEvent extends MyEvent {}

// Events may contain some data to elaborate the details of
// an event. These can be retrieved in the `on` callback.
class MyOtherEvent extends MyEvent {
  final int userId;
  
  const MyOtherEvent(this.userId);
}

// --- myevent.dart ---

// Base state of the Bloc,used as a type parameter for it.
// May also be declared abstract and have several subclasses
// if you want to segregate the types like that (don't,
// unless necessary).
class MyState {}

```

Different widgets that are commonly used with Bloc, from `flutter_blox`
package:

- `BlocProvider<B>` - a provider inherited widget, that places
  the bloc into widget subtree, where the next classes can fetch the bloc
  object from. It can either create the blocs with `create` constructor or
  pass existing ones into another widget subtree (e.g. new route) via `value`
  constructor.

_(all the next widgets can either use a bloc from the widget subtree by
reaching to BlocProvider or can access an actual Bloc object directly into `bloc`
field)_

- `BlocBuilder<B, S>` - a widget that runs a builder function returning a widget,
  depending on the state it received. Usually should only wrap the actual widgets
  that change something depending on the state, to avoid unnecessary rebuilds.

- `BlocListener<B, S>` - a widget that runs simple void callbacks depending on the
  state it received. Usually used to display dialogs, snackbars, etc. DO NOT, please,
  use `setState(() {...})` there - it's cringe, and you got BlocBuilder for that!

- `BlocConsumer<B, S>` - a widget that combines in itself the features of both
  BlocBuilder and BlocListener at the same time.

___

In this example we have remade the default counter project to make use of BLoC.

For that we created a bloc with a single `CounterIncrementEvent` that is sent
whenever we press the "+" FloatingActionButton. We add the events into the bloc
by calling its `add()` method. The bloc itself can be retrieved from the current
widget subtree by using `of()` method, parametrized with the type of desired Bloc.
```dart
// lib/pages/example_counter/page.dart 43-46
floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<CounterBloc>(context).add(CounterIncrementEvent());
        },
```

Inside the Bloc we created a callback to this event, where we take the integer value
within the current state, increment it and emit the state with the new value.
The state of the bloc can be retrieved using `state` getter, and because we use the
base State type, without breaking it down into multiple subclasses, we don't need to
do any type checks.
```dart
// lib/pages/example_counter/counter_bloc/counter_bloc.dart 10-12
    on<CounterIncrementEvent>((event, emit) {
      emit(CounterState(state.value + 1));
    });
```

Back in the UI, our page now already contains a `BlocBuilder`, which listens to the
incoming states from the Bloc, and builds the UI accordingly. `builder` parameter of
BlocBuilder provides us with state which we can check to decide what to draw in the UI.
In this case - we just take the integer value from the state and put it into Text.
Notice, how it only wraps the actual text of the number - because it's the only thing 
that is supposed to change when we press the button. It's recommended to only wrap the
widgets that need to actually be changed, because redrawing one single text requires 
much less resources  than redrawing an entire page for no reason.
```dart
// lib/pages/example_counter/page.dart 32-39
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  state.value.toString(),
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),
```