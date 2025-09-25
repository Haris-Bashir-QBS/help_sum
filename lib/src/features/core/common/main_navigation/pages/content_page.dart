import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/enums/content_type.dart';
import 'package:help_sum/src/widgets/custom_loading_widget.dart';

class ContentScreen extends StatefulWidget {
  final AppContentType contentType;

  const ContentScreen({super.key, required this.contentType});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late WebViewController webViewController;
  bool _isLoading = true;

  String _getTitle() {
    switch (widget.contentType) {
      case AppContentType.termsAndConditions:
        return "Terms & Conditions";
      case AppContentType.privacyPolicy:
        return "Privacy Policy";
    }
  }

  String _getBody() {
    switch (widget.contentType) {
      case AppContentType.termsAndConditions:
        return """
Dummy Terms & Conditions:

1. You must be at least 18 years old to use this app.
2. We are not responsible for any loss of data.
3. Users must follow all applicable local laws.
4. The app may change or update at any time without notice.
""";
      case AppContentType.privacyPolicy:
        return """
Dummy Privacy Policy:

1. We value your privacy and do not sell personal data.
2. Some data may be collected to improve services.
3. Cookies or local storage may be used.
4. You can contact us anytime to request data deletion.
""";
    }
  }

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.contentType == AppContentType.privacyPolicy
          ? "https://helpsum.stiinnovation.com/privacy_policy"
          : "https://helpsum.stiinnovation.com/terms_and_conditions"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle())),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: WebViewWidget(controller: webViewController),
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CustomDotsLoader(),
              ),
            ),
        ],
      ),
    );
  }
}
