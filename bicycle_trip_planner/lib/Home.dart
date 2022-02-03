import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> stations = [
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Color(0xff345955),
        child: Container(
            padding: EdgeInsets.all(0),
            height: 56.0,
            child: ListView.builder(
                physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: stations.length,
                itemBuilder: (BuildContext context, int index) => stationCard(context, index)
            )
        ),
      ),
      body: SafeArea(
          child: Container(
        color: Colors.green,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (input) => {search(input)},
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget stationCard(BuildContext context, int index) {
    return InkWell(
      onTap: () => stationClicked(index),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
                child: Row(
              children: [
                Text(stations[index]),
                Text(" Index" + index.toString()),
              ],
                )),
          )
      ),
    );
  }

  void search(String input) {
    print('This method is triggered when search box is changed');
  }

  void stationClicked(int index) {
    print("Station of index $index was tapped");
  }
}
