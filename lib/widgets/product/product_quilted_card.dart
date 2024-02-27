import 'package:flutter/material.dart';

import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show
        ProductImage,
        ProductPricing,
        ProductRating,
        ProductTitle,
        SaleProgressBar,
        StockStatus;
import 'widgets/on_sale.dart';

class ProductQuiltedCard extends StatefulWidget {
  final Product item;
  final double width;
  final double? maxWidth;
  final double? offset;
  final ProductConfig config;
  final Axis axis;

  const ProductQuiltedCard({
    required this.item,
    required this.width,
    this.maxWidth,
    this.offset,
    required this.config,
    this.axis = Axis.vertical,
  });

  @override
  State<ProductQuiltedCard> createState() => _ProductQuiltedCardState();
}

class _ProductQuiltedCardState extends State<ProductQuiltedCard>
    with ActionButtonMixin {
  late final BorderRadius _borderRadius;

  ProductConfig get config => widget.config;

  @override
  void initState() {
    super.initState();
    _borderRadius = BorderRadius.circular(config.borderRadius ?? 12);
  }

  @override
  Widget build(BuildContext context) {
    Widget item = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  if (widget.item.onSale ?? false) const SizedBox(height: 12),
                  ProductImage(
                    width: widget.width * 2 / 3,
                    product: widget.item,
                    config: widget.config,
                    ratioProductImage: widget.config.imageRatio,
                    offset: widget.offset,
                    onTapProduct: () => onTapProduct(
                      context,
                      product: widget.item,
                      config: widget.config,
                    ),
                  ),
                ],
              ),
              Positioned.directional(
                end: 8,
                top: 0,
                textDirection: Directionality.of(context),
                child: ProductOnSale(
                  product: widget.item,
                  config: ProductConfig.empty()..hMargin = 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius:
                        BorderRadius.circular((config.borderRadius ?? 6) * 0.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProductTitle(
            product: widget.item,
            hide: widget.config.hideTitle,
            maxLines: widget.config.titleLine,
            textCenter: true,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          StockStatus(
            product: widget.item,
            config: widget.config,
          ),
          const SizedBox(height: 4),
          ProductRating(
            product: widget.item,
            config: widget.config,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SaleProgressBar(
              width: widget.width,
              product: widget.item,
              show: widget.config.showCountDown,
            ),
          ),
          const SizedBox(height: 12),
          ProductPricing(
            product: widget.item,
            hide: widget.config.hidePrice,
            priceTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
    if (widget.axis == Axis.horizontal) {
      item = ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(config.borderRadius ?? 0),
          bottomLeft: Radius.circular(config.borderRadius ?? 0),
        ),
        child: Row(
          children: [
            ProductImage(
              width: widget.width / 2,
              product: widget.item,
              config: widget.config.copyWith(borderRadius: 0),
              ratioProductImage: widget.config.imageRatio,
              offset: -2,
              onTapProduct: () => onTapProduct(context,
                  product: widget.item, config: widget.config),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProductTitle(
                      product: widget.item,
                      hide: widget.config.hideTitle,
                      maxLines: widget.config.titleLine,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StockStatus(
                      product: widget.item,
                      config: widget.config,
                    ),
                    const SizedBox(height: 4),
                    ProductRating(
                      product: widget.item,
                      config: widget.config,
                    ),
                    SaleProgressBar(
                      width: widget.width,
                      product: widget.item,
                      show: widget.config.showCountDown,
                    ),
                    const SizedBox(height: 12),
                    ProductPricing(
                      product: widget.item,
                      hide: widget.config.hidePrice,
                      priceTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    final boxShadow = widget.config.boxShadow;

    return GestureDetector(
      onTap: () =>
          onTapProduct(context, product: widget.item, config: widget.config),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: Theme.of(context).cardColor,
          boxShadow: [
            if (boxShadow != null)
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.15),
                offset: Offset(
                  boxShadow.x,
                  boxShadow.y,
                ),
                spreadRadius: boxShadow.spreadRadius,
                blurRadius: boxShadow.blurRadius,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: item,
        ),
      ),
    );
  }
}
