import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget widgetIn;

  const CustomBottomSheet({ Key? key, required this.widgetIn}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<CustomBottomSheet> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          height: isExpanded
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.05,
          child: Column(
            children: [
              // top bar where the expand/shrink ion is
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      alignment: Alignment.topCenter,
                      icon: isExpanded
                          ? Icon(Icons.keyboard_arrow_down)
                          : Icon(Icons.keyboard_arrow_up),
                      tooltip: 'Shrink',
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    )),
              ),
              Expanded(
                // color: Colors.black45,
                child: Visibility(
                  visible: isExpanded,
                  child: IntrinsicHeight(
                      child: widget.widgetIn,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
