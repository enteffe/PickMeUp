import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_me_up/controller/pick_me_up_controller.dart';

class SelectImageSource extends StatelessWidget {
  final int index;
  final int? imageQuality;

  /// border radius, defaults to 8
  final double borderRadius;

  /// corresponds to the background color of icon
  final Color? backgroundColor;

  /// icon background radius, defaults to 36
  final double backgroundRadius;

  /// icon size
  final double? iconSize;

  /// corresponds to the icon color
  final Color? iconColor;

  /// title widget
  final Widget? title;

  SelectImageSource({
    required this.index,
    this.imageQuality,
    this.borderRadius = 8,
    this.backgroundRadius = 36,
    this.backgroundColor,
    this.iconSize,
    this.iconColor,
    this.title,
    super.key,
  });

  final _pickMeUpController = Get.find<PickMeUpController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: backgroundRadius,
                      backgroundColor: backgroundColor,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: iconSize,
                        color: iconColor,
                      ),
                    ),
                    onTap: () async {
                      bool permissionStatus =
                          await _pickMeUpController.getPermission(
                        source: ImageSource.camera,
                      );
                      if (permissionStatus) {
                        _pickMeUpController.pickImage(
                          source: ImageSource.camera,
                          index: index,
                          imageQuality: imageQuality,
                        );
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: backgroundColor,
                      radius: backgroundRadius,
                      child: Icon(
                        Icons.image_search,
                        size: iconSize,
                        color: iconColor,
                      ),
                    ),
                    onTap: () async {
                      bool permissionStatus =
                          await _pickMeUpController.getPermission(
                        source: ImageSource.gallery,
                      );
                      if (permissionStatus) {
                        _pickMeUpController.pickImage(
                          source: ImageSource.gallery,
                          index: index,
                          imageQuality: imageQuality,
                        );
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
