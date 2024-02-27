import 'package:flutter/material.dart';

import '../../../../common/config/models/onboarding_item_config.dart';
import '../../../../widgets/common/flux_image.dart';

class RenderSliderWidget extends StatelessWidget {
  final OnBoardingItemConfig config;
  final bool autoCropImageByDesign;

  const RenderSliderWidget({
    super.key,
    required this.config,
    this.autoCropImageByDesign = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: autoCropImageByDesign ? ClipImage() : null,
            child: SizedBox(
              width: width,
              height: height * 0.6,
              child: FluxImage(
                imageUrl: config.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            config.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: width * 0.6,
            child: Text(
              config.desc,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClipImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    const borderRadius = 20.0;
    const clipY = 30;

    var path = Path()
      ..moveTo(borderRadius, 0)
      ..arcToPoint(const Offset(0, borderRadius),
          radius: const Radius.circular(borderRadius), clockwise: false)
      ..lineTo(0, h - borderRadius)
      ..arcToPoint(Offset(borderRadius, h),
          radius: const Radius.circular(borderRadius), clockwise: false)
      ..lineTo(w - borderRadius, h - clipY)
      ..arcToPoint(Offset(w, h - clipY - borderRadius),
          radius: const Radius.circular(borderRadius), clockwise: false)
      ..lineTo(w, borderRadius)
      ..arcToPoint(Offset(w - borderRadius, 0),
          radius: const Radius.circular(borderRadius), clockwise: false)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
