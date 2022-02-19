import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

buildMyApp() {
  return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: const MyApp()
  );
}


void main() {
  testWidgets('Navigation has home', (WidgetTester tester) async {
    await tester.pumpWidget(buildMyApp());

    expect(find.text('Home'), findsOneWidget);

  });
}