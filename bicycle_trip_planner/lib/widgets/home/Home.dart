import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    double topPaddingHeight = MediaQuery.of(context).padding.top;
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                color: Colors.grey.withOpacity(0.4),
                child: SizedBox(height: topPaddingHeight, width: MediaQuery.of(context).size.width)
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: applicationBloc.getSelectedScreen()),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: Text("Show dialog"),
              onPressed: (){showMyDialog();},
            ),
          )
        ],
      ),
    );
  }

  void showMyDialog() {
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
                      Expanded(child: Text("Set as:", textAlign: TextAlign.center)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromWidth(double.infinity)
                          ),
                          onPressed: (){},
                          child: Text("Starting point"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromWidth(double.infinity)
                            ),
                            onPressed: (){},
                            child: Text("Intermediate stop")
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromWidth(double.infinity)
                            ),
                            onPressed: (){},
                            child: Text("Destination")
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
            ),
          );
        });
  }
}
