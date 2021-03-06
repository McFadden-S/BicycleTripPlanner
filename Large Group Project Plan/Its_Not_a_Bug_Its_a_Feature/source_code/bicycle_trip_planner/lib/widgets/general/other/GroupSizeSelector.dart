import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../bloc/application_bloc.dart';

/// Widget to display the group size
class GroupSizeSelector extends StatefulWidget {
  const GroupSizeSelector({
    Key? key,
  }) : super(key: key);

  @override
  _GroupSizeSelectorState createState() => _GroupSizeSelectorState();
}

class _GroupSizeSelectorState extends State<GroupSizeSelector> {
  final List<int> _groupSizeOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final RouteManager _routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    return Container(
      key: Key("primaryContainer"),
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
      decoration: BoxDecoration(
        color: ThemeStyle.buttonPrimaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
      // Creates drop down buttons
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          key: Key("groupSizeSelector"),
          dropdownColor: ThemeStyle.cardColor,
          isDense: true,
          value: _routeManager.getGroupSize(),
          icon: const Icon(Icons.group, color: Colors.white),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: ThemeStyle.primaryTextColor, fontSize: 18),
          menuMaxHeight: 200,
          onChanged: (int? newValue) =>
              applicationBloc.updateGroupSize(newValue!),
          selectedItemBuilder: (BuildContext context) {
            // Gets list of options as strings to display
            return _groupSizeOptions.map((int value) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  _routeManager.getGroupSize().toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList();
          },
          // Gets list of options as items to display
          items: _groupSizeOptions.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                value.toString(),
                key: Key(value.toString()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
