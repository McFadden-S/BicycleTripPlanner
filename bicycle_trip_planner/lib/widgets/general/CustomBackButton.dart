import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CircleButton.dart';

class CustomBackButton extends StatefulWidget {

  final String backTo;
  final BuildContext context;

  const CustomBackButton({ Key? key, required this.context, required this.backTo}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<CustomBackButton> {
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
                onButtonClicked: () => {
                  showBackButtonBinaryDialog(applicationBloc),
                }
            ),
          ],
        ),
      ]
    );
  }

  void showBackButtonBinaryDialog(applicationBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20.0)
          ),
          child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Expanded(child: Text("Do you want to go back to the home screen?", textAlign: TextAlign.center)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromWidth(double.infinity)
                        ),
                        // onPressed: (){},
                        onPressed: () {
                          applicationBloc.goBack(widget.backTo);
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromWidth(double.infinity)
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
          ),
        );
      },
    );
  }
  
}
