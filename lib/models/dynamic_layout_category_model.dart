import 'package:flutter/foundation.dart';
import '../modules/dynamic_layout/config/category_item_config.dart';
import '../modules/dynamic_layout/config/category_config.dart';

class DynamicLayoutCategoryModel extends ChangeNotifier {
  DynamicLayoutCategoryModel(this.originalCategoryConfig) {
    categoryConfig = originalCategoryConfig;
  }

  late CategoryConfig categoryConfig;

  final CategoryConfig originalCategoryConfig;

  bool isFilterAlphabetically = false;

  String keyword = '';

  void onSearch(String keyword) {
    this.keyword = keyword;
    categoryConfig = categoryConfig.copyWith(
      items: _search(keyword, filter: isFilterAlphabetically),
    );

    notifyListeners();
  }

  void onFilterAlphabetically(bool enable) {
    isFilterAlphabetically = enable;
    categoryConfig = categoryConfig.copyWith(
      items: _search(keyword, filter: enable),
    );

    notifyListeners();
  }

  List<CategoryItemConfig> _search(String keyword, {required bool filter}) {
    var results = originalCategoryConfig.items.where((element) {
      final title = element.title ?? '';
      return title.toLowerCase().contains(keyword);
    }).toList();

    if (filter) {
      results.sort((a, b) {
        final title = a.title ?? '';
        final title2 = b.title ?? '';
        return title.compareTo(title2);
      });
    }

    return results;
  }
}
