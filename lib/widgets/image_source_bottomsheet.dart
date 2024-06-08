import 'package:flutter/material.dart';

class ImageSourceBottomsheet extends StatelessWidget {
  const ImageSourceBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.camera_alt_rounded),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.image_search),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
