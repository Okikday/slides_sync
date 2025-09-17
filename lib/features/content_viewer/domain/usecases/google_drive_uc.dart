// // drive_browser.dart
// import 'dart:async';
// import 'dart:io';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';

// /// Simple HTTP client that adds Authorization header for Drive API calls.
// class GoogleAuthClient extends http.BaseClient {
//   final String accessToken;
//   final http.Client _inner;

//   GoogleAuthClient(this.accessToken, [http.Client? inner]) : _inner = inner ?? IOClient();

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     request.headers['Authorization'] = 'Bearer $accessToken';
//     return _inner.send(request);
//   }

//   @override
//   void close() {
//     _inner.close();
//     super.close();
//   }
// }

// /// Types of Drive resources we can detect
// enum DriveResourceType {
//   unknown,
//   file,
//   folder,
//   googleDoc,
//   googleSheet,
//   googleSlide,
//   shortcut, // google drive shortcuts
// }

// /// Main helper class for Drive browsing + downloads
// class DriveBrowser {
//   final GoogleSignIn googleSignIn;
//   final drive.DriveApi driveApi;
//   final String? initialLink; // optional link passed at creation

//   String? resourceId; // extracted id from link (if any)
//   DriveResourceType detectedType = DriveResourceType.unknown;
//   drive.File? metadata; // last fetched metadata (if any)

//   DriveBrowser._(this.googleSignIn, this.driveApi, {this.initialLink});

//   /// Create from an already-signed-in GoogleSignIn instance.
//   /// Optionally pass a `link` and set `autoFetchMetadata` true to call files.get()
//   /// during creation to confirm the resource type.
//   static Future<DriveBrowser> createFromLink(
//     GoogleSignIn googleSignIn, {
//     String? link,
//     bool autoFetchMetadata = true,
//   }) async {
//     final account = googleSignIn.currentUser;
//     if (account == null) {
//       throw StateError('No GoogleSignIn account available. User must sign in first.');
//     }
//     final auth = await account.authentication;
//     final token = auth.accessToken;
//     if (token == null || token.isEmpty) {
//       throw StateError('No access token. Ensure Drive scopes were requested at sign-in.');
//     }

//     final client = GoogleAuthClient(token);
//     final api = drive.DriveApi(client);

//     final browser = DriveBrowser._(googleSignIn, api, initialLink: link);

//     // If link provided, do a heuristic detection immediately
//     if (link != null) {
//       browser.resourceId = _extractDriveIdFromLink(link);
//       browser.detectedType = _detectTypeFromUrl(link);
//     }

//     // Optionally fetch metadata to confirm & set real type
//     if (autoFetchMetadata && browser.resourceId != null) {
//       try {
//         final f = await browser.getFileMetadata(browser.resourceId!);
//         browser.metadata = f;

//         // Determine type from mimeType
//         final mt = (f.mimeType ?? '').toLowerCase();
//         if (mt == 'application/vnd.google-apps.folder') {
//           browser.detectedType = DriveResourceType.folder;
//         } else if (mt.startsWith('application/vnd.google-apps.document')) {
//           browser.detectedType = DriveResourceType.googleDoc;
//         } else if (mt.startsWith('application/vnd.google-apps.spreadsheet')) {
//           browser.detectedType = DriveResourceType.googleSheet;
//         } else if (mt.startsWith('application/vnd.google-apps.presentation')) {
//           browser.detectedType = DriveResourceType.googleSlide;
//         } else if (mt == 'application/vnd.google-apps.shortcut') {
//           browser.detectedType = DriveResourceType.shortcut;
//         } else {
//           browser.detectedType = DriveResourceType.file;
//         }
//       } catch (e) {
//         // ignore metadata fetch errors here (e.g., 403) and keep the heuristic detection
//       }
//     }

//     return browser;
//   }

//   /// Convenience: create DriveApi when you only have GoogleSignIn and want a DriveBrowser without link
//   static Future<DriveBrowser> create(GoogleSignIn googleSignIn) async {
//     return createFromLink(googleSignIn, link: null, autoFetchMetadata: false);
//   }

