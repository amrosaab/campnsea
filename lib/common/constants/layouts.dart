part of '../constants.dart';

/// constant for Layout category
// ignore: camel_case_types
enum kCategoriesLayout {
  card,
  sideMenu,
  column,
  subCategories,
  animation,
  grid
}

/// For Blog type constant
// ignore: camel_case_types
enum kBlogLayout {
  simpleType,
  fullSizeImageType,
  halfSizeImageType,
  oneQuarterImageType
}

/// Max product width on home screen
const kMaxProductWidth = 400.0;

/// Setting Item Style
enum SettingItemStyle {
  listTile,
  flat,
  flatShadow,
  flatListTile;

  factory SettingItemStyle.fromString(String? value) {
    switch (value) {
      case 'listTile':
        return SettingItemStyle.listTile;
      case 'flat':
        return SettingItemStyle.flat;
      case 'flatShadow':
        return SettingItemStyle.flatShadow;
      case 'flatListTile':
        return SettingItemStyle.flatListTile;
      default:
        return kItemProfileTypeDefault;
    }
  }
}

enum SettingStyle {
  style01,
  normal;

  factory SettingStyle.fromString(String? value) {
    switch (value) {
      case 'style01':
        return style01;
      case 'normal':
      default:
        return normal;
    }
  }
}

extension SettingItemStyleExt on SettingItemStyle {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case SettingItemStyle.flat:
        return Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6);
      case SettingItemStyle.flatListTile:
        return Theme.of(context).scaffoldBackgroundColor;
      case SettingItemStyle.flatShadow:
        return Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2);
      case SettingItemStyle.listTile:
      default:
        return Theme.of(context).colorScheme.background;
    }
  }

  BoxDecoration? decorationCardItem(BuildContext context) {
    return this == SettingItemStyle.flatListTile
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
          )
        : null;
  }

  double get paddingHorizontal {
    switch (this) {
      case SettingItemStyle.flatListTile:
        return 0;
      case SettingItemStyle.flat:
      case SettingItemStyle.flatShadow:
      case SettingItemStyle.listTile:
      default:
        return 15.0;
    }
  }
}
