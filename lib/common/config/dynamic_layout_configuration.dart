import '../../modules/dynamic_layout/config/app_config.dart';

abstract class DynamicLayoutConfiguration {
  static bool enableSearch(TabBarMenuConfig config) {
    final label = config.jsonData['label'].toString().toLowerCase();
    return label == 'الماركات' || label == 'brands';
  }

  static bool resizeToAvoidBottomInset(TabBarMenuConfig config) {
    final label = config.jsonData['label'].toString().toLowerCase();
    return label != 'الماركات' && label != 'brands';
  }
}