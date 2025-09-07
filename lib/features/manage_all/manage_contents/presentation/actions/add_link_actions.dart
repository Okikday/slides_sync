import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';

class AddLinkActions {
  static void pasteFromClipboard(TextEditingController linkInputController) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) return;

    final reader = await clipboard.read();

    // Check for URI first (links have priority)
    if (reader.canProvide(Formats.uri)) {
      final NamedUri? namedUri = await reader.readValue(Formats.uri);
      if (namedUri != null && namedUri.uri.toString().isNotEmpty) {
        linkInputController.text = namedUri.uri.toString();
        return;
      }
    }

    // Fallback to plain text and validate if it's a link
    if (reader.canProvide(Formats.plainText)) {
      final String? clipboardText = await reader.readValue(Formats.plainText);
      if (clipboardText != null && clipboardText.isNotEmpty) {
        final text = clipboardText.trim();

        // Try to extract link from text
        final extractedLink = _extractLinkFromText(text);
        if (extractedLink != null) {
          linkInputController.text = extractedLink;
          return;
        }

        // If no link found but text exists, use it as fallback
        linkInputController.text = text;
      }
    }
  }

  static String? _extractLinkFromText(String text) {
    // Check if entire text is a valid URL
    final uri = Uri.tryParse(text);
    if (uri != null && _isValidWebUrl(uri)) {
      return text;
    }

    // Look for URLs within the text using regex
    final urlRegex = RegExp(r'https?://[^\s<>"{}|\\^`\[\]]+', caseSensitive: false, multiLine: true);

    final matches = urlRegex.allMatches(text);
    if (matches.isNotEmpty) {
      // Return the most recent (last) link found
      return matches.last.group(0);
    }

    // Look for www. patterns and add https://
    final wwwRegex = RegExp(r'www\.[^\s<>"{}|\\^`\[\]]+', caseSensitive: false, multiLine: true);

    final wwwMatches = wwwRegex.allMatches(text);
    if (wwwMatches.isNotEmpty) {
      return 'https://${wwwMatches.last.group(0)}';
    }

    return null;
  }

  static bool _isValidWebUrl(Uri uri) {
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'ftp') && uri.hasAuthority;
  }
}
