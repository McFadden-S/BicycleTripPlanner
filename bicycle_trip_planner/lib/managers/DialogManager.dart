
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';

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

  factory DialogManager() {
    return _dialogManager;
  }

  DialogManager._internal();

  //********** Private **********

  //********** Public **********

  bool ifShowingWalkBikeToggleDialog(){
    return _isShowingWalkBikeToggleDialog;
  }

  bool ifShowingEndOfRouteDialog(){
    return _isShowingEndOfRouteDialog;
  }

  bool ifShowingBinaryChoice(){
    return _isShowingBinaryChoice;
  }

  bool ifShowingSelectStation(){
    return _isShowingSelectStation;
  }

  String getWalkBikeToggleText() {
    return _walkBikeToggleText;
  }

  String getEndOfRouteDialogText(){
    return _endOfRouteText;
  }

  Function getEndOfRouteFunction(){
    return _DestinationOkButtonFunction;
  }

  String getOkButtonText(){
    return _okButtonText;
  }

  String getChoicePrompt(){
    return _choicePrompt;
  }

  String getOptionOneText(){
    return _optionOneText;
  }

  Function getOptionOneFunction(){
    return _optionOneFunction;
  }

  String getOptionTwoText(){
    return _optionTwoText;
  }

  Function getOptionTwoFunction(){
    return _optionTwoFunction;
  }

  String getWalkBikeToggleDialogText(){
    return _walkBikeToggleText;
  }

  String getCancelButtonText(){
    return _cancelButtonText;
  }

  Function getWalkBikeToggleFunction(){
    return _walkBikeToggleFunction;
  }

  void setBinaryChoice(choicePrompt, optionOneText, optionOneFunction, optionTwoText, optionTwoFunction){
    _choicePrompt = choicePrompt;
    _optionOneText = optionOneText;
    _optionOneFunction = optionOneFunction;
    _optionTwoText = optionTwoText;
    _optionTwoFunction = optionTwoFunction;
  }

  void setEndOfRouteDialog(){
    _endOfRouteText = "You have reached your destination!";
    _okButtonText = "Ok";
    _DestinationOkButtonFunction = (){
      clearEndOfRouteDialog();
    };
  }

  void setWalkBikeToggle(){
    _walkBikeToggleText = "Toggle between walking and biking?";
    _walkBikeToggleButtonText = "Toggle";
    _cancelButtonText = "Cancel";
  }

  void showWalkBikeToggleDialog(){
    _isShowingWalkBikeToggleDialog = true;
  }

  void clearWalkBikeToggleDialog(){
    _isShowingWalkBikeToggleDialog = false;
  }

  void showEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = true;
  }

  void clearEndOfRouteDialog(){
    _isShowingEndOfRouteDialog = false;
  }

  void showBinaryChoice(){
    _isShowingBinaryChoice = true;
  }

  void clearBinaryChoice(){
    _isShowingBinaryChoice = false;
  }

  void setSelectedStation(Station station){
    _selectedStation = station;
  }

  void showSelectedStation(){
    _isShowingSelectStation = true;
  }

  void clearSelectedStation(){
    _isShowingSelectStation = false;
  }

  Station getSelectedStation(){
    return _selectedStation;
  }



}