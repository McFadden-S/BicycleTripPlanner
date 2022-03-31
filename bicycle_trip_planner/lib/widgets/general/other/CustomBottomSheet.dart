import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget child;

  const CustomBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: BoxDecoration(
                color: ThemeStyle.cardColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: ThemeStyle.stationShadow,
                    spreadRadius: 8,
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  )
                ]),
          child: AnimatedSizeAndFade(
              fadeDuration: const Duration(milliseconds: 300),
              sizeDuration: const Duration(milliseconds: 300),
              child: !isExpanded
                  ? Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Column(
                      children: [
                        // top bar where the expand/shrink icon is
                        Align(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              alignment: Alignment.topCenter,
                              icon: Icon(Icons.keyboard_arrow_up,
                                  color: ThemeStyle.secondaryIconColor),
                              tooltip: 'Expand',
                              onPressed: () => {
                                setState(() {
                                  isExpanded = true;
                                })
                              },
                            )),
                      ],
                    ),
                  ) : Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  alignment: Alignment.topCenter,
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: ThemeStyle.secondaryIconColor),
                                  tooltip: 'Shrink',
                                  onPressed: () => {
                                    setState(() {
                                      isExpanded = false;
                                    })
                                  },
                                )),
                            Expanded(child: widget.child),
                          ],
                        )),
                  )),
        ));
  }
}
