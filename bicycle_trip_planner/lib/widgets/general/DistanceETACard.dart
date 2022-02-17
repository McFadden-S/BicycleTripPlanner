import 'package:flutter/material.dart';

class DistanceETACard extends StatefulWidget {

  const DistanceETACard({ Key? key}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<DistanceETACard> {

  @override
  Widget build(BuildContext context) {

    return Card(
        color: const Color.fromRGBO(12, 156, 238, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Colors.black, width: 1.0),
        ),
        child:
        Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Column(
                  children: const [
                    Icon(
                        Icons.timer,
                        color: Colors.white,
                    ),
                    Text(
                      "[ETA]",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    )
                  ]
              ),
              const Text(
                "3.5 miles",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
    );
  }
}
