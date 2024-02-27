import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/index.dart' show Product;
import '../../../widgets/common/auto_silde_show.dart';
import '../../../widgets/product/product_quilted_card.dart';
import '../config/product_config.dart';

class ProductQuiltedGridTile extends StatelessWidget {
  final List<Product>? products;
  final double width;
  final ProductConfig config;

  ProductQuiltedGridTile({
    Key? key,
    this.products,
    required this.width,
    required this.config,
  }) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final listProduct = products;
    if (listProduct == null) {
      return const SizedBox();
    }

    final screenSize = MediaQuery.sizeOf(context);
    final body = SizedBox(
      height: screenSize.height * 0.8 / (screenSize.height / width),
      child: GridView.custom(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 8,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          repeatPattern: QuiltedGridRepeatPattern.same,
          pattern: const [
            QuiltedGridTile(5, 8),
            QuiltedGridTile(8, 4),
            QuiltedGridTile(8, 4),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          childCount: listProduct.length,
          (context, index) {
            final product = listProduct[index];
            return LayoutBuilder(builder: (context, constraints) {
              return ProductQuiltedCard(
                width: constraints.maxWidth,
                item: product,
                config: config,
                axis: index % 3 == 0 ? Axis.vertical : Axis.horizontal,
              );
            });
          },
        ),
      ),
    );

    return HandleAutoSlide.list(
      enable: config.enableAutoSliding,
      durationAutoSliding: config.durationAutoSliding,
      numberOfItems: products!.length,
      controller: _scrollController,
      child: body,
    );
  }
}
