import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/currentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutePlanning extends StatefulWidget {
  const RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  List<int> groupSizeOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int? groupSizeValue = 1;

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Stack(children: [RouteCard()]),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: CurrentLocationButton(),
                )
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, top: 10.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 3.0, right: 7.0),
                    decoration: const BoxDecoration(
                      color: const Color.fromRGBO(12, 156, 238, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButton<int>(
                        isDense: true,
                        value: groupSizeValue,
                        icon: const Icon(Icons.group, color: Colors.white),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 18),
                        menuMaxHeight: 200,
                        onChanged: (int? newValue) =>
                            onGroupSizeChanged(newValue!),
                        selectedItemBuilder: (BuildContext context) {
                          return groupSizeOptions.map((int value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                groupSizeValue.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList();
                        },
                        items: groupSizeOptions
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ),
                ]
                ),
                const Spacer(flex: 50),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const DistanceETACard(),
                  const Spacer(flex: 10),
                  RoundedRectangleButton(
                      iconIn: Icons.directions_bike,
                      buttonColor: Colors.green,
                      onButtonClicked: () {
                        if(RouteManager().ifStartSet() && RouteManager().ifDestinationSet()){ 
                          applicationBloc.setSelectedScreen('navigation');
                          applicationBloc.showBackButton = false;
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Start and Destination have not been set!"),
                          ));
                        }
                      }
                  )
                ]),
              ],
            ),
          ],
        ),
      );
  }

  // TODO: remove print statement after linking the button correctly
  void onGroupSizeChanged(int newValue) {
    print("menu option changed form $groupSizeValue to: $newValue");
    setState(() {
      groupSizeValue = newValue;
    });
  }
}
