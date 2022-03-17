import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/widgets/navigation/CurrentDirection.dart';
import 'package:bicycle_trip_planner/widgets/navigation/DirectionTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Directions extends StatefulWidget {
  const Directions({Key? key}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  final DirectionManager directionManager = DirectionManager();

  bool extendedNavigation = false;

  void _toggleExtendNavigationView() {
    setState(() => {extendedNavigation = !extendedNavigation});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Directions being buillt again");
    Provider.of<ApplicationBloc>(context);
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () => _toggleExtendNavigationView(),
      child: ClipRect(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeStyle.cardColor, //Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: CurrentDirection(
                  currentDirection: directionManager.getCurrentDirection()),
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeStyle.cardColor, //Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  (!extendedNavigation) || (directionManager.ifDirections())
                      ? Divider()
                      : const SizedBox.shrink(),
                  AnimatedSizeAndFade(
                    fadeDuration: const Duration(milliseconds: 300),
                    sizeDuration: const Duration(milliseconds: 300),
                    child: extendedNavigation
                        ? LimitedBox(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.25,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: ThemeStyle.directionTileColor,
                              child: ListView.separated(
                                itemCount:
                                    directionManager.getNumberOfDirections(),
                                itemBuilder: (BuildContext context, int index) {
                                  return DirectionTile(
                                      index: index,
                                      directionManager: directionManager);
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: extendedNavigation
                          ? Icon(Icons.keyboard_arrow_up,
                              color: ThemeStyle.secondaryIconColor)
                          : Icon(Icons.keyboard_arrow_down,
                              color: ThemeStyle.secondaryIconColor))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
