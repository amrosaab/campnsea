import 'package:flutter/material.dart';
import 'package:inspireui/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../models/category/category_model.dart';
import '../../../widgets/common/flux_image.dart';
import '../index.dart';
import 'common_item_extension.dart';

class CategoryIconGradientItem extends StatelessWidget {
  final double? iconSize;
  final String? name;
  final Function? onTap;
  final CategoryItemConfig? itemConfig;
  final CommonItemConfig commonConfig;
  final bool? isSelected;
  final bool isHorizontal;
  final bool isWrap;

  const CategoryIconGradientItem({
    this.iconSize,
    this.name,
    this.onTap,
    this.itemConfig,
    this.isSelected,
    required this.commonConfig,
    this.isHorizontal = false,
    this.isWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final disableBackground =
        (commonConfig.noBackground ?? false) || commonConfig.originalColor;
    final categoryList = Provider.of<CategoryModel>(context).categoryList;

    final id = itemConfig?.category.toString();
    final categoryName =
        name ?? (categoryList[id] != null ? categoryList[id]!.name : '');
    final image = itemConfig?.image ??
        (categoryList[id] != null ? categoryList[id]!.image : null);
    final firstColor = (itemConfig?.colors?.isNotEmpty ?? false)
        ? itemConfig?.colors?.first
        : null;

    final gradientColors = itemConfig?.colors;

    BoxDecoration? decorationBox;
    if (commonConfig.border != null && commonConfig.border != 0) {
      final borderSide = BorderSide(
        width: commonConfig.border!,
        color: Colors.black.withOpacity(0.05),
      );
      decorationBox = BoxDecoration(
          border: Border(
        bottom: borderSide,
        right: borderSide,
      ));
    }

    return GestureDetector(
      onTap: () => onTap?.call(categoryName),
      child: Container(
        constraints: isHorizontal || iconSize == null
            ? null
            : BoxConstraints(maxWidth: iconSize! * 1.2),
        decoration: decorationBox,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: disableBackground || gradientColors == null ? 0 : 5,
          ),
          decoration: BoxDecoration(boxShadow: [
            if (disableBackground == false && gradientColors != null)
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: (gradientColors.length >= 2
                        ? gradientColors.last
                        : Theme.of(context).primaryColor)
                    .withOpacity(0.4),
                offset: const Offset(0, 2),
              ),
          ]),
          child: ClipRRect(
            borderRadius: commonConfig.radius != null
                ? BorderRadius.circular(commonConfig.radius!)
                : BorderRadius.zero,
            child: DecoratedBox(
              decoration: CustomDecoration(),
              position: DecorationPosition.foreground,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: commonConfig.paddingX,
                  vertical: commonConfig.paddingY,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: commonConfig.marginX,
                  vertical: commonConfig.marginY,
                ),
                decoration: BoxDecoration(
                  color: !disableBackground
                      ? itemConfig?.getBackgroundColor
                      : null,
                  gradient: gradientColors == null
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                  boxShadow: [
                    if (commonConfig.boxShadow != null)
                      BoxShadow(
                        blurRadius: commonConfig.boxShadow!.blurRadius,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(commonConfig.boxShadow!.colorOpacity),
                        offset: Offset(commonConfig.boxShadow!.x,
                            commonConfig.boxShadow!.y),
                      )
                  ],
                  borderRadius:
                      BorderRadius.circular(commonConfig.radius ?? 10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: commonConfig.imageDecoration,
                      width: isHorizontal
                          ? isWrap
                              ? double.infinity
                              : null
                          : iconSize,
                      height: iconSize,
                      padding: EdgeInsets.all(commonConfig.imageSpacing),
                      child: Container(
                        child: (isHorizontal == true)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (image != null) _image(image, firstColor),
                                  Flexible(
                                    child: Text(
                                      categoryName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize:
                                                  commonConfig.labelFontSize),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )
                            : (image != null)
                                ? Container(
                                    margin:
                                        EdgeInsets.all(commonConfig.spacing),
                                    child: _image(image, HexColor('#FFFFFF')),
                                  )
                                : const SizedBox(),
                      ),
                    ),
                    if ((categoryName?.isNotEmpty) ?? false) ...[
                      const SizedBox(height: 6),
                      if (isHorizontal == false)
                        Text(
                          categoryName!,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: commonConfig.labelFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      if (isSelected != null)
                        AnimatedContainer(
                          decoration: BoxDecoration(
                            color: isSelected == true
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          margin: const EdgeInsets.only(
                            top: 4.0,
                          ),
                          height: 4.0,
                          width: 4.0,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _image(String image, HexColor? firstColor) {
    return FluxImage(
      imageUrl: image,
      color: (itemConfig?.originalColor ?? true) || commonConfig.originalColor
          ? null
          : firstColor,
      width: iconSize,
      height: iconSize,
    );
  }
}

class CustomDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: 12,
      strokeWidth: 0,
    );
  }
}

class _CustomDecoration extends BoxPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  _CustomDecoration({
    required this.color,
    required this.borderRadius,
    this.strokeWidth = 0,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    // final rect = offset & configuration.size!;
    final path = Path();
    final size = configuration.size!;
    // final topLeft = Offset(offset.dx, offset.dy);
    final topRight = Offset(offset.dx + size.width, offset.dy);
    final bottomLeft = Offset(offset.dx, offset.dy + size.height);
    final bottomRight = Offset(offset.dx + size.width, offset.dy + size.height);

    path.moveTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy - borderRadius);
    path.arcToPoint(Offset(bottomRight.dx - borderRadius, bottomRight.dy),
        radius: Radius.circular(borderRadius));
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();
    canvas.drawPath(path, paint);
  }
}
