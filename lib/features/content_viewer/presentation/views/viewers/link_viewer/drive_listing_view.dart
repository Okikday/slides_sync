import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/content_viewer/domain/services/drive_browser.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// AI GENERATED!
// Navigation history provider - made auto dispose
final navigationHistoryProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final currentFolderIdProvider = StateProvider.autoDispose<String?>((ref) => null);

// Drive resource provider - made auto dispose with proper caching
final driveResourceProvider = FutureProvider.autoDispose.family<DriveResource, String?>((ref, folderId) async {
  if (folderId == null) {
    throw ArgumentError('Folder ID cannot be null');
  }
  
  final browser = DriveBrowser.instance;
  
  // Handle both URLs and file IDs
  String linkToFetch;
  if (folderId.startsWith('http')) {
    linkToFetch = folderId;
  } else {
    // Check if it looks like a file ID or folder ID by trying to get metadata first
    try {
      final metadata = await browser.getFileMetadata(folderId);
      final mimeType = metadata.mimeType ?? '';
      
      if (mimeType == 'application/vnd.google-apps.folder') {
        linkToFetch = 'https://drive.google.com/drive/folders/$folderId';
      } else {
        // It's a file, return it as a single file resource
        return DriveResource(type: _getResourceTypeFromMimeType(mimeType), file: metadata);
      }
    } catch (e) {
      // If metadata fetch fails, assume it's a folder ID
      linkToFetch = 'https://drive.google.com/drive/folders/$folderId';
    }
  }
  
  return browser.fetchResourceFromLink(linkToFetch);
});

DriveResourceType _getResourceTypeFromMimeType(String mimeType) {
  final mt = mimeType.toLowerCase();
  if (mt == 'application/vnd.google-apps.folder') return DriveResourceType.folder;
  if (mt.startsWith('application/vnd.google-apps.document')) return DriveResourceType.googleDoc;
  if (mt.startsWith('application/vnd.google-apps.spreadsheet')) return DriveResourceType.googleSheet;
  if (mt.startsWith('application/vnd.google-apps.presentation')) return DriveResourceType.googleSlide;
  if (mt == 'application/vnd.google-apps.shortcut') return DriveResourceType.shortcut;
  return DriveResourceType.file;
}

class DriveListingView extends ConsumerWidget {
  final String? initialFolderId;
  final Function(DriveFile file)? onFileSelected;
  final Function(List<DriveFile> files, bool includeSubfolders)? onImport;

  const DriveListingView({
    super.key,
    this.initialFolderId,
    this.onFileSelected,
    this.onImport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final currentFolderId = ref.watch(currentFolderIdProvider) ?? initialFolderId;
    final navigationHistory = ref.watch(navigationHistoryProvider);
    final resourceAsync = currentFolderId != null 
        ? ref.watch(driveResourceProvider(currentFolderId))
        : null;

    return PopScope(
      canPop: navigationHistory.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigationHistory.isNotEmpty) {
          _navigateBack(ref);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: theme.surfaceColor,
              foregroundColor: theme.onSurfaceColor,
              leading: navigationHistory.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.onSurfaceColor),
                      onPressed: () => _navigateBack(ref),
                    )
                  : null,
              title: resourceAsync?.when(
                data: (resource) => CustomText(
                  resource.file?.name ?? 'Drive Files',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.onSurfaceColor,
                ),
                loading: () => CustomText(
                  'Loading...',
                  fontSize: 18,
                  color: theme.onSurfaceColor,
                ),
                error: (error, stack) => CustomText(
                  'Drive Files',
                  fontSize: 18,
                  color: theme.onSurfaceColor,
                ),
              ),
              actions: [
                if (resourceAsync?.hasValue == true && resourceAsync!.value!.type == DriveResourceType.folder)
                  _ImportButton(
                    resource: resourceAsync!.value!,
                    onImport: onImport,
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ],
          body: currentFolderId == null
              ? _EmptyState()
              : resourceAsync?.when(
                  data: (resource) => _DriveContent(
                    resource: resource,
                    onFileSelected: onFileSelected,
                    onFolderNavigate: (folderId) => _navigateToFolder(ref, folderId),
                  ),
                  loading: () => _LoadingState(),
                  error: (error, stack) => _ErrorState(
                    error: error,
                    onRetry: () => ref.refresh(driveResourceProvider(currentFolderId)),
                  ),
                ) ?? _EmptyState(),
        ),
      ),
    );
  }

  void _navigateBack(WidgetRef ref) {
    final history = List<String>.from(ref.read(navigationHistoryProvider));
    if (history.isNotEmpty) {
      final previousFolderId = history.removeLast();
      ref.read(navigationHistoryProvider.notifier).state = history;
      ref.read(currentFolderIdProvider.notifier).state = previousFolderId;
    }
  }

  void _navigateToFolder(WidgetRef ref, String folderId) {
    final currentId = ref.read(currentFolderIdProvider);
    if (currentId != null) {
      final history = ref.read(navigationHistoryProvider);
      ref.read(navigationHistoryProvider.notifier).state = [...history, currentId];
    }
    ref.read(currentFolderIdProvider.notifier).state = folderId;
  }
}

