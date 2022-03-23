
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';

// Class Comment:
// DialogManager is a manager class that creates and updates all of the project's Dialog Boxes

class DialogManager {

  //********** Fields **********

  String _choicePrompt = "";

  String _optionOneText = "";
  Function _optionOneFunction = (){};

  String _optionTwoText = "";
  Function _optionTwoFunction = (){};

  bool _isShowingBinaryChoice = false;

  String _endOfRouteText = "";
  Function _DestinationOkButtonFunction = (){};

  String _okButtonText = "";

  String _walkBikeToggleText = "";

  Function _walkBikeToggleFunction = (){};
  String _walkBikeToggleButtonText = "";

  String _cancelButtonText = "";

  bool _isShowingWalkBikeToggleDialog = false;

  bool _isShowingEndOfRouteDialog = false;

  Station _selectedStation = Station.stationNotFound();

  bool _isShowingSelectStation = false;

  //********** Singleton **********

  static final DialogManager _dialogManager =
  DialogManager._internal();

  // @param void
  // @return DialogManager
  factory DialogManager() {
    return _dialogManager;
  }

  DialogManager._internal();

  //********** Private **********

  //********** Public **********

  // @param void
  // @return Boolean - if Walk/Bike toggle dialog is showing
  bool ifShowingWalkBikeToggleDialog(){
    return _isShowingWalkBikeToggleDialog;
  }

  // @param void
  // @return Boolean - if the Dialog for when the user has reached their destination is showing
  bool ifShowingEndOfRouteDialog(){
    return _isShowingEndOfRouteDialog;
  }

  // @param void
  // @return Boolean - if the Binary Choice dialog is showing
  bool ifShowingBinaryChoice(){
    return _isShowingBinaryChoice;
  }

  // @param void
  // @return Boolean - if the Dialog appear when clicking on a station on the Home screen
  bool ifShowingSelectStation(){
    return _isShowingSelectStation;
  }

  // @param void
  // @return String - the text that should be shown in the Walk/Bike toggle dialog
  String getWalkBikeToggleText() {
    return _walkBikeToggleText;
  }

  // @param void
  // @return String - the text that should be shown in the dialog when the user reaches their destination
  String getEndOfRouteDialogText(){
    return _endOfRouteText;
  }

  // @param void
  // @return Function - the function that should be called when the user clicks the 'Ok' button in the end of route dialog
  Function getEndOfRouteFunction(){
    return _DestinationOkButtonFunction;
  }

  // @param void
  // @return String - the text in the 'Ok' button to be used in dialogs
  String getOkButtonText(){
    return _okButtonText;
  }

  // @param void
  // @return String - the string promt shown to the user in binary choice dialogs
  String getChoicePrompt(){
    return _choicePrompt;
  }

  // @param void
  // @return String - the text for the first option button in a binary choice dialog
  String getOptionOneText(){
    return _optionOneText;
  }

  // @param void
  // @return Function - the function that should be called when the user clicks the option one button
  Function getOptionOneFunction(){
    return _optionOneFunction;
  }

  // @param void
  // @return String - the text for the second option button in a binary choice dialog
  String getOptionTwoText(){
    return _optionTwoText;
  }

  // @param void
  // @return Function - the function that should be called when the user clicks the second option button in a binary choice dialog
  Function getOptionTwoFunction(){
    return _optionTwoFunction;
  }

  // @param void
  // @return String - the text prompt shown to the user in the Walk/Bike dialog
  String getWalkBikeToggleDialogText(){
    return _walkBikeToggleText;
  }

  // @param void
  // @return String - the text for the cancel button used in multiple Dialogs
  String getCancelButtonText(){
    return _cancelButtonText;
  }

  // @param void
  // @return Function - the function that should be called when the 'Toggle' button is clicked on the Walk/Bike toggle dialog
  Function getWalkBikeToggleFunction(){
    return _walkBikeToggleFunction;
  }

  // @param -
  //  choicePrompt - String; choice prompt to show user
  //  optionOneText - String; text for first choice for user
  //  optionOneFunction - Function; function to be called when the user clicks the first option
  //  optionTwoText - String; text for second choice for user
  //  optionTwoFunction - Function; function to be called when the user clicks the second option
  // @return Void
  void setBinaryChoice(choicePrompt, optionOneText, optionOneFunction, optionTwoText, optionTwoFunction){
    _choicePrompt = choicePrompt;
    _optionOneText = optionOneText;
    _optionOneFunction = optionOneFunction;
    _optionTwoText = optionTwoText;
    _optionTwoFunction = optionTwoFunction;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void setEndOfRouteDialog(){
    _endOfRouteText = "You have reached your destination!";
    _okButtonText = "Ok";
    _DestinationOkButtonFunction = (){
      clearEndOfRouteDialog();
    };
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void setWalkBikeToggle(){
    _walkBikeToggleText = "Toggle between walking and biking?";
    _walkBikeToggleButtonText = "Toggle";
    _cancelButtonText = "Cancel";
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void showWalkBikeToggleDialog(){
    _isShowingWalkBikeToggleDialog = true;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void clearWalkBikeToggleDialog(){
    _isShowingWalkBikeToggleDialog = false;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void showEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = true;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void clearEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = false;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void showBinaryChoice(){
    _isShowingBinaryChoice = true;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void clearBinaryChoice(){
    _isShowingBinaryChoice = false;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void setSelectedStation(Station station){
    _selectedStation = station;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void showSelectedStation(){
    _isShowingSelectStation = true;
  }

  // @param void
  // @return void
  // @effects - set values for fields
  void clearSelectedStation(){
    _isShowingSelectStation = false;
  }

  // @param void
  // @return Station - return's the station object for the currently selected station
  Station getSelectedStation(){
    return _selectedStation;
  }
}