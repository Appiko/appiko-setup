import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/ui/views/about_us_view.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class MoreView extends StatelessWidget {
  final Map moreList = {
    "About us": AboutUsView(),
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
          ListTile(
            title: Text("Dark theme"),
            trailing: Switch.adaptive(
              onChanged: (bool value) {
                Provider.of<SharedPrefs>(context).setDarkTheme(value);
              },
              value: Provider.of<SharedPrefs>(context).darkTheme,
            ),
          ),
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
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow(); //Hides the glow on overscroll
            },
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, int) => CustomDivider(),
              itemBuilder: (context, int index) => ListTile(
                    title: Text(moreList.keys.toList()[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: CustomAppBar(
                                    title: moreList.keys.toList()[index]),
                                body: moreList.values.toList()[index],
                              ),
                        ),
                      );
                    },
                  ),
              itemCount: moreList.length,
            ),
          ),
        ],
      ),
    );
  }
}
