


 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/data/rest/endpoints.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:webview_flutter/webview_flutter.dart';
 // Import for Android features.
 import 'package:webview_flutter_android/webview_flutter_android.dart';
 // Import for iOS features.
 import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';



 //todo pag not loading in ios
class WebPage extends StatefulWidget{
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> with AuthMixin{

  late final WebViewController _controller;
  bool _loadingPage = true;
  String _urlWeb = '';

  @override
  void initState() {
    super.initState();
    if(user.branchName == 'Москва'){
       _urlWeb = Endpoints.urlMSK;
    }else{
      _urlWeb = Endpoints.urlNSK;
    }
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {

            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
           setState(() {
             _loadingPage = false;
           });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://virtuozy-msk.ru')) {
            //   debugPrint('blocking navigation to ${request.url}');
            //   return NavigationDecision.prevent;
            // }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_urlWeb));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {

    if(_loadingPage){
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _controller);
  }
}