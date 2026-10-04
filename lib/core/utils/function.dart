import 'dart:io';

import 'package:path/path.dart' as p;

class FileUtils {
  // ---------------------------------------------------------------------------
  // MIME TYPES
  // ---------------------------------------------------------------------------

  static const Map<String, String> _mimeTypes = {
    // Images
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'jpe': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'bmp': 'image/bmp',
    'ico': 'image/x-icon',
    'tif': 'image/tiff',
    'tiff': 'image/tiff',
    'svg': 'image/svg+xml',
    'avif': 'image/avif',
    'heic': 'image/heic',
    'heif': 'image/heif',

    // Videos
    'mp4': 'video/mp4',
    'm4v': 'video/x-m4v',
    'mov': 'video/quicktime',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',
    'webm': 'video/webm',
    'wmv': 'video/x-ms-wmv',
    'flv': 'video/x-flv',
    '3gp': 'video/3gpp',
    'mpeg': 'video/mpeg',
    'mpg': 'video/mpeg',
    'mpe': 'video/mpeg',
    'ts': 'video/mp2t',
    'ogv': 'video/ogg',

    // Audio
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'ogg': 'audio/ogg',
    'oga': 'audio/ogg',
    'opus': 'audio/opus',
    'm4a': 'audio/mp4',
    'aac': 'audio/aac',
    'flac': 'audio/flac',
    'weba': 'audio/webm',
    'amr': 'audio/amr',
    'aiff': 'audio/aiff',
    'aif': 'audio/aiff',
    'mid': 'audio/midi',
    'midi': 'audio/midi',

    // Fonts
    'ttf': 'font/ttf',
    'otf': 'font/otf',
    'woff': 'font/woff',
    'woff2': 'font/woff2',

    // Documents / Text
    'txt': 'text/plain',
    'csv': 'text/csv',
    'html': 'text/html',
    'htm': 'text/html',
    'css': 'text/css',
    'xml': 'application/xml',
    'json': 'application/json',
    'pdf': 'application/pdf',

    // Microsoft
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',

    // Archives
    'zip': 'application/zip',
    'gz': 'application/gzip',
    'gzip': 'application/gzip',
    '7z': 'application/x-7z-compressed',
    'rar': 'application/vnd.rar',
    'tar': 'application/x-tar',
  };

  // ---------------------------------------------------------------------------
  // CUSTOM MIME TYPES
  // ---------------------------------------------------------------------------

  static String? _customMimeType(String extension, List<String> customTypes) {
    for (final mime in customTypes) {
      final value = mime.toLowerCase();

      if (value.endsWith('/$extension')) {
        return value;
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // BASIC FILE HELPERS
  // ---------------------------------------------------------------------------

  static String alt(File file) => file.path;

  static int size(File file) => file.lengthSync();

  static String name(File file) => p.basename(file.path);

  static String path(File file) => file.path;

  static String url(File file) => file.path;

  // ---------------------------------------------------------------------------
  // EXTENSION
  // ---------------------------------------------------------------------------

  static String extension(File file) {
    final ext = p.extension(file.path);

    if (ext.isEmpty) {
      return '';
    }

    return ext.substring(1).toLowerCase();
  }

  // ---------------------------------------------------------------------------
  // MIME TYPE
  // ---------------------------------------------------------------------------

  static String mimeType(File file, {List<String> ext = const []}) {
    final extension = FileUtils.extension(file);

    if (extension.isEmpty) {
      return 'application/octet-stream';
    }

    return _customMimeType(extension, ext) ??
        _mimeTypes[extension] ??
        'application/octet-stream';
  }

  // ---------------------------------------------------------------------------
  // TYPE
  // ---------------------------------------------------------------------------

  static String type(File file, {List<String> ext = const []}) {
    final mime = mimeType(file, ext: ext);

    if (mime.startsWith('image/')) {
      return 'image';
    }

    if (mime.startsWith('video/')) {
      return 'video';
    }

    if (mime.startsWith('audio/')) {
      return 'audio';
    }

    if (mime.startsWith('font/')) {
      return 'font';
    }

    if (mime.startsWith('text/')) {
      return 'text';
    }

    if (mime.startsWith('application/')) {
      return 'application';
    }

    if (mime.startsWith('model/')) {
      return 'model';
    }

    return 'unknown';
  }

  // ---------------------------------------------------------------------------
  // CHECKERS
  // ---------------------------------------------------------------------------

  static bool isImage(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'image';
  }

  static bool isVideo(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'video';
  }

  static bool isAudio(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'audio';
  }

  static bool isFont(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'font';
  }

  static bool isText(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'text';
  }

  static bool isApplication(File file, {List<String> ext = const []}) {
    return type(file, ext: ext) == 'application';
  }
}

class Fn {
  static Map<String, dynamic> uploadFileMeta(
    File file, {
    List<String> ext = const [],
  }) {
    return {
      'alt': FileUtils.alt(file),
      'name': FileUtils.name(file),
      'size': FileUtils.size(file),
      'mime_type': FileUtils.mimeType(file),
      'type': FileUtils.type(file, ext: ext),
      'extension': FileUtils.extension(file),
    };
  }

  // Helper: Determine file type
  // String _getFileType(List<String> extensions, dynamic file) {
  //   if (_isImage(extensions, file)) return 'image';
  //   if (_isVideo(extensions, file)) return 'video';
  //   return 'unknown'; // or handle default case
  // }

  // bool _isImage(List<String> extensions, File file) {
  //   final ext = file.path.split('.').last.toLowerCase();

  //   return extensions.contains('image/$ext');
  // }

  // bool _isVideo(List<String> extensions, File file) {
  //   final ext = file.path.split('.').last.toLowerCase();

  //   return extensions.contains('video/$ext');
  // }
}
