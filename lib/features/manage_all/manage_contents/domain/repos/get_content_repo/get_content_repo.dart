import 'package:flutter_link_previewer/flutter_link_previewer.dart';

typedef PreviewLinkDetails = ({String? title, String? description, String? previewUrl});

class GetContentRepo {
  static Future<PreviewLinkDetails?> getLinkPreviewData(String? link) async {
    if (link == null || link.isEmpty) return null;
    final data = await getPreviewData(link);
    return (title: data.title, description: data.description, previewUrl: data.image?.url);
  }
}

extension PreviewLinkDetailsExtension on PreviewLinkDetails {
  bool _checkIsNullOrEmpty(String? value) => value == null && (value != null && value.isEmpty);
  bool get isEmpty =>
      _checkIsNullOrEmpty(title) && _checkIsNullOrEmpty(description) && _checkIsNullOrEmpty(previewUrl);
}
