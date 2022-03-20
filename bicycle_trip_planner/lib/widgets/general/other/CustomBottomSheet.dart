import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget child;

  const CustomBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<CustomBottomSheet> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: ThemeStyle.cardColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          height: isExpanded
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.05,
          // Define how long the animation should take.
          duration: const Duration(milliseconds: 300),
          // Provide an optional curve to make the animation feel smoother.
          curve: Curves.fastOutSlowIn,
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
                          ? Icon(Icons.keyboard_arrow_down,
                              color: ThemeStyle.secondaryIconColor)
                          : Icon(Icons.keyboard_arrow_up,
                              color: ThemeStyle.secondaryIconColor),
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
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
