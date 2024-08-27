library pick_me_up;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_me_up/controller/pick_me_up_controller.dart';
import 'package:pick_me_up/widgets/select_image_source.dart';

class PickMeUp extends StatefulWidget {
  /// Index refers to the key in case of multiple images/files selection
  /// defaults to 1
  final int index;

  /// Image to be shown above the button
  final String imagePath;

  /// Width
  final double width;

  /// Height
  final double height;

  /// Border radius of selection container/image
  /// Defaults to 8
  final double borderRadius;

  /// Border color
  final Color? borderColor;

  /// Button text
  final String? uploadButtonText;

  /// Button's Text-Style
  final TextStyle? uploadButtonTextStyle;

  /// Leading button icon
  final Icon? uploadButtonIcon;

  /// Button text color
  final Color? uploadButtonTextColor;

  /// Image fit type
  final BoxFit? fitType;

  /// Callback corresponding to file selections
  final ValueChanged<Map<int, XFile?>>? onFileSelected;

  /// quality of the image, defaults to 50%
  final int? imageQuality;

  /// title of image source selection
  final Widget? title;

  final BoxShape? boxShape;

  final Widget? uploadedChild;

  final Widget? uploadingChild;

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
    this.imageQuality = 50,
    this.title,
    this.uploadedChild,
    this.uploadingChild,
    this.boxShape,
    super.key,
  });

  @override
  State<PickMeUp> createState() => _PickMeUpState();
}

class _PickMeUpState extends State<PickMeUp> {
  final PickMeUpController pickMeUpController = Get.put<PickMeUpController>(
    PickMeUpController(),
  );

  @override
  void initState() {
    super.initState();
    pickMeUpController.onFileSelected = widget.onFileSelected;
  }

  @override
  void dispose() {
    pickMeUpController.clearSelectedImage(widget.index);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: widget.boxShape ?? BoxShape.rectangle,
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
        () => (!pickMeUpController.selectedImages.containsKey(widget.index))
            ? (widget.uploadingChild != null)
                ? (widget.uploadingChild ?? const SizedBox())
                : Column(
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
                          showDialog(
                            context: context,
                            builder: (_) {
                              return SelectImageSource(
                                index: widget.index,
                                imageQuality: widget.imageQuality,
                                title: widget.title ??
                                    const Text(
                                      'Select an image source',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                              );
                            },
                          );
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
            : (widget.uploadedChild != null)
                ? (widget.uploadedChild ?? const SizedBox())
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius),
                        ),
                        child: Image.file(
                          File(
                            pickMeUpController
                                    .selectedImages[widget.index]?.path ??
                                '',
                          ),
                          height: widget.height,
                          width: widget.width,
                          fit: widget.fitType,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            pickMeUpController.clearSelectedImage(widget.index),
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
