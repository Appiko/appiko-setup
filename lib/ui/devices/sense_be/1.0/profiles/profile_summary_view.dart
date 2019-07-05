import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/profile_app_bar.dart';

class ProfileSummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: ProfileAppBar(
            title: "Forest",
            subtitle: "SensePi",
          ),
          body: TabBarView(
            children: <Widget>[
              Center(child: Text("a")),
              Center(child: Text("b")),
              Center(child: Text("c")),
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            actionLabel: "Save",
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return false;
      },
    );
  }
}
