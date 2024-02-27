import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product, ProductModel;
import '../../../services/index.dart' show ServerConfig, Services;
import '../../../widgets/product/product_quilted_card.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';
import 'pinterest_card.dart';

class PinterestLayout extends StatefulWidget {
  final ProductConfig config;

  const PinterestLayout({required this.config});

  @override
  State<PinterestLayout> createState() => _PinterestLayoutState();
}

class _PinterestLayoutState extends State<PinterestLayout> {
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

  ProductConfig get config => widget.config;

  @override
  Widget build(BuildContext context) {
    final isTablet = Helper.isTablet(MediaQuery.of(context));

    var column = isTablet ? 3 : 2;

    //BUG: has problem when scroll the list products
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    return LimitedBox(
      maxHeight: size.height - padding.vertical,
      child: CustomScrollView(
        cacheExtent: 1000,
        slivers: <Widget>[
          if (config.name?.isNotEmpty == true || config.showSeeAll)
            SliverToBoxAdapter(
              child: HeaderView(
                headerText: widget.config.name ?? '',
                showSeeAll:
                    widget.config.showSeeAll && !ServerConfig().isListingType,
                callback: () => ProductModel.showList(
                  config: widget.config.jsonData,
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: widget.config.vPadding,
              horizontal: widget.config.hPadding,
            ),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: column,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childCount: _products!.length,
              itemBuilder: (context, index) {
                final product = _products![index];
                if (widget.config.cardDesign.isQuiltedCard) {
                  return ProductQuiltedCard(
                    item: product,
                    width: size.width * 2 / 3,
                    config: widget.config,
                  );
                }
                return PinterestCard(
                  item: _products![index],
                  width: size.width / 2,
                  config: widget.config,
                );
              },
              // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
            ),
          ),
          SliverToBoxAdapter(
            child: _isEnd
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(child: Text(S.of(context).noData)),
                  )
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
