import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: Column(
            children: <Widget> [
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (input) => { search(input)},
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                ),

            ],
          ),
        )
      ),
    );
  }

  void search(String input) {
    print('This method is triggered when search box is changed');
  }
}
