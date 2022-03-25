import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalkBikeToggleDialog extends StatefulWidget {
  const WalkBikeToggleDialog({Key? key}) : super(key: key);

  @override
  _WalkBikeToggleDialogState createState() => _WalkBikeToggleDialogState();
}

class _WalkBikeToggleDialogState extends State<WalkBikeToggleDialog> {
  final DialogManager _dialogManager = DialogManager();
  late final ApplicationBloc appBloc;

  void toggleCycling() {
    setState(() => {appBloc.toggleCycling()});
  }

  @override
  void initState() {
    appBloc = Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: true);

    if (!_dialogManager.ifShowingWalkBikeToggleDialog()) {
      return  const SizedBox.shrink();
    } else {
      return Dialog(
        backgroundColor: ThemeStyle.cardColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                      child: Text("Toggle between walking and cycling?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ThemeStyle.primaryTextColor)
                      )),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromWidth(double.infinity),
                          primary: ThemeStyle.buttonPrimaryColor
                      ),
                      onPressed: () {
                        toggleCycling();
                        _dialogManager.clearWalkBikeToggleDialog();
                        applicationBloc.notifyListeningWidgets();
                      },
                      // onPressed: YesOption();
                      child: Text("Toggle",
                          style: TextStyle(color: ThemeStyle.primaryTextColor)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromWidth(double.infinity),
                          primary: ThemeStyle.buttonPrimaryColor
                      ),
                      onPressed: () {
                        _dialogManager.clearWalkBikeToggleDialog();
                        applicationBloc.notifyListeningWidgets();
                      },
                      // onPressed: YesOption();
                      child: Text("Cancel",
                          style: TextStyle(color: ThemeStyle.primaryTextColor)),
                    ),
                  ),
                ],
              ),
            )),
      );
    }
  }}
