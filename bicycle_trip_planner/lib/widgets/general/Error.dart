import 'package:flutter/material.dart';

// text passed through depending on error
class Error extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
      child: const Text(
          "error :("
      ),
    ),
    );
  }
}
