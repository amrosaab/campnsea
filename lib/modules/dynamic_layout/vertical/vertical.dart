import 'package:flutter/material.dart';

import '../config/category_config.dart';
import '../config/product_config.dart';
import '../helper/helper.dart';
import 'menu_layout.dart';
import 'menu_layout_with_custom_category.dart';
import 'pinterest_layout.dart';
import 'top_product_layout.dart';
import 'vertical_layout.dart';
import 'vertical_layout_with_filter.dart';

class VerticalLayout extends StatelessWidget {
  final config;
  final bool enableScrollView;
  final Future<void> Function()? onRefresh;

  const VerticalLayout({
    this.config,
    Key? key,
    required this.enableScrollView,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productConfig = ProductConfig.fromJson(config ?? {});
    switch (config['layout']) {
      case Layout.menu:
        return MenuLayout(config: productConfig);
      case Layout.menuCustom:
        final categoryConfigJson = config['categoryConfig'];
        if (categoryConfigJson == null) {
          throw Exception('categoryConfig is required');
        }
        final categoryConfig = CategoryConfig.fromJson(categoryConfigJson);
        return MenuLayoutWithCustomCategory(
          config: productConfig,
          categoryConfig: categoryConfig,
        );
      case Layout.pinterest:
        return PinterestLayout(config: productConfig);
      case Layout.topProducts:
        return TopProductLayout(config: productConfig);
      case Layout.columnsWithFilter:
        return VerticalViewLayoutWithFilter(config: productConfig);
      case Layout.card:
      case Layout.listTile:
      case Layout.list:
      case Layout.columns:
      default:
        return VerticalViewLayout(
          config: productConfig,
          enableScrollView: enableScrollView,
          onRefresh: onRefresh,
        );
    }
  }
}
