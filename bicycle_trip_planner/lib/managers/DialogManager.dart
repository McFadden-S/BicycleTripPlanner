import 'package:bicycle_trip_planner/models/station.dart';

/// Class Comment:
/// DialogManager is a manager class that holds the data and functions for
/// the applications dialog boxes

class DialogManager {

  //********** Fields **********

  //The question/statement shown to the user
  String _choicePrompt = "";

  // The option displayed on the first choice in binary choice
  String _optionOneText = "";
  // The action called when the first choice is pressed
  Function _optionOneFunction = (){};

  // The option displayed on the second choice in binary choice
  String _optionTwoText = "";
  // The action called when the second choice is pressed
  Function _optionTwoFunction = (){};


  // Boolean that is checked whether to show the binary choice
  bool _isShowingBinaryChoice = false;

  Function _DestinationOkButtonFunction = (){};

  String _okButtonText = "";

  bool _isShowingEndOfRouteDialog = false;

  Station _selectedStation = Station.stationNotFound();

  bool _isShowingSelectStation = false;

  //********** Singleton **********

  /// Holds Singleton Instance
  static final DialogManager _dialogManager = DialogManager._internal();
  static DialogManager get instance => _dialogManager;

  /// Singleton Constructor Override
  factory DialogManager() {
    return _dialogManager;
  }

  DialogManager._internal();

  //********** Private **********

  //********** Public **********

  /// @param -
  ///  choicePrompt - String; choice prompt to show user
  ///  optionOneText - String; text for first choice for user
  ///  optionOneFunction - Function; function to be called when the user clicks the first option
  ///  optionTwoText - String; text for second choice for user
  ///  optionTwoFunction - Function; function to be called when the user clicks the second option
  /// @return Void
  void setBinaryChoice(choicePrompt, optionOneText, optionOneFunction, optionTwoText, optionTwoFunction){
    _choicePrompt = choicePrompt;
    _optionOneText = optionOneText;
    _optionOneFunction = optionOneFunction;
    _optionTwoText = optionTwoText;
    _optionTwoFunction = optionTwoFunction;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void setEndOfRouteDialog(){
    _choicePrompt = "You have reached your destination!";
    _okButtonText = "Ok";
    _DestinationOkButtonFunction = () {
      clearEndOfRouteDialog();
    };
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void showEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = true;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void clearEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = false;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void showBinaryChoice(){
    _isShowingBinaryChoice = true;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void clearBinaryChoice(){
    _isShowingBinaryChoice = false;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void setSelectedStation(Station station){
    _selectedStation = station;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void showSelectedStation(){
    _isShowingSelectStation = true;
  }

  /// @param void
  /// @return void
  /// @effects - set values for fields
  void clearSelectedStation(){
    _isShowingSelectStation = false;
  }

  // ********** Field Accessors **********

  /// @param void
  /// @return Station - return's the station object for the currently selected station
  Station getSelectedStation(){
    return _selectedStation;
  }

  /// @param void
  /// @return Boolean - if the Dialog for when the user has reached their destination is showing
  bool ifShowingEndOfRouteDialog(){
    return _isShowingEndOfRouteDialog;
  }

  /// @param void
  /// @return Boolean - if the Binary Choice dialog is showing
  bool ifShowingBinaryChoice(){
    return _isShowingBinaryChoice;
  }

  /// @param void
  /// @return Boolean - if the Dialog appear when clicking on a station on the Home screen
  bool ifShowingSelectStation(){
    return _isShowingSelectStation;
  }

  /// @param void
  /// @return Function - the function that should be called when the user clicks the 'Ok' button in the end of route dialog
  Function getEndOfRouteFunction(){
    return _DestinationOkButtonFunction;
  }

  /// @param void
  /// @return String - the text in the 'Ok' button to be used in dialogs
  String getOkButtonText(){
    return _okButtonText;
  }

  /// @param void
  /// @return String - the string prompt shown to the user in binary choice dialogs
  String getChoicePrompt(){
    return _choicePrompt;
  }

  /// @param void
  /// @return String - the text for the first option button in a binary choice dialog
  String getOptionOneText(){
    return _optionOneText;
  }

  /// @param void
  /// @return Function - the function that should be called when the user clicks the option one button
  Function getOptionOneFunction(){
    return _optionOneFunction;
  }

  /// @param void
  /// @return String - the text for the second option button in a binary choice dialog
  String getOptionTwoText(){
    return _optionTwoText;
  }

  /// @param void
  /// @return Function - the function that should be called when the user clicks the second option button in a binary choice dialog
  Function getOptionTwoFunction(){
    return _optionTwoFunction;
  }

}
