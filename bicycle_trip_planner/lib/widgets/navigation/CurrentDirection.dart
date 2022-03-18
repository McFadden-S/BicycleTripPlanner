import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class CurrentDirection extends StatefulWidget {
  final Steps currentDirection;
  const CurrentDirection({Key? key, required this.currentDirection})
      : super(key: key);

  @override
  _CurrentDirectionState createState() => _CurrentDirectionState();
}

class _CurrentDirectionState extends State<CurrentDirection> {
  //late final applicationBloc;

  final DirectionManager directionManager = DirectionManager();

  @override
  void initState() {
    //applicationBloc = Provider.of<ApplicationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.15),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: directionManager
                    .directionIcon(widget.currentDirection.instruction),
              ),
              Flexible(
                  flex: 15,
                  child: Html(style: {
                    "body": Style(
                        fontSize: FontSize(15.0),
                        padding: EdgeInsets.all(5),
                        color: ThemeStyle.secondaryTextColor)
                  }, data: widget.currentDirection.instruction)),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "${widget.currentDirection.distance} m",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeStyle.secondaryTextColor),
                  )),
              // : const Spacer(),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
