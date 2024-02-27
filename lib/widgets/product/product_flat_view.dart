import 'package:flutter/material.dart';

import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show HeartButton, ProductImage, ProductOnSale, ProductPricing, ProductTitle;

class ProductFlat extends StatefulWidget {
  final Product item;
  final double? width;
  final double? maxWidth;
  final bool hideDetail;
  final double? offset;
  final ProductConfig config;

  const ProductFlat({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    this.hideDetail = false,
    required this.config,
  });

  @override
  State<ProductFlat> createState() => _ProductFlatState();
}

class _ProductFlatState extends State<ProductFlat> with ActionButtonMixin {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.config.borderRadius ?? 3);

    final width = (widget.maxWidth != null &&
            widget.width != null &&
            widget.width! > widget.maxWidth!)
        ? widget.maxWidth!
        : (widget.width ??
            Layout.buildProductMaxWidth(
                context: context, layout: widget.config.layout));

    /// use for Staged layout
    if (widget.hideDetail) {
      return ProductImage(
        width: width,
        product: widget.item,
        config: widget.config,
        ratioProductImage: widget.config.imageRatio,
        offset: widget.offset,
        onTapProduct: () =>
            onTapProduct(context, product: widget.item, config: widget.config),
      );
    }

    Widget productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ProductTitle(
          product: widget.item,
          hide: widget.config.hideTitle,
          maxLines: widget.config.titleLine,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        if (widget.item.categoryName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text(
              '${widget.item.categoryName}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ProductPricing(
                  product: widget.item,
                  hide: widget.config.hidePrice,
                  priceTextStyle: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 10),
              if (!widget.config.showQuantity) ...[
                ProductOnSale(
                  product: widget.item,
                  config: widget.config,
                  textColor: Theme.of(context).primaryColorLight,
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryIconTheme.color,
                    borderRadius:
                        const BorderRadiusDirectional.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () =>
          onTapProduct(context, product: widget.item, config: widget.config),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(maxWidth: widget.maxWidth ?? width),
        width: widget.width!,
        margin: EdgeInsets.symmetric(
          horizontal: widget.config.hMargin,
          vertical: widget.config.vMargin,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  if (widget.config.boxShadow != null)
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(
                        widget.config.boxShadow?.x ?? 0.0,
                        widget.config.boxShadow?.y ?? 0.0,
                      ),
                      blurRadius: widget.config.boxShadow?.blurRadius ?? 0.0,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ProductImage(
                      width: width,
                      product: widget.item,
                      config: widget.config,
                      ratioProductImage: widget.config.imageRatio,
                      offset: widget.offset,
                      onTapProduct: () => onTapProduct(context,
                          product: widget.item, config: widget.config),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.config.hPadding,
                        vertical: widget.config.vPadding,
                      ),
                      child: productInfo,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.config.showHeart && !widget.item.isEmptyProduct())
              Positioned.directional(
                end: widget.config.hMargin,
                textDirection: Directionality.of(context),
                child: HeartButton(
                  product: widget.item,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
