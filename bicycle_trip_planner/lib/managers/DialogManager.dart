
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
  String _okButtonText = "";
  Function _okButtonFunction = (){};

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

  bool ifShowingEndOfRouteDialog(){
    return _isShowingEndOfRouteDialog;
  }

  bool ifShowingBinaryChoice(){
    return _isShowingBinaryChoice;
  }

  bool ifShowingSelectStation(){
    return _isShowingSelectStation;
  }

  String getEndOfRouteDialogText(){
    return _endOfRouteText;
  }

  Function getEndOfRouteFunction(){
    return _okButtonFunction;
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
    _okButtonFunction = (){
      clearEndOfRouteDialog();
    };
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