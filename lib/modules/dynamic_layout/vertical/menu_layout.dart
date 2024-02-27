import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show AppModel, Category, CategoryModel, Product, ProductModel, UserModel;
import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';

class MenuLayout extends StatefulWidget {
  final ProductConfig config;

  const MenuLayout({required this.config});

  @override
  State<MenuLayout> createState() => _StateMenuLayout();
}

class _StateMenuLayout extends State<MenuLayout> {
  int position = 0;
  ValueNotifier<bool> loadingNotifier = ValueNotifier(true);
  Map<String, dynamic> productMap = <String, dynamic>{};

  /// Because StreamController with StreamBuilder widget when rendering in
  /// multiple places will casue the error "Bad state: Stream has already been
  /// listened to". So we need to use StreamController.broadcast or
  /// ValueNotifier instead of StreamController to solve this problem. But be
  /// careful when using ValueNotifier with asynchronous methods.

  // final StreamController productController = StreamController<List<Product>?>();

  final ValueNotifier<List<Product>?> productNotifier =
      ValueNotifier<List<Product>?>(null);

  @override
  void initState() {
    super.initState();
  }

  Future<void> getAllListProducts({
    minPrice,
    maxPrice,
    orderBy,
    order,
    lang,
    page = 1,
    required category,
  }) async {
    var service = Services();
    final userId = Provider.of<UserModel>(context, listen: false).user?.id;
    try {
      loadingNotifier.value = true;
      List<Product>? productList = [];
      if (productMap[category.id.toString()] != null) {
        productList = productMap[category.id.toString()];
      } else {
        productList = await service.api.fetchProductsByCategory(
          categoryId: category.id,
          minPrice: minPrice,
          maxPrice: maxPrice,
          orderBy: orderBy,
          order: order,
          page: page,
          userId: userId,
        );
      }
      productMap.update(category.id.toString(), (value) => productList,
          ifAbsent: () => productList);
      productNotifier.value = productList;
      loadingNotifier.value = false;
    } catch (e) {
      productNotifier.value = [];
      loadingNotifier.value = false;
    }
  }

  List<Category>? getAllCategory() {
    final categorieList =
        Provider.of<CategoryModel>(context, listen: true).categories;
    if (categorieList == null) return null;
    var listCategories = categorieList.where((item) => item.isRoot).toList();

    var categories = <Category>[];

    for (var cate in listCategories) {
      var children = categorieList.where((o) => o.parent == cate.id).toList();
      if (children.isNotEmpty) {
        categories = [...categories, ...children];
      } else {
        categories = [...categories, cate];
      }
    }
    if (loadingNotifier.value == true && categories.isNotEmpty) {
      getAllListProducts(
          category: categories[position],
          lang: Provider.of<AppModel>(context, listen: false).langCode);
    }
    return categories;
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    productNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categories = getAllCategory();
    if (categories == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: kLoadingWidget(context),
        ),
      );
    }

    return LayoutBuilder(
      builder: (_, constraints) {
        final isTablet = Tools.isTablet(MediaQuery.of(context));

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
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            position = index;
                          });
                          getAllListProducts(
                              category: categories[index],
                              lang:
                                  Provider.of<AppModel>(context, listen: false)
                                      .langCode);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  categories[index].name!.toUpperCase(),
                                  style: TextStyle(
                                      color: index == position
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              index == position
                                  ? Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              Theme.of(context).primaryColor),
                                      width: 20,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ValueListenableBuilder<List<Product>?>(
                valueListenable: productNotifier,
                builder: (_, productList, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: loadingNotifier,
                    builder: (_, loading, __) {
                      if (loading) {
                        if (widget.config.cardDesign == CardDesign.horizontal) {
                          return SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.config.hPadding,
                              vertical: widget.config.vPadding,
                            ),
                            sliver: SliverList.builder(
                              itemCount: 4,
                              key: categories.isNotEmpty
                                  ? Key(categories[position].id.toString())
                                  : UniqueKey(),
                              itemBuilder: (context, value) {
                                return Services().widget.renderProductCardView(
                                      item: Product.empty(value.toString()),
                                      width: widthScreen,
                                      config: ProductConfig.empty()
                                        ..imageRatio = widget.config.imageRatio,
                                    );
                              },
                            ),
                          );
                        }
                        return SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.config.hPadding,
                            vertical: widget.config.vPadding,
                          ),
                          sliver: SliverMasonryGrid.count(
                            crossAxisCount: crossAxisCount,
                            key: categories.isNotEmpty
                                ? Key(categories[position].id.toString())
                                : UniqueKey(),
                            childCount: 4,
                            itemBuilder: (context, value) {
                              return Services().widget.renderProductCardView(
                                    item: Product.empty(value.toString()),
                                    width: widthContent,
                                    config: ProductConfig.empty()
                                      ..imageRatio = widget.config.imageRatio,
                                  );
                            },
                            // staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
                          ),
                        );
                      }
                      if (productList != null && productList.isNotEmpty) {
                        if (widget.config.cardDesign == CardDesign.horizontal) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              addAutomaticKeepAlives: false,
                              (BuildContext context, int index) {
                                return Services().widget.renderProductCardView(
                                      item: productList[index],
                                      width: widthContent,
                                      config: widget.config,
                                      ratioProductImage:
                                          widget.config.imageRatio,
                                    );
                              },
                              childCount: productList.length,
                            ),
                          );
                        }
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 6.0,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: false,
                            (BuildContext context, int index) {
                              return Services().widget.renderProductCardView(
                                    item: productList[index],
                                    width: widthContent,
                                    config: widget.config,
                                    ratioProductImage: widget.config.imageRatio,
                                  );
                            },
                            childCount: productList.length,
                          ),
                        );
                      }
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Text(
                          S.of(context).noProduct,
                          textAlign: TextAlign.center,
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
