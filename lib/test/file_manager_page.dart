import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:slides_sync/shared/helpers/extension_helper.dart';

class FileManagerPage extends ConsumerStatefulWidget {
  const FileManagerPage({super.key});

  @override
  ConsumerState<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends ConsumerState<FileManagerPage> {
  Directory? _currentDir;
  List<FileSystemEntity> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _goToAppDir();
  }

  Future<void> _goToAppDir() async {
    final dir = await getApplicationDocumentsDirectory();
    await _listDir(dir);
  }

  Future<void> _listDir(Directory dir) async {
    setState(() {
      _loading = true;
    });

    try{
      final List<FileSystemEntity> children = await dir.list(recursive: false, followLinks: false).toList();

    // sort: directories first, then files, both by name
    children.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;
      if (aIsDir != bIsDir) return aIsDir ? -1 : 1;
      return p.basename(a.path).compareTo(p.basename(b.path));
    });

    setState(() {
      _currentDir = dir;
      _entries = children;
      _loading = false;
    });
    }catch(e){
      log("Error navigating further!");
    }
  }

  String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final dirName = _currentDir?.path.split(Platform.pathSeparator).last ?? '';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final parent = _currentDir!.parent;
        _listDir(parent);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'File Manager: $dirName',
            style: TextStyle(color: ref.theme.primaryText),
          ),
          leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
          actions: [

            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                if (_currentDir != null) _listDir(_currentDir!);
              },
            ),
          ],
        ),
        body:
            _loading
                ? Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                ? Center(
                  child: Text(
                    'Empty',
                    style: TextStyle(color: ref.theme.primaryText),
                  ),
                )
                : ListView.separated(
                  itemCount: _entries.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final ent = _entries[idx];
                    final name = p.basename(ent.path);
                    final isDir = ent is Directory;

                    return FutureBuilder<FileStat>(
                      future: ent.stat(),
                      builder: (ctx, snap) {
                        final stat = snap.data;
                        final modified = stat != null ? DateFormat('yyyy-MM-dd HH:mm').format(stat.modified) : '';
                        final size = stat != null && !isDir ? _formatBytes(stat.size) : '';

                        return ListTile(
                          leading: Icon(isDir ? Icons.folder : Icons.insert_drive_file),
                          title: Text(
                            name,
                            style: TextStyle(color: ref.theme.primaryText),
                          ),
                          subtitle: Text(
                            isDir ? modified : '$modified • $size',
                            style: TextStyle(
                              fontSize: 12,
                              color: ref.theme.primaryText,
                            ),
                          ),
                          onTap: isDir ? () => _listDir(ent) : null,
                          onLongPress:
                              isDir
                                  ? null
                                  : () async {
                                    final del = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (c) => AlertDialog(
                                            title: Text('Delete file?'),
                                            content: Text(name),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(c, false), child: Text('No')),
                                              TextButton(onPressed: () => Navigator.pop(c, true), child: Text('Yes')),
                                            ],
                                          ),
                                    );
                                    if (del == true) {
                                      await ent.delete();
                                      _listDir(_currentDir!);
                                    }
                                  },
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }
}
