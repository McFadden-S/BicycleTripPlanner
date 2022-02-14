import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'Directions.dart';


class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool extendedNavigation = false;
  bool cycling = false;
  final List<Widget> entries = [NavigationDirection(), NavigationDirection()];

  void setExtendNavigationVied(){
    setState(()=> {extendedNavigation = !extendedNavigation});
  }

  void setCycling(){
    setState(()=> {cycling = !cycling});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: ()=>setExtendNavigationVied(),
                    child: SizedBox(
                      height: !extendedNavigation ? 100 : 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
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
                            const Icon(Icons.expand_more),
                          extendedNavigation ? const Icon(Icons.expand_less) : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ),
                ),
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () => {},
                        child: const Icon(
                            Icons.location_on
                        ),
                    )
                  ]
                ),
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: ()=>{},
                        child: const Icon(
                            Icons.expand
                        ),
                      )
                    ]
                ),
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xFF8B0000),
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: const Text(
                                "12 : 02",
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                              ),
                            )
                        ),
                      )
                    ]
                ),
                Spacer(flex: 50),
                Row(
                  children: [
                    Card(
                      child:
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Column(
                                  children: const [
                                    Icon(Icons.timer),
                                    Text("[ETA]")
                                  ]
                              ),
                              const Text("3.5 miles")
                            ],
                          ),
                        )
                    ),
                    const Spacer(flex: 1),
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_walk,
                            color: cycling ? Colors.white70 : Colors.white,
                            size: 30,
                          ),
                          const Text('/', style: TextStyle(fontSize: 25),),
                          Icon(
                            Icons.directions_bike,
                            color: cycling ? Colors.white : Colors.white70,
                            size: 30,
                          ),
                        ],
                      ),
                      onPressed: () {
                        setCycling();
                      },
                    ),
                    const Spacer(flex: 10),
                    FloatingActionButton(
                      onPressed: ()=>{},
                        backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                        size: 35,
                      )
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          )
      ),
    );
  }
}

class NavigationDirection extends StatelessWidget {
  const NavigationDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.cyanAccent,
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam elementum dolor eget lorem euismod rutrum.',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

