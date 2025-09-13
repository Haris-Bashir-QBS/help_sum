import 'package:flutter/material.dart';

import '../../../../../core/enums/content_type.dart';

class ContentScreen extends StatelessWidget {
  final AppContentType contentType;

  const ContentScreen({super.key, required this.contentType});

  String _getTitle() {
    switch (contentType) {
      case AppContentType.termsAndConditions:
        return "Terms & Conditions";
      case AppContentType.privacyPolicy:
        return "Privacy Policy";
    }
  }

  String _getBody() {
    switch (contentType) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(_getBody(), style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
