// AI GENERATED
// drive_browser.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum DriveResourceType { unknown, file, folder, googleDoc, googleSheet, googleSlide, shortcut }

/// Enhanced model representing the Drive file metadata with additional useful fields.
class DriveFile {
  final String? id;
  final String? name;
  final String? mimeType;
  final String? size; // Drive returns size as string for binary files
  final String? webViewLink;
  final String? webContentLink;
  final List<String>? parents;
  final String? modifiedTime;
  final String? createdTime;
  final String? description;
  final String? fileExtension;
  final String? originalFilename;
  final bool? starred;
  final bool? trashed;
  final String? iconLink;
  final String? thumbnailLink;
  final String? md5Checksum;

  // Owner information
  final String? ownerDisplayName;
  final String? ownerEmail;
  final String? ownerPhotoLink;

  // Sharing and permissions
  final bool? shared;
  final bool? viewedByMe;
  final String? lastModifyingUserDisplayName;
  final String? lastModifyingUserEmail;

  // Additional metadata
  final int? version;
  final bool? hasAugmentedPermissions;
  final bool? isAppAuthorized;

  DriveFile({
    this.id,
    this.name,
    this.mimeType,
    this.size,
    this.webViewLink,
    this.webContentLink,
    this.parents,
    this.modifiedTime,
    this.createdTime,
    this.description,
    this.fileExtension,
    this.originalFilename,
    this.starred,
    this.trashed,
    this.iconLink,
    this.thumbnailLink,
    this.md5Checksum,
    this.ownerDisplayName,
    this.ownerEmail,
    this.ownerPhotoLink,
    this.shared,
    this.viewedByMe,
    this.lastModifyingUserDisplayName,
    this.lastModifyingUserEmail,
    this.version,
    this.hasAugmentedPermissions,
    this.isAppAuthorized,
  });

