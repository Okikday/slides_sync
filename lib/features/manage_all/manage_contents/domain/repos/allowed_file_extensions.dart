/// Defines the allowed file extensions for various content types.
class AllowedFileExtensions {
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'tiff', 'svg'];

  static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'flv', 'mpeg', 'mpg'];

  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'csv',
    'rtf',
  ];

  static const List<String> allowedAudioExtensions = ['mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a'];

  /// Combined list plus additional useful extensions
  static const List<String> allowedExtensions = [
    ...allowedImageExtensions,
    ...allowedVideoExtensions,
    ...allowedDocumentExtensions,
    ...allowedAudioExtensions,
    'txt',
    'md',
    'html',
    'css',
    'js',
    'json',
    'xml',
    'yaml',
    'zip',
    'rar',
    '7z',
  ];
}