//   /// Extracts an ID from common Drive link patterns.
//   /// Returns null if no id was found.
//   static String? _extractDriveIdFromLink(String url) {
//     final regexes = [
//       RegExp(r'/d/([a-zA-Z0-9_-]+)'), // /d/<id>/
//       RegExp(r'folders/([a-zA-Z0-9_-]+)'), // /folders/<id>
//       RegExp(r'[?&]id=([a-zA-Z0-9_-]+)'), // ?id=<id>
//       RegExp(r'/file/d/([a-zA-Z0-9_-]+)'), // same as /d/
//     ];
//     for (final r in regexes) {
//       final m = r.firstMatch(url);
//       if (m != null && m.groupCount >= 1) return m.group(1);
//     }
//     return null;
//   }

//   /// Heuristic detection from the URL itself (fast, no network)
//   static DriveResourceType _detectTypeFromUrl(String url) {
//     final lower = url.toLowerCase();
//     if (lower.contains('/folders/') || lower.contains('drive/folders')) return DriveResourceType.folder;
//     if (lower.contains('/file/d/') || lower.contains('/d/')) return DriveResourceType.file;
//     if (lower.contains('docs.google.com/document')) return DriveResourceType.googleDoc;
//     if (lower.contains('docs.google.com/spreadsheets')) return DriveResourceType.googleSheet;
//     if (lower.contains('docs.google.com/presentation') || lower.contains('presentation/d'))
//       return DriveResourceType.googleSlide;
//     if (lower.contains('/open?id=')) return DriveResourceType.file;
//     return DriveResourceType.unknown;
//   }

//   /// Get Drive API (already available as property) — exposed for convenience
//   drive.DriveApi get api => driveApi;

//   /// Fetch metadata for a file/folder by id (uses restricted $fields for smaller payload)
//   /// Throws ApiRequestError / HttpException on errors — caller should catch.
//   Future<drive.File> getFileMetadata(String fileId) async {
//     final f = await driveApi.files.get(
//       fileId,
//       $fields: 'id,name,mimeType,size,modifiedTime,webViewLink,webContentLink,owners,permissions,parents,driveId',
//       supportsAllDrives: true,
//       downloadOptions: drive.DownloadOptions.metadata,
//     );
//     metadata = f as drive.File;
//     return f;
//   }

//   /// List folder contents (will page through all pages unless you override pageSize)
//   Future<List<drive.File>> listFolderContents(String folderId, {int pageSize = 100}) async {
//     String? pageToken;
//     final List<drive.File> files = [];
//     do {
//       final resp = await driveApi.files.list(
//         q: "'$folderId' in parents and trashed=false",
//         $fields: 'nextPageToken, files(id,name,mimeType,size,modifiedTime,kind)',
//         pageSize: pageSize,
//         pageToken: pageToken,
//         supportsAllDrives: true,
//         includeItemsFromAllDrives: true,
//       );
//       if (resp.files != null) files.addAll(resp.files!);
//       pageToken = resp.nextPageToken;
//     } while (pageToken != null);
//     return files;
//   }

//   /// Download binary file bytes via the REST endpoint alt=media
//   /// Returns http.Response with bodyBytes — check statusCode for 200.
//   Future<http.Response> downloadFileBytes(String fileId) async {
//     // Get token through GoogleSignIn currentUser.authentication
//     final account = googleSignIn.currentUser;
//     if (account == null) throw StateError('No signed in account.');
//     final auth = await account.authentication;
//     final accessToken = auth.accessToken;
//     if (accessToken == null) throw StateError('No access token available.');

//     final client = GoogleAuthClient(accessToken);
//     final url = 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
//     final resp = await client.get(Uri.parse(url));
//     client.close();
//     return resp;
//   }

