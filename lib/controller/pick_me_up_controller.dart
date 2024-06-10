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

  void clearSelectedImage([int index = 1]) {
    _selectedImages.removeWhere((key, value) => key == index);
    onFileSelected?.call(selectedImages);
  }

  bool _checkPermissionStatus({required PermissionStatus status}) {
    switch (status) {
      case PermissionStatus.denied:
        debugPrint('Permission Denied');
        _permissionStatus.value = PermissionStatus.denied;
        return false;
      case PermissionStatus.granted:
        debugPrint('Permission Granted');
        _permissionStatus.value = PermissionStatus.granted;
        return true;
      case PermissionStatus.restricted:
        debugPrint('Permissions Restricted');
        _permissionStatus.value = PermissionStatus.restricted;
        openAppSettings();
        return false;
      case PermissionStatus.limited:
        // TODO: Handle this case.
        return false;
      case PermissionStatus.permanentlyDenied:
        debugPrint('Permissions Restricted');
        _permissionStatus.value = PermissionStatus.permanentlyDenied;
        openAppSettings();
        return false;
      case PermissionStatus.provisional:
        // TODO: Handle this case.
        return false;
    }
  }

  Future<bool> getPermission({ImageSource source = ImageSource.gallery}) async {
    final PermissionStatus status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.mediaLibrary.request();

    return _checkPermissionStatus(status: status);
  }

  Future<void> pickImage({
    required int index,
    ImageSource source = ImageSource.gallery,
    int? imageQuality,
  }) async {
    try {
      if (permissionStatus == PermissionStatus.granted) {
        final pickedImage = await picker.pickImage(
          source: source,
          imageQuality: imageQuality,
        );
        if (pickedImage != null) {
          _selectedImages.addAll({
            index: pickedImage,
          });
          onFileSelected?.call(selectedImages);
        } else {
          debugPrint('No image selected');
        }
      } else {
        debugPrint(
          'Permission denied. Please grant access to camera and photos.',
        );
      }
    } catch (error) {
      debugPrint('Error while selecting the image-> ${error.toString()}');
    }
  }
}
