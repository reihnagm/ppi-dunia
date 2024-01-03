import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/consts/api_const.dart';

import 'package:ppidunia/views/basewidgets/loader/square.dart';
import 'package:ppidunia/views/basewidgets/appbar/custom.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  const WebViewScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  Completer<WebViewController> controller = Completer<WebViewController>();
  WebViewController? controllerGlobal;
  bool isLoading = true;

  Future<void> launch(url) async {
    if (await canLaunchUrl(url)) {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: widget.title).buildAppBar(context),
        backgroundColor: ColorResources.backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                      userAgent: ApiConsts.mobileUa,
                      gestureNavigationEnabled: true,
                      onWebViewCreated: (WebViewController webViewController) {
                        controller.future
                            .then((value) => controllerGlobal = value);
                        controller.complete(webViewController);
                      },
                      navigationDelegate: (NavigationRequest request) async {
                        if (request.url.contains('tel:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        } else if (request.url.contains('whatsapp:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        } else if (request.url.contains('mailto:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) async {
                        setState(() => isLoading = true);
                      },
                      onPageFinished: (String url) {
                        setState(() => isLoading = false);
                      },
                    ),
                    isLoading
                        ? const Center(
                            child: SquareLoader(color: ColorResources.primary),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    if (controllerGlobal != null) {
      if (await controllerGlobal!.canGoBack()) {
        controllerGlobal!.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(true);
    }
  }
}
