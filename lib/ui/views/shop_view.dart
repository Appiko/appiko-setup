import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "https://appiko.org/store",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
