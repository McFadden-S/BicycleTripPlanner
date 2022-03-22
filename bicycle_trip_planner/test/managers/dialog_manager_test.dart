import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';

main(){
  final dialogManager = DialogManager();
  test('ensure can set binary choice', (){
    dialogManager.setBinaryChoice("hi", "hi", (){return "hi";}, "hi", (){return "hi";});
    expect(dialogManager.getChoicePrompt(), "hi");
    expect(dialogManager.getOptionOneText(), "hi");
    expect(dialogManager.getOptionTwoText(), "hi");
    expect(dialogManager.getOptionOneFunction().toString(), (){return "hi";}.toString());
    expect(dialogManager.getOptionTwoFunction().toString(), (){return "hi";}.toString());
  });

  test('ensure end route dialogue is correct', (){
    dialogManager.setEndOfRouteDialog();
    expect(dialogManager.getEndOfRouteDialogText(), "You have reached your destination!");
    expect(dialogManager.getOkButtonText(), "Ok");
    expect(dialogManager.getEndOfRouteFunction().toString(), (){dialogManager.clearEndOfRouteDialog();}.toString());
  });

  test('ensure walk bike toggle dialogue is correct', (){
    dialogManager.setWalkBikeToggle();
    expect(dialogManager.getWalkBikeToggleText(), "Toggle between walking and biking?");
    expect(dialogManager.getWalkBikeToggleDialogText(), "Toggle");
  });



}
