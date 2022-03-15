
import 'package:bicycle_trip_planner/models/station.dart';

class DialogManager {

  //********** Fields **********

  String _choicePrompt = "";

  String _optionOneText = "";
  Function _optionOneFunction = (){};

  String _optionTwoText = "";
  Function _optionTwoFunction = (){};

  bool _isShowingBinaryChoice = false;

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

  bool ifShowingBinaryChoice(){
    return _isShowingBinaryChoice;
  }

  bool ifShowingSelectStation(){
    return _isShowingSelectStation;
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