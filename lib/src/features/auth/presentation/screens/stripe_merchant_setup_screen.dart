import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeMerchantSetupScreen extends StatefulWidget {
  final String setupUrl; // Stripe Checkout URL from your backend

  const StripeMerchantSetupScreen({required this.setupUrl, super.key});

  @override
  State<StripeMerchantSetupScreen> createState() =>
      _StripeMerchantSetupScreenState();
}

class _StripeMerchantSetupScreenState extends State<StripeMerchantSetupScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    print(widget.setupUrl);
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (_) {
                setState(() {
                  _isLoading = false;
                });
              },
              onNavigationRequest: (request) {
                log('Navigating to: ${request.url}');
                if (request.url.startsWith('https://www.bedpage.com/')) {
                  // Handle the redirect URL after successful setup
                  Navigator.of(context).pop(true); // Pop with success
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.setupUrl))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
          );
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Cancel Setup'),
                content: const Text(
                  'Are you sure you want to cancel the setup?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const CustomText(text: 'No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const CustomText(text: 'Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CustomText(text: 'Stripe Merchant Setup'),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
