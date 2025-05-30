import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class UrlUtils {
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> shareUrl(String url, {String? title}) async {
    try {
      final text = title != null ? '$title\n\n$url' : url;
      await Share.share(text);
    } catch (e) {
      // Handle error silently
    }
  }

  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}