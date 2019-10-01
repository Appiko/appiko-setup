import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/setting_summary_card.dart';

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
                    Provider.of<SenseBeRxService>(context)
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
