import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../managers/RouteManager.dart';


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

    return Container(
      padding:
      const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
      decoration: BoxDecoration(
        color: ThemeStyle.buttonPrimaryColor,
        borderRadius:
        const BorderRadius.all(Radius.circular(30.0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          dropdownColor: ThemeStyle.cardColor,
          isDense: true,
          value: _routeManager.getGroupSize(),
          icon:
          const Icon(Icons.group, color: Colors.white),
          iconSize: 30,
          elevation: 16,
          style: const TextStyle(
              color: Colors.black45, fontSize: 18),
          menuMaxHeight: 200,
          onChanged: (int? newValue) =>
              _routeManager.setGroupSize(newValue!),
          selectedItemBuilder: (BuildContext context) {
            return _groupSizeOptions.map((int value) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0),
                child: Text(
                  _routeManager.getGroupSize().toString(),
                  style:
                  const TextStyle(color: Colors.white),
                ),
              );
            }).toList();
          },
          items: _groupSizeOptions
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
