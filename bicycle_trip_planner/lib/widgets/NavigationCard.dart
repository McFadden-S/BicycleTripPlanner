import 'package:bicycle_trip_planner/widgets/NavigationDirection.dart';
import 'package:flutter/material.dart';

class NavigationCard extends StatefulWidget {
  const NavigationCard({ Key? key }) : super(key: key);

  @override
  _NavigationCardState createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {

  bool extendedNavigation = false;
  final List<Widget> entries = [NavigationDirection(), NavigationDirection()];

  void setExtendNavigationVied(){
    setState(()=> {extendedNavigation = !extendedNavigation});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: ()=>setExtendNavigationVied(),
        child: SizedBox(
          height: !extendedNavigation ? 100 : 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.assistant_direction,
                      color: Colors.grey[400],
                      size: 60
                    ),
                    const Spacer(),
                    const Text("Turn left in 1 miles"),
                    const Spacer(flex: 5),
                  ],
                ),
              ),
              extendedNavigation ?
                SizedBox(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    children: entries,
                  ),
                )
              :
                const Icon(Icons.expand_more)
            ],
          ),
        )
      ),
    ); 
  }
}