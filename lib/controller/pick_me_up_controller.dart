import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickMeUpController extends GetxController {
  final picker = ImagePicker();

  ValueChanged<Map<int, XFile?>>? onFileSelected;

  final RxMap<int, XFile?> _selectedImages = RxMap<int, XFile?>();
  Map<int, XFile?> get selectedImages => _selectedImages;

  final Rx<PermissionStatus> _permissionStatus = PermissionStatus.denied.obs;
  PermissionStatus get permissionStatus => _permissionStatus.value;

  clearSelectedImage([int index = 1]) {
    _selectedImages.removeWhere((key, value) => key == index);
    onFileSelected?.call(selectedImages);
  }

  // ===================================================================
  // DIALOG INSIDE CONTROLLER (App Store Safe)
  // ===================================================================
  Future<void> showPermissionDialog({
    required String title,
    required String message,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Not Now"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              Get.back();
              openAppSettings(); // User-initiated – App Store compliant
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // ===================================================================
  // Permission Check
  // ===================================================================
  bool _checkPermissionStatus(PermissionStatus status) {
    _permissionStatus.value = status;

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
        debugPrint('Permission Denied');
        return false;

      case PermissionStatus.restricted:
        debugPrint('Permission Restricted');
        return false;

      case PermissionStatus.permanentlyDenied:
        debugPrint('Permission Permanently Denied');
        return false;

      case PermissionStatus.limited:
        debugPrint('Limited Access Granted');
        return true;

      case PermissionStatus.provisional:
        return false;
    }
  }

  Future<bool> getPermission({ImageSource source = ImageSource.gallery}) async {
    final PermissionStatus status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.mediaLibrary.request();

    return _checkPermissionStatus(status);
  }

  // ===================================================================
  // Main Image Picker
  // ===================================================================
  Future<void> pickImage({
    required int index,
    ImageSource source = ImageSource.gallery,
    int? imageQuality,
  }) async {
    try {
      final allowed = await getPermission(source: source);

      if (!allowed) {
        await showPermissionDialog(
          title: "Access Needed",
          message:
              "This feature requires permission. You can still use the app, "
              "or enable access from Settings to continue.",
        );
        return;
      }

      final pickedImage = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );

      if (pickedImage != null) {
        _selectedImages[index] = pickedImage;
        onFileSelected?.call(selectedImages);
      } else {
        debugPrint('No image selected');
      }
    } catch (error) {
      debugPrint('Error while selecting the image -> $error');
    }
  }
}
