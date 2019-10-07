import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/ui/devices/sense_pi/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/setting_summary_card.dart';

class TimerTabContents extends StatelessWidget {
  const TimerTabContents({
    Key key,
    @required this.timerSettingCards,
  }) : super(key: key);

  final List<SettingSummaryCard> timerSettingCards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...timerSettingCards,
          timerSettingCards.length > 0
              ? DeleteAllSettingsButton(
                  onPressed: () {
                    Provider.of<SensePiService>(context)
                        .deleteAllSettings(TimerSetting);
                  },
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 220,
                  child: Center(
                    child: Text(
                      "Nothing here yet, add a new Timer setting.",
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
