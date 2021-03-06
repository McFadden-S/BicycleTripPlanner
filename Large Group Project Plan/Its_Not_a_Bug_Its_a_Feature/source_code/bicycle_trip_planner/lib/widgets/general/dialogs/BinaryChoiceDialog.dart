import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinaryChoiceDialog extends StatefulWidget {
  const BinaryChoiceDialog({Key? key}) : super(key: key);

  @override
  _BinaryChoiceDialogState createState() => _BinaryChoiceDialogState();
}

class _BinaryChoiceDialogState extends State<BinaryChoiceDialog> {
  final DialogManager _dialogManager = DialogManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: true);

    if (!_dialogManager.ifShowingBinaryChoice()) {
      return  const SizedBox.shrink();
    } else {
      return Dialog(
        key: Key('binaryChoiceDialog'),
          backgroundColor: ThemeStyle.cardColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                        child: Text(_dialogManager.getChoicePrompt(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ThemeStyle.primaryTextColor)
                        )),
                    Expanded(
                      child: ElevatedButton(
                        key: Key('Binary Button 1'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity),
                            primary: ThemeStyle.buttonPrimaryColor
                        ),
                        onPressed: () {
                          (_dialogManager.getOptionOneFunction())();
                          applicationBloc.clearBinaryDialog();
                        },
                        child: Text(_dialogManager.getOptionOneText(),
                            style: TextStyle(color: ThemeStyle.primaryTextColor)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ElevatedButton(
                        key: Key('Binary Button 2'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity),
                            primary: ThemeStyle.buttonPrimaryColor
                            ),
                        onPressed: () {
                          (_dialogManager.getOptionTwoFunction())();
                          applicationBloc.clearBinaryDialog();
                        },
                        child: Text(_dialogManager.getOptionTwoText(),
                            style: TextStyle(color: ThemeStyle.primaryTextColor)),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),
      );
    }
}}
