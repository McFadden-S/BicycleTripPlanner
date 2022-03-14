import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
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
                        child: Text(_dialogManager.getChoicePrompt(),
                            textAlign: TextAlign.center)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity)),
                        onPressed: () {
                          (_dialogManager.getOptionOneFunction())();
                          applicationBloc.clearBinaryDialog();
                        },
                        // onPressed: YesOption();
                        child: Text(_dialogManager.getOptionOneText()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromWidth(double.infinity)),
                        onPressed: () {
                          (_dialogManager.getOptionTwoFunction())();
                          applicationBloc.clearBinaryDialog();
                        },
                        // onPressed: NoOption();
                        child: Text(_dialogManager.getOptionTwoText()),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )),
      );
    }
}}
