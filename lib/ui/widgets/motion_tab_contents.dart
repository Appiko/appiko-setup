import 'package:flutter/material.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/setting_summary_card.dart';

class MotionTabContents extends StatelessWidget {
  const MotionTabContents({
    Key key,
    @required this.motionSettingCards,
  }) : super(key: key);

  final List<SettingSummaryCard> motionSettingCards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ...motionSettingCards,
          motionSettingCards.length > 0
              ? DeleteAllSettingsButton(onPressed: () {
                  locator<SenseBeRxService>().deleteAllSettings(MotionSetting);
                })
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 220,
                  child: Center(
                    child: Text(
                      "Nothing here yet, add a new Motion setting.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
