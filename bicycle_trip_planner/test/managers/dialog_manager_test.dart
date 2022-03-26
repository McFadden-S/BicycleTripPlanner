// import 'package:bicycle_trip_planner/models/station.dart';
// import 'package:test/test.dart';
// import 'package:bicycle_trip_planner/managers/DialogManager.dart';
//
// main(){
//   final dialogManager = DialogManager();
//   test('ensure can set binary choice', (){
//     dialogManager.setBinaryChoice("hi", "hi", (){return "hi";}, "hi", (){return "hi";});
//     expect(dialogManager.getChoicePrompt(), "hi");
//     expect(dialogManager.getOptionOneText(), "hi");
//     expect(dialogManager.getOptionTwoText(), "hi");
//     expect(dialogManager.getOptionOneFunction().toString(), (){return "hi";}.toString());
//     expect(dialogManager.getOptionTwoFunction().toString(), (){return "hi";}.toString());
//   });
//
//   test('ensure end route dialogue is correct', (){
//     dialogManager.setEndOfRouteDialog();
//     expect(dialogManager.getEndOfRouteDialogText(), "You have reached your destination!");
//     expect(dialogManager.getOkButtonText(), "Ok");
//     expect(dialogManager.getEndOfRouteFunction().toString(), (){dialogManager.clearEndOfRouteDialog();}.toString());
//   });
//
//   //PLEASE CHECK DIALOG MANAGER IF I CORRECTED THE REPETITION IN THE RIGHT ORDER FOR GETTOOGLETEXT AND TOGGLEDIALOGTEXT
//   test('ensure walk bike toggle dialogue is correct', (){
//     dialogManager.setWalkBikeToggle();
//     expect(dialogManager.getWalkBikeToggleText(), "Toggle between walking and biking?");
//     expect(dialogManager.getWalkBikeToggleDialogText(), "Toggle");
//   });
//
//   test('ensure can show and clear toggle dialog', (){
//     dialogManager.showWalkBikeToggleDialog();
//     expect(dialogManager.ifShowingWalkBikeToggleDialog(), true);
//     dialogManager.clearWalkBikeToggleDialog();
//     expect(dialogManager.ifShowingWalkBikeToggleDialog(), false);
//   });
//
//   test('ensure can show and clear end of route dialog', (){
//     dialogManager.showEndOfRouteDialog();
//     expect(dialogManager.ifShowingEndOfRouteDialog(), true);
//     dialogManager.clearEndOfRouteDialog();
//     expect(dialogManager.ifShowingEndOfRouteDialog(), false);
//   });
//
//   test('ensure can show and clear binary choice', (){
//     dialogManager.showBinaryChoice();
//     expect(dialogManager.ifShowingBinaryChoice(), true);
//     dialogManager.clearBinaryChoice();
//     expect(dialogManager.ifShowingBinaryChoice(), false);
//   });
//
//   test('ensure can set a selected station', (){
//     final station = Station(id: 1, name: 'Holborn Station', lat: 0.0, lng: 0.0, bikes: 10, emptyDocks: 2, totalDocks: 8);
//     dialogManager.setSelectedStation(station);
//     expect(dialogManager.getSelectedStation().name, "Holborn Station");
//   });
//
//   test('ensure can show and clear selected station', (){
//     dialogManager.showSelectedStation();
//     expect(dialogManager.ifShowingSelectStation(), true);
//     dialogManager.clearSelectedStation();
//     expect(dialogManager.ifShowingSelectStation(), false);
//   });
//
// }
