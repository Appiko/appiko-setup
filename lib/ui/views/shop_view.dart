import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// {@category Page}
/// {@category Design}
///
/// Web view of the Appiko Store.
/// FIXME: breaks on prod as package is still in developer preivew.
class ShopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "https://appiko.org/store",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
