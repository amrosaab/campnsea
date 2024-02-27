import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/list_product_model.dart';
import '../../../models/index.dart' show CategoryModel, ProductModel;
import '../../../services/index.dart';
import '../category/category_icon_item.dart';
import '../config/category_config.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';

class MenuLayoutWithCustomCategory extends StatefulWidget {
  final ProductConfig config;
  final CategoryConfig categoryConfig;

  const MenuLayoutWithCustomCategory({
    required this.config,
    required this.categoryConfig,
  });

  @override
  State<MenuLayoutWithCustomCategory> createState() => _StateMenuLayout();
}

class _StateMenuLayout extends State<MenuLayoutWithCustomCategory> {
  final _productCache = <int, ListProductModel>{};

  final _positionNotifier = ValueNotifier(0);

  int get position => _positionNotifier.value;

  set position(int value) => _positionNotifier.value = value;

  CategoryConfig? get categoryConfig => widget.categoryConfig;

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _positionNotifier.dispose();
    _productCache.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryConfig = widget.categoryConfig;

    return LayoutBuilder(
      builder: (_, constraints) {
        final isTablet = Layout.isDisplayTablet(context);

        var widthScreen = constraints.maxWidth;

        /// 2 columns on mobile, 3 columns on ipad
        var crossAxisCount = isTablet ? 3 : 2;
        var widthContent = isTablet ? widthScreen / 3 : (widthScreen / 2);

        var itemHeight = widget.config.productListItemHeight;
        if (widget.config.showQuantity) {
          itemHeight += 30;
        }
        if (widget.config.showCartButton) {
          itemHeight += 30;
        }

        var childAspectRatio = (isTablet ? 0.94 : 1) *
            widthContent /
            (widthContent * (widget.config.imageRatio) + itemHeight);

        return LimitedBox(
          maxHeight: constraints.maxHeight,
          child: CustomScrollView(
            cacheExtent: 1000,
            slivers: <Widget>[
              if (widget.config.name != null)
                SliverToBoxAdapter(
                  child: HeaderView(
                    headerText: widget.config.name ?? '',
                    showSeeAll: !ServerConfig().isListingType,
                    callback: () => ProductModel.showList(
                      config: widget.config.jsonData,
                      cateId: _selectedCategory,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: Consumer<CategoryModel>(
                    builder: (context, provider, child) {
                      if (provider.isFirstLoad) {
                        return kLoadingWidget(context);
                      }

                      final categories = provider.categories;

                      if (categories == null) {
                        return const SizedBox();
                      }

                      final initCategory =
                          categoryConfig.items.firstWhereOrNull(
                        (element) =>
                            categories.any((e) => e.id == element.category),
                      );

                      if (initCategory == null) {
                        return const SizedBox();
                      }

                      _selectedCategory = initCategory.category;

                      _productCache.putIfAbsent(
                        position,
                        () => ListProductModel(
                          categoryId: initCategory.category,
                          limit: 25,
                        )..getData(),
                      );

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: categoryConfig.separateWidth),
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryConfig.items.length,
                        itemBuilder: (context, index) {
                          final category = categories.firstWhereOrNull(
                            (element) =>
                                element.id ==
                                categoryConfig.items[index].category,
                          );

                          if (category == null) return const SizedBox();

                          return ValueListenableBuilder(
                            valueListenable: _positionNotifier,
                            builder: (context, value, child) {
                              return CategoryIconItem(
                                isSelected: index == value,
                                commonConfig: categoryConfig.commonItemConfig,
                                itemConfig: categoryConfig.items[index],
                                iconSize: 64,
                                onTap: (_) {
                                  position = index;
                                  _selectedCategory = category.id!;
                                  _productCache.putIfAbsent(
                                    position,
                                    () => ListProductModel(
                                      categoryId: category.id!,
                                      limit: 25,
                                    )..getData(),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _positionNotifier,
                builder: (context, position, child) {
                  final productModel = _productCache[position];

                  if (productModel == null) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(),
                    );
                  }

                  return ListenableBuilder(
                    key: ValueKey(position),
                    listenable: productModel,
                    builder: (context, child) {
                      final productModel = _productCache[position]!;

                      if (productModel.isFirstLoad) {
                        return SliverToBoxAdapter(
                          child: kLoadingWidget(context),
                        );
                      }

                      final products = productModel.data;

                      if (products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Text(S.of(context).noProduct),
                          ),
                        );
                      }

                      if (widget.config.cardDesign == CardDesign.horizontal) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: false,
                            (BuildContext context, int index) {
                              return Services().widget.renderProductCardView(
                                    item: products[index],
                                    width: widthContent,
                                    config: widget.config,
                                    ratioProductImage: widget.config.imageRatio,
                                  );
                            },
                            childCount: products.length,
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.config.hPadding,
                          vertical: widget.config.vPadding,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: false,
                            (BuildContext context, int index) {
                              return Services().widget.renderProductCardView(
                                    item: products[index],
                                    width: widthContent,
                                    config: widget.config,
                                    ratioProductImage: widget.config.imageRatio,
                                  );
                            },
                            childCount: products.length,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