//   /// Export Google native file (Docs/Sheets/Slides) to the requested mimeType.
//   /// e.g. mimeType = 'application/pdf'
//   Future<http.Response> exportGoogleDoc(String fileId, {required String mimeType}) async {
//     final account = googleSignIn.currentUser;
//     if (account == null) throw StateError('No signed in account.');
//     final auth = await account.authentication;
//     final accessToken = auth.accessToken;
//     if (accessToken == null) throw StateError('No access token available.');

//     final client = GoogleAuthClient(accessToken);
//     final url = 'https://www.googleapis.com/drive/v3/files/$fileId/export?mimeType=${Uri.encodeComponent(mimeType)}';
//     final resp = await client.get(Uri.parse(url));
//     client.close();
//     return resp;
//   }

//   /// Utility: detects if a mimeType represents a Google-native doc (Docs/Sheets/Slides)
//   static bool isGoogleNativeMimeType(String? mimeType) {
//     if (mimeType == null) return false;
//     return mimeType.startsWith('application/vnd.google-apps.');
//   }

//   /// Convenience: detect whether the resource is a folder/file/etc based on known info.
//   /// If you have `metadata` already fetched, this uses it; otherwise uses the heuristic.
//   DriveResourceType getEffectiveResourceType() {
//     if (metadata != null) {
//       final mt = (metadata!.mimeType ?? '').toLowerCase();
//       if (mt == 'application/vnd.google-apps.folder') return DriveResourceType.folder;
//       if (mt.startsWith('application/vnd.google-apps.document')) return DriveResourceType.googleDoc;
//       if (mt.startsWith('application/vnd.google-apps.spreadsheet')) return DriveResourceType.googleSheet;
//       if (mt.startsWith('application/vnd.google-apps.presentation')) return DriveResourceType.googleSlide;
//       if (mt == 'application/vnd.google-apps.shortcut') return DriveResourceType.shortcut;
//       return DriveResourceType.file;
//     }
//     return detectedType;
//   }

//   /// If you only have a link and want to fetch & return metadata (convenience)
//   Future<drive.File> fetchMetadataForLink(String link) async {
//     final id = _extractDriveIdFromLink(link);
//     if (id == null) throw ArgumentError('Could not extract Drive ID from link.');
//     final f = await getFileMetadata(id);
//     resourceId = id;
//     metadata = f;
//     return f;
//   }

//   Future<http.Response> downloadDriveFileWithFallback({
//     required String fileId,
//     String? apiKey, // optional: use API key for public access if available
//     GoogleSignIn? googleSignIn, // optional: fallback to auth if public fetch fails
//   }) async {
//     // 1) Try public download via Drive REST alt=media using API key (fast & reliable)
//     if (apiKey != null) {
//       final publicUrl = Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?alt=media&key=$apiKey');
//       final r = await http.get(publicUrl);
//       if (r.statusCode == 200) return r;
//       // if 403/404 -> not public or API key can't access -> fall through to unauthenticated direct url
//     }

//     // 2) Try direct "uc?export=download" approach (works for many public files)
//     try {
//       final direct = Uri.parse('https://drive.google.com/uc?export=download&id=$fileId');
//       final r2 = await http.get(direct);
//       if (r2.statusCode == 200) return r2;
//       // Some large files or virus-check pages require a confirm token flow; in those cases
//       // direct download may return a HTML page instead of file bytes. We'll fall back to OAuth.
//     } catch (_) {
//       // ignore and try OAuth fallback
//     }

//     // 3) Fallback to OAuth (requires signed in user with Drive scope)
//     if (googleSignIn == null || googleSignIn.currentUser == null) {
//       throw StateError('File not public and no authenticated GoogleSignIn available.');
//     }
//     final account = googleSignIn.currentUser!;
//     final auth = await account.authentication;
//     final token = auth.accessToken;
//     if (token == null) {
//       throw StateError('Missing access token. Ensure Drive scopes (drive.readonly) requested.');
//     }
//     final authedClient = http.Client();
//     final req = Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?alt=media');
//     final r3 = await authedClient.get(req, headers: {'Authorization': 'Bearer $token'});
//     authedClient.close();
//     return r3; // r3.statusCode == 200 => bytes available; else error
//   }
// }
