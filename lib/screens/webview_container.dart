import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/constants/constants.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';


class WebViewContainer extends StatefulWidget {
  final String url;

  const WebViewContainer(this.url, {Key? key}) : super(key: key);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _key = UniqueKey();
@override
void initState() { 
  super.initState();

}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: kGreenColor,
            leading: Consumer<Auth>(
              builder: (context, auth, widget) {
                return IconButton(
                  icon:  Platform.isIOS?const Icon(Icons.arrow_back_ios): const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                       auth.controller.jumpToTab(0);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             const TabsScreen(selectedPageIndex: 0)));
                  },
                );
              }
            ),
            title: const Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Center(
                child: Text(
                  'Payment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.url))
            ],
          )),
    );
  }
}
