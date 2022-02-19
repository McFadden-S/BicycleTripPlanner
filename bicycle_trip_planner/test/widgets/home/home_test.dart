import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


Widget buildWidget(Widget widgetIn){
  return MultiProvider(
    providers: [
      ListenableProvider(create: (context) => ApplicationBloc()),
    ],
    builder: (context, child) {
      return widgetIn;
    },
  );
}


void main() {
  testWidgets('Navigation has home', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget(MyApp()));
    expect(find.text('Home'), findsOneWidget);
  });
}
