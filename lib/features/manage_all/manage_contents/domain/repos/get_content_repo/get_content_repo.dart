import 'dart:developer';
import 'dart:convert';
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show get;

typedef PreviewLinkDetails = ({String? title, String? description, String? previewUrl});

class GetContentRepo {
  static Future<PreviewLinkDetails?> getLinkPreviewData(String? link) async {
    if (link == null || link.isEmpty) return null;
    final data = await getPreviewData(link);
    log("lmao: ${data?.previewUrl}");
    return (title: data?.title, description: data?.description, previewUrl: data?.previewUrl);
  }
}

extension PreviewLinkDetailsExtension on PreviewLinkDetails {
  bool _checkIsNullOrEmpty(String? value) => value == null && (value != null && value.isEmpty);
  bool get isEmpty =>
      _checkIsNullOrEmpty(title) && _checkIsNullOrEmpty(description) && _checkIsNullOrEmpty(previewUrl);
}





String _calculateUrl(String baseUrl, String? proxy) {
  if (proxy != null) {
    return '$proxy$baseUrl';
  }
  return baseUrl;
}

String? _getMetaContent(Document document, String propertyValue) {
  final meta = document.getElementsByTagName('meta');
  final element = meta.firstWhere(
    (e) => e.attributes['property'] == propertyValue,
    orElse: () => meta.firstWhere((e) => e.attributes['name'] == propertyValue, orElse: () => Element.tag(null)),
  );
  return element.attributes['content']?.trim();
}

bool _hasUTF8Charset(Document document) {
  final emptyElement = Element.tag(null);
  final meta = document.getElementsByTagName('meta');
  final element = meta.firstWhere((e) => e.attributes.containsKey('charset'), orElse: () => emptyElement);
  if (element == emptyElement) return true;
  return element.attributes['charset']!.toLowerCase() == 'utf-8';
}

String? _getTitle(Document document) {
  final titleElements = document.getElementsByTagName('title');
  if (titleElements.isNotEmpty) return titleElements.first.text;

  return _getMetaContent(document, 'og:title') ??
      _getMetaContent(document, 'twitter:title') ??
      _getMetaContent(document, 'og:site_name');
}

String? _getDescription(Document document) =>
    _getMetaContent(document, 'og:description') ??
    _getMetaContent(document, 'description') ??
    _getMetaContent(document, 'twitter:description');

String? _getFirstImageUrl(Document document, String baseUrl) {
  final meta = document.getElementsByTagName('meta');
  var attribute = 'content';
  var elements = meta
      .where((e) => e.attributes['property'] == 'og:image' || e.attributes['property'] == 'twitter:image')
      .toList();

  if (elements.isEmpty) {
    elements = document.getElementsByTagName('img');
    attribute = 'src';
  }

  for (final element in elements) {
    final imageUrl = _getActualImageUrl(baseUrl, element.attributes[attribute]?.trim());
    if (imageUrl != null) return imageUrl;
  }

  return null;
}

String? _getActualImageUrl(String baseUrl, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty || imageUrl.startsWith('data')) {
    return null;
  }

  if (imageUrl.contains('.svg') || imageUrl.contains('.gif')) return null;

  if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';

  if (!imageUrl.startsWith('http')) {
    if (baseUrl.endsWith('/') && imageUrl.startsWith('/')) {
      imageUrl = '${baseUrl.substring(0, baseUrl.length - 1)}$imageUrl';
    } else if (!baseUrl.endsWith('/') && !imageUrl.startsWith('/')) {
      imageUrl = '$baseUrl/$imageUrl';
    } else {
      imageUrl = '$baseUrl$imageUrl';
    }
  }

  return imageUrl;
}

/// Parses provided text and returns preview data for the first found link.
Future<PreviewLinkDetails?> getPreviewData(
  String text, {
  String? proxy,
  Duration? requestTimeout,
  String? userAgent,
}) async {
  String? previewDataDescription;
  String? previewDataImage;
  String? previewDataTitle;

  try {
    const emailRegexp = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
    final emailRegexpPattern = RegExp(emailRegexp, caseSensitive: false);
    final textWithoutEmails = text.replaceAllMapped(emailRegexpPattern, (match) => '').trim();
    if (textWithoutEmails.isEmpty) return null;

    const linkRegex =
        r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]*[a-zA-Z_][\w_-]*)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?[^\.\s]';
    final urlRegexp = RegExp(linkRegex, caseSensitive: false);
    final matches = urlRegexp.allMatches(textWithoutEmails);
    if (matches.isEmpty) return null;

    var url = textWithoutEmails.substring(matches.first.start, matches.first.end);

    if (!url.toLowerCase().startsWith('http')) {
      url = 'https://$url';
    }

    final previewDataUrl = _calculateUrl(url, proxy);
    final uri = Uri.parse(previewDataUrl);
    final response = await http
        .get(uri, headers: {'User-Agent': userAgent ?? 'WhatsApp/2'})
        .timeout(requestTimeout ?? const Duration(seconds: 5));
    final document = parser.parse(utf8.decode(response.bodyBytes));

    const imageRegexp = r'image\/*';
    final imageRegexpPattern = RegExp(imageRegexp);

    if (imageRegexpPattern.hasMatch(response.headers['content-type'] ?? '')) {
      return (title: null, description: null, previewUrl: previewDataUrl);
    }

    if (!_hasUTF8Charset(document)) {
      return null;
    }

    final title = _getTitle(document);
    if (title != null) {
      previewDataTitle = title.trim();
    }

    final description = _getDescription(document);
    if (description != null) {
      previewDataDescription = description.trim();
    }

    final imageUrl = _getFirstImageUrl(document, url);
    if (imageUrl != null) {
      previewDataImage = _calculateUrl(imageUrl, proxy);
    }

    return (title: previewDataTitle, description: previewDataDescription, previewUrl: previewDataImage);
  } catch (e) {
    return null;
  }
}
