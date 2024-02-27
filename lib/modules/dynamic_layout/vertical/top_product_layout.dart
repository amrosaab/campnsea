import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product;
import '../../../screens/detail/widgets/product_short_description.dart';
import '../../../services/index.dart' show Services;
import '../../../widgets/product/action_button_mixin.dart';
import '../../../widgets/product/index.dart';
import '../config/product_config.dart';

const _defaultBorderRadius = 32.0;

class TopProductLayout extends StatefulWidget {
  final ProductConfig config;

  const TopProductLayout({required this.config});

  @override
  State<TopProductLayout> createState() => _TopProductLayoutState();
}

class _TopProductLayoutState extends State<TopProductLayout> {
  final Services _service = Services();
  List<Product>? _products = [];
  int _page = 0;
  bool _isEnd = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadProduct();
  }

  void _loadProduct() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    var config = widget.config.toJson();
    _page = _page + 1;
    config['page'] = _page;
    config['limit'] = 10;

    var newProducts = await (_service.api.fetchProductsLayout(config: config));
    var isExisted = newProducts!.isNotEmpty &&
        _products!.indexWhere((o) => o.id == newProducts[0].id) > -1;
    if (!isExisted) {
      _products = [..._products!, ...newProducts];
      if (newProducts.length < config['limit']) {
        _isEnd = true;
      }
    }
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //BUG: has problem when scroll the list products
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    return LimitedBox(
      maxHeight: size.height - padding.vertical,
      child: CustomScrollView(
        cacheExtent: 1000,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: widget.config.vPadding,
              horizontal: widget.config.hPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _products!.length,
                (context, index) {
                  final product = _products![index];
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.19,
                    child: TopProductCard(
                      config: widget.config,
                      product: product,
                      index: index + 1,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _isEnd
                ? Center(child: Text(S.of(context).noData))
                : VisibilityDetector(
                    key: const Key('loading_visible'),
                    onVisibilityChanged: (VisibilityInfo info) =>
                        _loadProduct(),
                    child: Center(
                      child: Text(S.of(context).loading),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TopProductCard extends StatelessWidget with ActionButtonMixin {
  const TopProductCard({
    super.key,
    required this.config,
    required this.product,
    required this.index,
  });

  final ProductConfig config;
  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final boxShadow = config.boxShadow;
    final radius = config.borderRadius ?? _defaultBorderRadius;
    final borderRadius = BorderRadiusDirectional.only(
      topStart: Radius.circular(radius * 2.5),
      topEnd: Radius.circular(radius),
      bottomStart: Radius.circular(radius),
      bottomEnd: Radius.circular(radius * 2.5),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTapProduct(
          context,
          product: product,
          config: config,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: borderRadius,
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProductImage(
                            width: 115,
                            alignmentImage: Alignment.topCenter,
                            product: product,
                            offset: -1,
                            config: config.copyWith(borderRadius: 0),
                            ratioProductImage: config.imageRatio,
                            onTapProduct: () => onTapProduct(
                              context,
                              product: product,
                              config: config,
                            ),
                          ),
                          Padding(
                            padding: config.hidePrice
                                ? EdgeInsets.zero
                                : const EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 12.0,
                                  ),
                            child: Center(
                              child: ProductPricing(
                                product: product,
                                hide: config.hidePrice,
                                priceTextStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: config.hPadding,
                          vertical: config.vPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ProductTitle(
                              product: product,
                              hide: config.hideTitle,
                              maxLines: config.titleLine,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ProductShortDescription(product),
                            const SizedBox(height: 4),
                            StockStatus(
                              product: product,
                              config: config,
                            ),
                            const SizedBox(height: 4),
                            ProductRating(
                              product: product,
                              config: config,
                            ),
                            SaleProgressBar(
                              product: product,
                              show: config.showCountDown,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: -4,
              top: -4,
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 9,
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6,
                  ),
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
