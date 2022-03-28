import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';


// NOTE: Do not actually implement an object of this class, just copy and paste the widget code into the relevant file
// so that you can customise the YesOption() method and the NoOption() methods to your specific requirements.
//
// Thus, this class is only a skeleton for use elsewhere in the project => (YesOrNoDialog() itself should not actually
// be called anywhere).


class YesOrNoDialog extends StatefulWidget {
  const YesOrNoDialog({ Key? key }) : super(key: key);

  @override
  _YesOrNoDialogState createState() => _YesOrNoDialogState();
}

class _YesOrNoDialogState extends State<YesOrNoDialog> {

  void YesOption() {
    // Whatever is meant to happen when the user clicks the 'Yes' button should go in the onPressed method of the 'Yes' button
    // which is where the YesOption() method currently is in the code below.
  }

  void NoOption() {
    // Whatever is meant to happen when the user clicks the 'No' button should go in the onPressed method of the 'No' button
    // which is where the NoOption() method currently is in the code below.
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)
      ),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Expanded(child: Text("Tell the user their choice here", textAlign: TextAlign.center)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromWidth(double.infinity)
                    ),
                    onPressed: (){},
                    // onPressed: YesOption();
                    child: Text("Yes"),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromWidth(double.infinity)
                    ),
                    onPressed: (){},
                    // onPressed: NoOption();
                    child: Text("No"),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          )
      ),
    );
  }
}