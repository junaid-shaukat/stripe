import 'dart:io';

import '../app_export.dart';

class FilePickers {
  static Future<File?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    Object? androidSafOptions,
    int compressionQuality = 0,
    FileType type = FileType.any,
    bool lockParentWindow = false,
    List<String>? allowedExtensions,
    bool cancelUploadOnWindowBlur = true,
    WebOptions webOptions = const WebOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    dynamic Function(FilePickerStatus)? onFileLoading,
    AndroidOptions androidOptions = const AndroidOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
  }) async {
    PlatformFile? xfile = await FilePicker.pickFile(
      type: type,
      webOptions: webOptions,
      dialogTitle: dialogTitle,
      linuxOptions: linuxOptions,
      onFileLoading: onFileLoading,
      androidOptions: AndroidOptions(),
      windowsOptions: windowsOptions,
      initialDirectory: initialDirectory,
      allowedExtensions: allowedExtensions,
      compressionQuality: compressionQuality,
    );

    return xfile?.path != null ? File(xfile!.path!) : null;
  }

  static Future<File?> pickImageFromCamera() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.camera);
    return xfile?.path != null ? File(xfile!.path) : null;
  }

  static Future<File?> pickImageFromGallery() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xfile?.path != null ? File(xfile!.path) : null;
  }

  static Future<File?> pickVideo() async {
    final xfile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    return xfile?.path != null ? File(xfile!.path) : null;
  }
}
