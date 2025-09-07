import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_contents_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/providers/add_contents_bs_provider.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_from_clipboard_dialog/sub/build_add_from_clipboard_dialog.dart';

class AddFromClipboardOverlay extends ConsumerStatefulWidget {
  final AppClipboardData clipboardData;
  const AddFromClipboardOverlay({super.key, required this.clipboardData});

  @override
  ConsumerState<AddFromClipboardOverlay> createState() => _AddFromClipboardOverlayState();
}

class _AddFromClipboardOverlayState extends ConsumerState<AddFromClipboardOverlay> {
  @override
  void initState() {
    super.initState();
  }

  void _closeOverlay([bool inPostFrameCallback = true]) {
    void close() {
      final isVisibleProvider = ref.read(AddContentsBsProvider.addFromClipboardOverlayEntry.notifier);
      if (isVisibleProvider.state == null) return;
      isVisibleProvider.state?.remove();
      isVisibleProvider.update((cb) => null);
      log("Successfully closed AddFromClipboardOverlay");
    }

    if (inPostFrameCallback) {
      WidgetsBinding.instance.addPostFrameCallback((_) => close());
    } else {
      close();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BuildAddFromClipboardDialog(clipboardData: widget.clipboardData, closeOverlay: _closeOverlay);
  }
}

// class BuildAddFromClipboardDialog extends ConsumerWidget {
//   final void Function([bool inInitPostFrame]) closeOverlay;
//   final AppClipboardData clipboardData;
//   const BuildAddFromClipboardDialog({super.key, required this.closeOverlay, required this.clipboardData});

//   Widget _buildImageDialog(BuildContext context, AppThemeModel theme, String title, Widget imageWidget) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         title,
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ClipRSuperellipse(borderRadius: BorderRadius.circular(20), child: imageWidget),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMultiImageDialog(BuildContext context, AppThemeModel theme, List<Uint8List> imagesData) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         "Add the following ${imagesData.length} images from your clipboard to this collection?",
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Flexible(
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                           ),
//                           itemCount: imagesData.length,
//                           itemBuilder: (context, index) {
//                             return ClipRSuperellipse(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.memory(imagesData[index], fit: BoxFit.cover),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFileDialog(BuildContext context, AppThemeModel theme, String filePath, {bool single = false}) {
//     final fileName = filePath.split('/').last;
//     final isImage = _isImageFile(filePath);

//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         "Add the following ${isImage ? 'image' : 'file'} from your clipboard to this collection?",
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       if (isImage)
//                         ClipRSuperellipse(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image.file(
//                             File(filePath),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 width: 100,
//                                 height: 100,
//                                 color: theme.onBackground.withValues(alpha: 0.1),
//                                 child: Icon(Icons.broken_image, color: theme.onBackground),
//                               );
//                             },
//                           ),
//                         )
//                       else
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: theme.onBackground.withValues(alpha: 0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: [
//                               Icon(Icons.description, size: 48, color: theme.onBackground),
//                               const SizedBox(height: 8),
//                               CustomText(fileName, color: theme.onBackground, fontSize: 14, textAlign: TextAlign.center),
//                             ],
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMultiFileDialog(BuildContext context, AppThemeModel theme, List<String> filePaths) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         "Add the following ${filePaths.length} files from your clipboard to this collection?",
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Flexible(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: filePaths.length,
//                           itemBuilder: (context, index) {
//                             final filePath = filePaths[index];
//                             final fileName = filePath.split('/').last;
//                             final isImage = _isImageFile(filePath);

//                             return Container(
//                               margin: const EdgeInsets.only(bottom: 8),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: theme.onBackground.withValues(alpha: 0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   if (isImage)
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(4),
//                                       child: Image.file(
//                                         File(filePath),
//                                         width: 40,
//                                         height: 40,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Container(
//                                             width: 40,
//                                             height: 40,
//                                             color: theme.onBackground.withValues(alpha: 0.2),
//                                             child: Icon(Icons.broken_image, size: 20, color: theme.onBackground),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                   else
//                                     Icon(Icons.description, size: 40, color: theme.onBackground),
//                                   const SizedBox(width: 12),
//                                   Expanded(child: CustomText(fileName, color: theme.onBackground, fontSize: 14)),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextDialog(BuildContext context, AppThemeModel theme, String textData) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         "Add the following text from your clipboard to this collection?",
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Container(
//                         constraints: const BoxConstraints(maxHeight: 200),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: theme.onBackground.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SingleChildScrollView(
//                           child: CustomText(textData, color: theme.onBackground, fontSize: 14),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHtmlDialog(BuildContext context, AppThemeModel theme, String htmlData) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => closeOverlay(false),
//             child: Container(width: double.infinity, height: double.infinity, color: Colors.black54),
//           ),
//           Center(
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 0,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                     child: const OrganicBackgroundEffect(),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
//                   margin: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.background,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
//                   ),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomText(
//                         "Add the following HTML content from your clipboard to this collection?",
//                         color: theme.onBackground,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Container(
//                         constraints: const BoxConstraints(maxHeight: 200),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: theme.onBackground.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SingleChildScrollView(
//                           child: CustomText(htmlData, color: theme.onBackground, fontSize: 12, fontFamily: 'monospace'),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildActionButtons(context, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, AppThemeModel theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {
//               closeOverlay(false);
//             },
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: theme.onBackground.withValues(alpha: 0.3)),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: CustomText("Cancel", color: theme.onBackground, fontSize: 14),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () {
//               closeOverlay(false);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: theme.primaryColor,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: CustomText("Add", color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ],
//     );
//   }

//   bool _isImageFile(String path) {
//     final extension = path.toLowerCase().split('.').last;
//     return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff', 'heic', 'heif', 'svg'].contains(extension);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = ref.theme;
//     switch (clipboardData.contentType) {
//       case AppClipboardContentType.image:
//         final Result<Uint8List?> result = Result.tryRun<Uint8List>(() => clipboardData.data as Uint8List);
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final Uint8List imageData = result.data!;

//         return _buildImageDialog(
//           context,
//           theme,
//           "Add the following image from your clipboard to this collection?",
//           Image.memory(imageData, width: 100, height: 100, fit: BoxFit.cover),
//         );

//       case AppClipboardContentType.images:
//         final Result<List<Uint8List>?> result = Result.tryRun<List<Uint8List>>(
//           () => clipboardData.data as List<Uint8List>,
//         );
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final List<Uint8List> imagesData = result.data!;

//         return _buildMultiImageDialog(context, theme, imagesData);

//       case AppClipboardContentType.file:
//         final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final String filePath = result.data!;

//         return _buildFileDialog(context, theme, filePath, single: true);

//       case AppClipboardContentType.files:
//         final Result<List<String>?> result = Result.tryRun<List<String>>(() => clipboardData.data as List<String>);
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final List<String> filePaths = result.data!;

//         return _buildMultiFileDialog(context, theme, filePaths);

//       case AppClipboardContentType.text:
//         final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final String textData = result.data!;

//         return _buildTextDialog(context, theme, textData);

//       case AppClipboardContentType.html:
//         final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
//         if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
//           closeOverlay();
//           return const SizedBox();
//         }
//         final String htmlData = result.data!;

//         return _buildHtmlDialog(context, theme, htmlData);

//       default:
//         closeOverlay();
//         return const SizedBox();
//     }
//   }
// }
