import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

pumpWidget(WidgetTester tester, Widget? home) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ListenableProvider(create: (context) => ApplicationBloc()),
      ],
      builder: (context, child) {
        return MaterialApp(home: home);
      },
    ),
  );
}