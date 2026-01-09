import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!kIsWeb && Platform.isAndroid) {
    try {
      await custom_tabs.launch(
        url,
        customTabsOption: custom_tabs.CustomTabsOption(
          toolbarColor: null,
          enableUrlBarHiding: true,
          showPageTitle: true,
          enableDefaultShare: true,
        ),
        safariVCOption: custom_tabs.SafariViewControllerOption(
          preferredBarTintColor: null,
          preferredControlTintColor: null,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle:
              custom_tabs.SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // Fallback to external browser if Custom Tabs fails
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } else {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
