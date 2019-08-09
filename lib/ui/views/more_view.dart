import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/motion_settings_view.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class MoreView extends StatelessWidget {
  final Map moreList = {
    // "About us": AboutUsView(),
    "About us": MotionSettingsView(),
    "Contact us": Container(),
    "Send feedback": Container(),
    "FAQ": Container(),
    "Third party software": Container(),
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          // ListTile(
          //   title: Text("Dark mode"),
          //   trailing: Switch.adaptive(
          //     onChanged: (bool value) {
          //       Provider.of<SharedPrefs>(context).setDarkTheme(value);
          //     },
          //     value: Provider.of<SharedPrefs>(context).darkTheme,
          //   ),
          // ),
          CustomDivider(),
          ListTile(
            title: Text("Advanced options"),
            trailing: Switch.adaptive(
              onChanged: (bool value) {
                Provider.of<SharedPrefs>(context).setAdvancedOptions(value);
              },
              value: Provider.of<SharedPrefs>(context).advancedOptions,
            ),
          ),
          CustomDivider(),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, int) => CustomDivider(),
            itemBuilder: (context, int index) => ListTile(
              title: Text(moreList.keys.toList()[index]),
              onTap: () {
                Navigator.push(
                  context,
                  //TODO: Make indivisual pages and add it to routes in main.dart
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      // appBar:
                      //     CustomAppBar(title: moreList.keys.toList()[index]),
                      body: moreList.values.toList()[index],
                    ),
                  ),
                );
              },
            ),
            itemCount: moreList.length,
          ),
        ],
      ),
    );
  }
}
