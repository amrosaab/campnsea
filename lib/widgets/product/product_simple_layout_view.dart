import 'package:flutter/material.dart';

import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show ProductImage, ProductOnSale, ProductPricing, ProductTitle;

class ProductSimpleLayout extends StatelessWidget with ActionButtonMixin {
  final Product item;
  final double? width;
  final double? maxWidth;
  final offset;
  final ProductConfig config;

  const ProductSimpleLayout({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final isShowPrice = config.hidePrice == false;

    Widget productImage = Stack(
      children: [
        ProductImage(
          width: width ?? 30,
          product: item,
          config: config,
          ratioProductImage: config.imageRatio,
          offset: offset,
          onTapProduct: () =>
              onTapProduct(context, product: item, config: config),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: ProductOnSale(
            product: item,
            config: ProductConfig.empty()..hMargin = 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(config.borderRadius ?? 12),
              ),
            ),
          ),
        ),
      ],
    );

    Widget productInfo = Column(
      children: [
        const SizedBox(height: 10),
        ProductTitle(
          product: item,
          hide: config.hideTitle,
          maxLines: config.titleLine,
          textCenter: true,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        if (isShowPrice) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: ProductPricing(
              product: item,
              hide: isShowPrice == false,
              showOnlyPrice: true,
              priceTextStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 10),
        ]
      ],
    );

    return GestureDetector(
      onTap: () => onTapProduct(context, product: item, config: config),
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
        margin: EdgeInsets.symmetric(
          horizontal: config.hMargin,
          vertical: config.vMargin,
        ),
        width: width!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            productImage,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (config.borderRadius ?? 6) * 0.25,
              ),
              child: productInfo,
            ),
          ],
        ),
      ),
    );
  }
}
