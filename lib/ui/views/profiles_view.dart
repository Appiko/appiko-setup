import 'package:flutter/material.dart';

class ProfilesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("PROFILES VIEW"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("CREATE NEW PROFILE"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/profiles/new');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
