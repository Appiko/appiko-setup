import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/timer_settings_view.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/profile_app_bar.dart';
import 'package:setup/ui/widgets/setting_summary_card.dart';
import 'package:setup/ui/widgets/setting_timepicker_screen.dart';

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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    DeleteAllSettingsButton(),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    SettingSummaryCard(),
                    DeleteAllSettingsButton(),
                  ],
                ),
              ),
              Center(child: Text("c")),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SettingTimepickerScreen()));
            },
            // label: Text("SETTING"),
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomActionBar(
            actionLabel: "Save",
            onClosePressed: () {
              Navigator.pop(context);
            },
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

class DeleteAllSettingsButton extends StatelessWidget {
  const DeleteAllSettingsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 20),
      FlatButton.icon(
        splashColor: Theme.of(context).errorColor.withAlpha(100),
        highlightColor: Colors.transparent,
        icon: Icon(
          OMIcons.delete,
          color: Theme.of(context).errorColor,
        ),
        label: Text(
          "Delete All Settings".toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
        onPressed: () {},
      ),
      SizedBox(height: 20),
    ]);
  }
}
