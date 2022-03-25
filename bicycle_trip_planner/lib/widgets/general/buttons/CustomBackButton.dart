import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBackButton extends StatefulWidget {

  final String backTo;
  final BuildContext context;

  const CustomBackButton({ Key? key, required this.context, required this.backTo}) : super(key: key);

  @override
  _CustomBackButtonState createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {

  final DialogManager dialogManager = DialogManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleButton(
                iconIn: Icons.arrow_back,
                onButtonClicked: () {
                  dialogManager.setBinaryChoice(
                      "Do you want to go back to the ${widget.backTo} screen?",
                      "Yes",
                      (){applicationBloc.goBack(widget.backTo);},
                      "No",
                      (){},
                  );

                  applicationBloc.showBinaryDialog();

                }
            ),
          ],
        ),
      ]
    );
  }
  
}
