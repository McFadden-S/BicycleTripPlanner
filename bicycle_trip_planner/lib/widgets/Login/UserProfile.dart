import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../constants.dart';

class UserProfile extends StatefulWidget {

  UserProfile({ Key? key}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            Text(applicationBloc.getCurrentUser()?.email ?? "NO EMAIL"),
            ElevatedButton(
                onPressed: (){
                  _auth.signOut();
                },
                child: Text("Log out")
            ),
          ],
        ),
      ),
    );
  }
}