  factory DriveFile.fromJson(Map<String, dynamic> j) {
    final owners = j['owners'] as List<dynamic>?;
    final firstOwner = owners?.isNotEmpty == true ? owners!.first as Map<String, dynamic>? : null;

    final lastModifyingUser = j['lastModifyingUser'] as Map<String, dynamic>?;

    return DriveFile(
      id: j['id'] as String?,
      name: j['name'] as String?,
      mimeType: j['mimeType'] as String?,
      size: j['size']?.toString(),
      webViewLink: j['webViewLink'] as String?,
      webContentLink: j['webContentLink'] as String?,
      parents: (j['parents'] as List<dynamic>?)?.map((e) => e as String).toList(),
      modifiedTime: j['modifiedTime'] as String?,
      createdTime: j['createdTime'] as String?,
      description: j['description'] as String?,
      fileExtension: j['fileExtension'] as String?,
      originalFilename: j['originalFilename'] as String?,
      starred: j['starred'] as bool?,
      trashed: j['trashed'] as bool?,
      iconLink: j['iconLink'] as String?,
      thumbnailLink: j['thumbnailLink'] as String?,
      md5Checksum: j['md5Checksum'] as String?,
      ownerDisplayName: firstOwner?['displayName'] as String?,
      ownerEmail: firstOwner?['emailAddress'] as String?,
      ownerPhotoLink: firstOwner?['photoLink'] as String?,
      shared: j['shared'] as bool?,
      viewedByMe: j['viewedByMe'] as bool?,
      lastModifyingUserDisplayName: lastModifyingUser?['displayName'] as String?,
      lastModifyingUserEmail: lastModifyingUser?['emailAddress'] as String?,
      version: j['version'] is String ? int.tryParse(j['version'] as String) : j['version'] as int?,
      hasAugmentedPermissions: j['hasAugmentedPermissions'] as bool?,
      isAppAuthorized: j['isAppAuthorized'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mimeType': mimeType,
    'size': size,
    'webViewLink': webViewLink,
    'webContentLink': webContentLink,
    'parents': parents,
    'modifiedTime': modifiedTime,
    'createdTime': createdTime,
    'description': description,
    'fileExtension': fileExtension,
    'originalFilename': originalFilename,
    'starred': starred,
    'trashed': trashed,
    'iconLink': iconLink,
    'thumbnailLink': thumbnailLink,
    'md5Checksum': md5Checksum,
    'ownerDisplayName': ownerDisplayName,
    'ownerEmail': ownerEmail,
    'ownerPhotoLink': ownerPhotoLink,
    'shared': shared,
    'viewedByMe': viewedByMe,
    'lastModifyingUserDisplayName': lastModifyingUserDisplayName,
    'lastModifyingUserEmail': lastModifyingUserEmail,
    'version': version,
    'hasAugmentedPermissions': hasAugmentedPermissions,
    'isAppAuthorized': isAppAuthorized,
  };

  /// Helper to get formatted file size
  String get formattedSize {
    if (size == null) return 'Unknown';
    final bytes = int.tryParse(size!);
    if (bytes == null) return 'Unknown';

    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Helper to check if this is a Google native file type
  bool get isGoogleNative {
    return mimeType?.startsWith('application/vnd.google-apps.') ?? false;
  }
}

/// Single unified resource result: either a file (metadata) or a folder with children metadata.
class DriveResource {
  final DriveResourceType type;
  final DriveFile? file; // present for file-like resources
  final List<DriveFile>? children; // present for folders (one-level listing)

  DriveResource({required this.type, this.file, this.children});
}

/// Streamlined DriveBrowser focusing on resource fetching and downloading.
/// All methods are now static and isolate-friendly.
class DriveBrowser {
  // Private constructor to prevent instantiation
  DriveBrowser._();

  // /// Get API key from environment or parameter
  // static String _getApiKey([String? apiKey]) {
  //   return apiKey ?? dotenv.env['DRIVE_API_KEY'] ?? '';
  // }

  /// Create a new HTTP client for each request (isolate-friendly)
  static http.Client _createHttpClient() {
    return http.Client();
  }

  /// ID extraction helper
  static String? _extractDriveIdFromLink(String url) {
    final regexes = [
      RegExp(r'/d/([a-zA-Z0-9_-]+)'),
      RegExp(r'folders/([a-zA-Z0-9_-]+)'),
      RegExp(r'[?&]id=([a-zA-Z0-9_-]+)'),
      RegExp(r'/file/d/([a-zA-Z0-9_-]+)'),
    ];
    for (final r in regexes) {
      final m = r.firstMatch(url);
      if (m != null && m.groupCount >= 1) return m.group(1);
    }
    return null;
  }

  /// Comprehensive fields for enhanced metadata
  static const String _fileFields =
      'id,name,mimeType,size,modifiedTime,createdTime,'
      'webViewLink,webContentLink,parents,description,fileExtension,originalFilename,'
      'starred,trashed,iconLink,thumbnailLink,md5Checksum,owners,shared,viewedByMe,'
      'lastModifyingUser,version,hasAugmentedPermissions,isAppAuthorized';

  /// Fetch enhanced metadata for a file by id using API key.
  static Future<DriveFile> getFileMetadata(String fileId, {required String apiKey}) async {
    final client = _createHttpClient();
    try {
      if (apiKey.isEmpty) throw ArgumentError('API key is required');

      final url = Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=$_fileFields&key=${Uri.encodeComponent(apiKey)}',
      );
      final r = await client.get(url);
      if (r.statusCode == 200) {
        final jsonMap = json.decode(r.body) as Map<String, dynamic>;
        return DriveFile.fromJson(jsonMap);
      } else {
        throw HttpException('Failed to fetch metadata (status ${r.statusCode}): ${r.body}', uri: url);
      }
    } finally {
      client.close();
    }
  }

  /// List folder contents with enhanced metadata
  static Future<List<DriveFile>> listFolderContents(
    String folderId, {
    required String apiKey,
    int pageSize = 100,
  }) async {
    final client = _createHttpClient();
    try {
      if (apiKey.isEmpty) throw ArgumentError('API key is required');

      final List<DriveFile> files = [];
      String? pageToken;
      do {
        final q = Uri.encodeQueryComponent("'$folderId' in parents and trashed=false");
        final url = Uri.parse(
          'https://www.googleapis.com/drive/v3/files?q=$q&fields=nextPageToken,files($_fileFields)&pageSize=$pageSize&key=${Uri.encodeComponent(apiKey)}${pageToken != null ? '&pageToken=${Uri.encodeQueryComponent(pageToken)}' : ''}',
        );
        final r = await client.get(url);
        if (r.statusCode != 200) {
          throw HttpException('Failed to list folder (status ${r.statusCode}): ${r.body}', uri: url);
        }
        final map = json.decode(r.body) as Map<String, dynamic>;
        final rawFiles = (map['files'] as List<dynamic>?);
        if (rawFiles != null) {
          for (final f in rawFiles) {
            files.add(DriveFile.fromJson(f as Map<String, dynamic>));
          }
        }
        pageToken = map['nextPageToken'] as String?;
      } while (pageToken != null);
      return files;
    } finally {
      client.close();
    }
  }

  /// Given a Drive link (or id), return a single DriveResource describing the item.
  ///
  /// - If the resource is a file (including Google-native docs) -> type=file, `file` populated.
  /// - If the resource is a folder -> type=folder, `children` populated (one-level listing).
  static Future<DriveResource> fetchResourceFromLink(String link, {required String apiKey}) async {
    final id = _extractDriveIdFromLink(link);
    if (id == null) throw ArgumentError('Could not extract Drive ID from link.');

    final meta = await getFileMetadata(id, apiKey: apiKey);
    final mt = (meta.mimeType ?? '').toLowerCase();

    if (mt == 'application/vnd.google-apps.folder') {
      final children = await listFolderContents(id, apiKey: apiKey);
      return DriveResource(type: DriveResourceType.folder, file: meta, children: children);
    }

    if (mt.startsWith('application/vnd.google-apps.document')) {
      return DriveResource(type: DriveResourceType.googleDoc, file: meta);
    }
    if (mt.startsWith('application/vnd.google-apps.spreadsheet')) {
      return DriveResource(type: DriveResourceType.googleSheet, file: meta);
    }
    if (mt.startsWith('application/vnd.google-apps.presentation')) {
      return DriveResource(type: DriveResourceType.googleSlide, file: meta);
    }
    if (mt == 'application/vnd.google-apps.shortcut') {
      return DriveResource(type: DriveResourceType.shortcut, file: meta);
    }

    return DriveResource(type: DriveResourceType.file, file: meta);
  }

  /// Download a Drive file with multiple fallback strategies.
  /// Returns the HTTP response - caller should check statusCode == 200 and use resp.bodyBytes.
  static Future<http.Response> downloadDriveFile({required String fileId, required String apiKey}) async {
    final client = _createHttpClient();
    try {
      if (apiKey.isEmpty) throw ArgumentError('API key is required');

      // 1) Try REST alt=media using the API key (best for publicly accessible files)
      try {
        final url = Uri.parse(
          'https://www.googleapis.com/drive/v3/files/$fileId?alt=media&key=${Uri.encodeComponent(apiKey)}',
        );
        final r = await client.get(url);
        if (r.statusCode == 200) return r;
      } catch (_) {
        // Continue to fallback
      }

      // 2) Try direct uc?export=download (works for many publicly-shared items)
      try {
        final direct = Uri.parse('https://drive.google.com/uc?export=download&id=$fileId');
        final r2 = await client.get(direct);
        if (r2.statusCode == 200) {
          final contentType = r2.headers['content-type'] ?? '';
          // Crude heuristic: if not HTML, return as file bytes
          if (!contentType.toLowerCase().contains('text/html')) {
            return r2;
          }
        }
      } catch (_) {
        // Continue to error
      }

      // 3) No success with available methods
      throw StateError('Unable to download file with API key; file might be private or not publicly accessible.');
    } finally {
      client.close();
    }
  }

  /// Export Google native files (Docs, Sheets, Slides) to a specified format.
  /// Common export formats:
  /// - Google Docs: 'application/pdf', 'text/plain', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  /// - Google Sheets: 'application/pdf', 'text/csv', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  /// - Google Slides: 'application/pdf', 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  static Future<http.Response> exportGoogleFile({
    required String fileId,
    required String mimeType,
    required String apiKey,
  }) async {
    final client = _createHttpClient();
    try {
      if (apiKey.isEmpty) throw ArgumentError('API key is required');

      final url = Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$fileId/export?mimeType=${Uri.encodeComponent(mimeType)}&key=${Uri.encodeComponent(apiKey)}',
      );

      final r = await client.get(url);
      if (r.statusCode == 200) {
        return r;
      } else {
        throw HttpException('Failed to export file (status ${r.statusCode}): ${r.body}', uri: url);
      }
    } finally {
      client.close();
    }
  }

  /// Check if a file is publicly accessible with the current API key.
  static Future<bool> isFileAccessible(String fileId, {required String apiKey}) async {
    final client = _createHttpClient();
    try {
      if (apiKey.isEmpty) return false;

      final url = Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$fileId?fields=id&key=${Uri.encodeComponent(apiKey)}',
      );
      final r = await client.get(url);
      return r.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  /// Determines whether a given URL is a Google Drive link (offline check).
  ///
  /// This function checks for various Google Drive URL patterns including:
  /// - drive.google.com/file/d/[ID]
  /// - drive.google.com/drive/folders/[ID]
  /// - drive.google.com/open?id=[ID]
  /// - docs.google.com/document/d/[ID]
  /// - docs.google.com/spreadsheets/d/[ID]
  /// - docs.google.com/presentation/d/[ID]
  /// - And other common Drive URL formats
  ///
  /// Returns `true` if the URL matches Google Drive patterns, `false` otherwise.
  static bool isGoogleDriveLink(String url) {
    if (url.isEmpty) return false;

    // Normalize the URL - handle cases without protocol
    String normalizedUrl = url.toLowerCase().trim();
    if (!normalizedUrl.startsWith('http')) {
      normalizedUrl = 'https://$normalizedUrl';
    }

    try {
      final uri = Uri.parse(normalizedUrl);
      final host = uri.host.toLowerCase();
      final path = uri.path;
      final query = uri.query;

      // Check for Google Drive domains
      final driveHosts = ['drive.google.com', 'docs.google.com', 'sheets.google.com', 'slides.google.com'];

      if (!driveHosts.any((driveHost) => host == driveHost || host.endsWith('.$driveHost'))) {
        return false;
      }

      // Define regex patterns for different Drive URL formats
      final drivePatterns = [
        // Standard file links: /file/d/[ID] or /d/[ID]
        RegExp(r'/(?:file/)?d/[a-zA-Z0-9_-]+'),

        // Folder links: /drive/folders/[ID] or /folders/[ID]
        RegExp(r'/(?:drive/)?folders/[a-zA-Z0-9_-]+'),

        // Google Docs/Sheets/Slides: /document/d/[ID], /spreadsheets/d/[ID], /presentation/d/[ID]
        RegExp(r'/(?:document|spreadsheets|presentation)/d/[a-zA-Z0-9_-]+'),

        // Legacy open links with id parameter
        RegExp(r'/open\?.*id=[a-zA-Z0-9_-]+'),

        // Direct id parameter
        RegExp(r'[?&]id=[a-zA-Z0-9_-]+'),

        // Edit links
        RegExp(r'/(?:document|spreadsheets|presentation)/d/[a-zA-Z0-9_-]+/edit'),

        // View links
        RegExp(r'/(?:document|spreadsheets|presentation)/d/[a-zA-Z0-9_-]+/view'),

        // Drive home/shared paths that contain file references
        RegExp(r'/drive/(?:my-drive|shared|recent)'),
      ];

      // Check if path matches any Drive pattern
      for (final pattern in drivePatterns) {
        if (pattern.hasMatch(path)) {
          return true;
        }
      }

      // Also check query parameters for id
      if (query.isNotEmpty && RegExp(r'(?:^|&)id=[a-zA-Z0-9_-]+(?:&|$)').hasMatch(query)) {
        return true;
      }

      return false;
    } catch (e) {
      // If URL parsing fails, it's not a valid Drive link
      return false;
    }
  }

  /// Alternative simpler version that just checks for common patterns
  /// without full URI parsing (more permissive but faster)
  static bool isGoogleDriveLinkSimple(String url) {
    if (url.isEmpty) return false;

    final normalizedUrl = url.toLowerCase().trim();

    // Check for Google Drive domains
    if (!normalizedUrl.contains('drive.google.com') &&
        !normalizedUrl.contains('docs.google.com') &&
        !normalizedUrl.contains('sheets.google.com') &&
        !normalizedUrl.contains('slides.google.com')) {
      return false;
    }

    // Check for Drive ID patterns (Drive IDs are typically 25-50 characters)
    final driveIdPatterns = [
      RegExp(r'/d/[a-zA-Z0-9_-]{25,}'),
      RegExp(r'folders/[a-zA-Z0-9_-]{25,}'),
      RegExp(r'[?&]id=[a-zA-Z0-9_-]{25,}'),
    ];

    return driveIdPatterns.any((pattern) => pattern.hasMatch(normalizedUrl));
  }
}
