library pick_me_up;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_me_up/controller/pick_me_up_controller.dart';

class PickMeUp extends StatefulWidget {
  /// index refers to the key in case of multiple images/files selection
  /// defaults to 1
  final int index;

  /// image to be shown above the button
  final String imagePath;

  /// width
  final double width;

  /// height
  final double height;

  /// border radius of selection container/image
  /// defaults to 8
  final double borderRadius;

  /// border color
  final Color? borderColor;

  /// button text
  final String? uploadButtonText;

  /// button's textstyle
  final TextStyle? uploadButtonTextStyle;

  /// leading button icon
  final Icon? uploadButtonIcon;

  /// button text color
  final Color? uploadButtonTextColor;

  /// image fit type
  final BoxFit? fitType;

  /// callbacks corresponding to file selections
  final ValueChanged<Map<int, XFile?>>? onFileSelected;

  const PickMeUp({
    required this.imagePath,
    required this.width,
    required this.height,
    this.index = 1,
    this.borderRadius = 8,
    this.borderColor,
    this.uploadButtonText,
    this.uploadButtonTextStyle,
    this.uploadButtonIcon,
    this.uploadButtonTextColor = Colors.black,
    this.fitType = BoxFit.contain,
    this.onFileSelected,
    super.key,
  });

  @override
  State<PickMeUp> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<PickMeUp> {
  final _pickMeUpController = Get.put<PickMeUpController>(PickMeUpController());

  @override
  void initState() {
    super.initState();
    _pickMeUpController.onFileSelected = widget.onFileSelected;
  }

  @override
  void dispose() {
    _pickMeUpController.clearSelectedImage(widget.index);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius),
        ),
      ),
      width: widget.width,
      height: widget.height,
      child: Obx(
        () => (!_pickMeUpController.selectedImages.containsKey(widget.index))
            ? Column(
                children: [
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    widget.imagePath,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      bool permissionStatus =
                          await _pickMeUpController.getPermission(
                        source: ImageSource.camera,
                      );
                      if (permissionStatus) {
                        _pickMeUpController.pickImage(
                          source: ImageSource.camera,
                          index: widget.index,
                        );
                      }
                    },
                    icon: widget.uploadButtonIcon ??
                        const Icon(
                          Icons.add_circle_outline,
                          size: 24,
                        ),
                    label: Text(
                      widget.uploadButtonText ?? 'Upload Image',
                      textAlign: TextAlign.center,
                      style: widget.uploadButtonTextStyle,
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    child: Image.file(
                      File(
                        _pickMeUpController
                                .selectedImages[widget.index]?.path ??
                            '',
                      ),
                      height: widget.height,
                      width: widget.width,
                      fit: widget.fitType,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _pickMeUpController
                        .clearSelectedImage(widget.index ?? 1),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