class _ImportButton extends ConsumerWidget {
  final DriveResource resource;
  final Function(List<DriveFile> files, bool includeSubfolders)? onImport;

  const _ImportButton({
    required this.resource,
    this.onImport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.download,
        color: theme.primaryColor,
      ),
      tooltip: 'Import Options',
      onSelected: (value) {
        if (onImport != null && resource.children != null) {
          final files = resource.children!;
          switch (value) {
            case 'current':
              onImport!(files, false);
              break;
            case 'all':
              onImport!(files, true);
              break;
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'current',
          child: Row(
            children: [
              Icon(Icons.folder, color: theme.primaryColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    'Import Current Folder',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.onSurfaceColor,
                  ),
                  CustomText(
                    'Files in this folder only',
                    fontSize: 12,
                    color: theme.supportingText,
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'all',
          child: Row(
            children: [
              Icon(Icons.folder_open, color: theme.primaryColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    'Import All Subfolders',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.onSurfaceColor,
                  ),
                  CustomText(
                    'Include all nested files',
                    fontSize: 12,
                    color: theme.supportingText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriveContent extends ConsumerWidget {
  final DriveResource resource;
  final Function(DriveFile file)? onFileSelected;
  final Function(String folderId)? onFolderNavigate;

  const _DriveContent({
    required this.resource,
    this.onFileSelected,
    this.onFolderNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (resource.type == DriveResourceType.folder) {
      final children = resource.children ?? [];
      
      if (children.isEmpty) {
        return _EmptyFolderState();
      }

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final file = children[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _DriveItemTile(
                    file: file,
                    onTap: () {
                      if (file.mimeType == 'application/vnd.google-apps.folder') {
                        onFolderNavigate?.call(file.id!);
                      } else {
                        onFileSelected?.call(file);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Single file view
      return Padding(
        padding: const EdgeInsets.all(16),
        child: _DriveItemTile(
          file: resource.file!,
          isDetailView: true,
          onTap: () => onFileSelected?.call(resource.file!),
        ),
      );
    }
  }
}

class _DriveItemTile extends ConsumerWidget {
  final DriveFile file;
  final VoidCallback? onTap;
  final bool isDetailView;

  const _DriveItemTile({
    required this.file,
    this.onTap,
    this.isDetailView = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return CustomElevatedButton(
      backgroundColor: theme.cardColor,
      borderRadius: 12,
      elevation: 0,
      onClick: onTap,
      contentPadding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _FileIcon(file: file),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  file.name ?? 'Unnamed',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.onCardColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _FileMetadata(file: file, isDetailView: isDetailView),
              ],
            ),
          ),
          _ActionButton(file: file),
        ],
      ),
    );
  }
}

class _FileIcon extends ConsumerWidget {
  final DriveFile file;

  const _FileIcon({
    required this.file,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final mimeType = file.mimeType ?? '';
    
    // Use thumbnail for images if available
    if (file.thumbnailLink != null && mimeType.startsWith('image/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: file.thumbnailLink!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.purple.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.image,
              color: Colors.purple,
              size: 24,
            ),
          ),
          errorWidget: (context, url, error) => _getDefaultIcon(mimeType, theme),
        ),
      );
    }
    
    return _getDefaultIcon(mimeType, theme);
  }

  Widget _getDefaultIcon(String mimeType, AppThemeModel theme) {
    IconData iconData;
    Color iconColor;

    if (mimeType == 'application/vnd.google-apps.folder') {
      iconData = Icons.folder;
      iconColor = theme.primaryColor;
    } else if (mimeType.startsWith('application/vnd.google-apps.document')) {
      iconData = Icons.description;
      iconColor = Colors.blue;
    } else if (mimeType.startsWith('application/vnd.google-apps.spreadsheet')) {
      iconData = Icons.table_chart;
      iconColor = Colors.green;
    } else if (mimeType.startsWith('application/vnd.google-apps.presentation')) {
      iconData = Icons.slideshow;
      iconColor = Colors.orange;
    } else if (mimeType.startsWith('image/')) {
      iconData = Icons.image;
      iconColor = Colors.purple;
    } else if (mimeType.startsWith('video/')) {
      iconData = Icons.video_file;
      iconColor = Colors.red;
    } else if (mimeType.startsWith('audio/')) {
      iconData = Icons.audio_file;
      iconColor = Colors.indigo;
    } else if (mimeType.contains('pdf')) {
      iconData = Icons.picture_as_pdf;
      iconColor = Colors.red.shade700;
    } else if (mimeType.startsWith('text/')) {
      iconData = Icons.text_snippet;
      iconColor = theme.supportingText;
    } else {
      iconData = Icons.insert_drive_file;
      iconColor = theme.supportingText;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}

class _FileMetadata extends ConsumerWidget {
  final DriveFile file;
  final bool isDetailView;

  const _FileMetadata({
    required this.file,
    this.isDetailView = false,
  });

  String _formatTimeAgo(String? timeString) {
    if (timeString == null) return '';
    
    try {
      final date = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else if (difference.inDays > 7) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays > 0) {
        return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final metadata = <String>[];

    // File type description
    final mimeType = file.mimeType ?? '';
    if (mimeType == 'application/vnd.google-apps.folder') {
      metadata.add('Folder');
    } else if (mimeType.startsWith('application/vnd.google-apps.document')) {
      metadata.add('Google Docs');
    } else if (mimeType.startsWith('application/vnd.google-apps.spreadsheet')) {
      metadata.add('Google Sheets');
    } else if (mimeType.startsWith('application/vnd.google-apps.presentation')) {
      metadata.add('Google Slides');
    } else if (file.fileExtension != null) {
      metadata.add(file.fileExtension!.toUpperCase());
    }

    // File size
    if (file.size != null && !file.isGoogleNative) {
      metadata.add(file.formattedSize);
    }

    // Modified time
    final timeAgo = _formatTimeAgo(file.modifiedTime);
    if (timeAgo.isNotEmpty) {
      metadata.add(timeAgo);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (metadata.isNotEmpty)
          CustomText(
            metadata.join(' • '),
            fontSize: 12,
            color: theme.supportingText,
          ),
        if (isDetailView && file.ownerDisplayName != null) ...[
          const SizedBox(height: 4),
          CustomText(
            'Owner: ${file.ownerDisplayName}',
            fontSize: 12,
            color: theme.supportingText,
          ),
        ],
        if (isDetailView && file.description != null && file.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          CustomText(
            file.description!,
            fontSize: 12,
            color: theme.onSurfaceColor.withAlpha(200),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends ConsumerWidget {
  final DriveFile file;

  const _ActionButton({
    required this.file,
  });

  void _openInDrive(String? webViewLink) async {
    if (webViewLink != null) {
      final uri = Uri.parse(webViewLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _showDetails(BuildContext context, WidgetRef ref) {
    final details = _FileDetailsDialog(file: file);
    UiUtils.showCustomDialog(context, child: details);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: theme.supportingText,
      ),
      tooltip: 'More options',
      onSelected: (value) {
        switch (value) {
          case 'open':
            _openInDrive(file.webViewLink);
            break;
          case 'download':
            log('Download selected for file: ${file.name}');
            break;
          case 'info':
            _showDetails(context, ref);
            break;
        }
      },
      itemBuilder: (context) => [
        if (file.webViewLink != null)
          PopupMenuItem(
            value: 'open',
            child: Row(
              children: [
                Icon(Icons.open_in_new, size: 20, color: theme.onSurfaceColor),
                const SizedBox(width: 12),
                CustomText('Open in Drive', fontSize: 14, color: theme.onSurfaceColor),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'download',
          child: Row(
            children: [
              Icon(Icons.download, size: 20, color: theme.onSurfaceColor),
              const SizedBox(width: 12),
              CustomText('Download', fontSize: 14, color: theme.onSurfaceColor),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'info',
          child: Row(
            children: [
              Icon(Icons.info, size: 20, color: theme.onSurfaceColor),
              const SizedBox(width: 12),
              CustomText('Details', fontSize: 14, color: theme.onSurfaceColor),
            ],
          ),
        ),
      ],
    );
  }
}

class _FileDetailsDialog extends ConsumerWidget {
  final DriveFile file;

  const _FileDetailsDialog({required this.file});

  String _formatFileSize(String? size) {
    if (size == null) return 'Unknown';
    final bytes = int.tryParse(size);
    if (bytes == null) return 'Unknown';
    
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _FileIcon(file: file),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomText(
                    file.name ?? 'Unnamed',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.onCardColor,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.supportingText),
                  onPressed: () => UiUtils.hideDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow('Type', file.mimeType?.split('/').last ?? 'Unknown', theme),
            if (file.size != null && !file.isGoogleNative)
              _DetailRow('Size', _formatFileSize(file.size), theme),
            if (file.ownerDisplayName != null)
              _DetailRow('Owner', file.ownerDisplayName!, theme),
            if (file.createdTime != null)
              _DetailRow('Created', _formatDateTime(file.createdTime), theme),
            if (file.modifiedTime != null)
              _DetailRow('Modified', _formatDateTime(file.modifiedTime), theme),
            if (file.lastModifyingUserDisplayName != null)
              _DetailRow('Last modified by', file.lastModifyingUserDisplayName!, theme),
            if (file.shared == true)
              _DetailRow('Sharing', 'Shared', theme),
            if (file.starred == true)
              _DetailRow('Status', 'Starred', theme),
            if (file.description != null && file.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              CustomText(
                'Description',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.onCardColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                file.description!,
                fontSize: 14,
                color: theme.supportingText,
              ),
            ],
            if (file.webViewLink != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  backgroundColor: theme.primaryColor,
                  onClick: () {
                    UiUtils.hideDialog(context);
                    _openInDrive(file.webViewLink);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new, color: theme.onPrimaryColor, size: 18),
                      const SizedBox(width: 8),
                      CustomText(
                        'Open in Drive',
                        color: theme.onPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _DetailRow(String label, String value, AppThemeModel theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: CustomText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.supportingText,
            ),
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: 14,
              color: theme.onCardColor,
            ),
          ),
        ],
      ),
    );
  }

  void _openInDrive(String? webViewLink) async {
    if (webViewLink != null) {
      final uri = Uri.parse(webViewLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

class _LoadingState extends ConsumerWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          CustomText(
            'Loading files...',
            fontSize: 14,
            color: theme.supportingText,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            CustomText(
              'Error loading files',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.onSurfaceColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              error.toString(),
              fontSize: 14,
              color: theme.supportingText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              backgroundColor: theme.primaryColor,
              onClick: onRetry,
              child: CustomText(
                'Try Again',
                color: theme.onPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: theme.supportingText.withAlpha(100),
          ),
          const SizedBox(height: 16),
          CustomText(
            'No folder selected',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.supportingText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CustomText(
            'Select a Drive folder to view its contents',
            fontSize: 14,
            color: theme.supportingText.withAlpha(125),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyFolderState extends ConsumerWidget {
  const _EmptyFolderState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: theme.supportingText.withAlpha(100),
          ),
          const SizedBox(height: 16),
          CustomText(
            'Empty folder',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.supportingText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CustomText(
            'This folder contains no files',
            fontSize: 14,
            color: theme.supportingText.withAlpha(125),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }}