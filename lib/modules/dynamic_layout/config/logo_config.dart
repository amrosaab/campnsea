import 'dart:math';
import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';
import 'text_config.dart';

/// layout : 'logo'
/// showMenu : true
/// showLogo : true
/// showSearch : true
/// name : ''
/// color : ''
/// menuIcon : {'name':'','fontFamily':''}

const double _kLogoSize = 50.0;
const double _kIconSize = 24.0;
const double _kIconOpacity = 0.0;
const double _kOpacity = 1.0;
const double _kIconRadius = 6.0;
const double _kMinLogoSize = 10.0;

class LogoConfig {
  String? layout;
  String? image;
  bool? showMenu;
  bool showLogo = false;
  bool showSearch = false;
  bool showCart = false;
  bool showNotification = false;
  bool showBadgeCart = false;
  double opacity = _kOpacity;
  double iconOpacity = _kIconOpacity;
  double iconRadius = _kIconRadius;
  double iconSize = _kIconSize;
  double logoSize = _kLogoSize;
  HexColor? color;
  HexColor? iconColor;
  HexColor? iconBackground;
  MenuIcon? menuIcon;
  MenuIcon? cartIcon;
  MenuIcon? searchIcon;
  MenuIcon? notificationIcon;
  TextConfig? textConfig;

  LogoConfig({
    this.layout,
    this.showMenu,
    this.image,
    this.showLogo = false,
    this.showSearch = false,
    this.showCart = false,
    this.showNotification = false,
    this.opacity = _kOpacity,
    this.iconOpacity = _kIconOpacity,
    this.iconRadius = _kIconRadius,
    this.iconSize = _kIconSize,
    this.logoSize = _kLogoSize,
    this.color,
    this.iconColor,
    this.iconBackground,
    this.cartIcon,
    this.searchIcon,
    this.menuIcon,
    this.notificationIcon,
    this.textConfig,
    this.showBadgeCart = false,
  });

  @Deprecated('Use LogoConfig.textConfig.name instead')
  String get name {
    if (textConfig != null) {
      return textConfig!.text;
    }
    return '';
  }

  @Deprecated('Use LogoConfig.textConfig.name instead')
  set name(String? value) {
    if (textConfig != null) {
      textConfig!.text = value ?? '';
    } else {
      textConfig = TextConfig(text: value ?? '');
    }
  }

  LogoConfig.fromJson(dynamic json) {
    layout = json['layout'];
    textConfig = json['textConfig'] != null
        ? TextConfig.fromJson(json['textConfig'])
        : null;
    if (json['name'] != null && textConfig == null) {
      textConfig = TextConfig(text: json['name']);
    }
    image = json['image'];
    showMenu = json['showMenu'];
    showLogo = json['showLogo'] ?? false;
    showBadgeCart = json['showBadgeCart'] ?? false;

    showSearch = json['showSearch'] ?? false;
    showCart = json['showCart'] ?? false;
    showNotification = json['showNotification'] ?? false;

    opacity = Helper.formatDouble(json['opacity']) ?? _kOpacity;
    iconOpacity = Helper.formatDouble(json['iconOpacity']) ?? _kIconOpacity;
    iconRadius = Helper.formatDouble(json['iconRadius']) ?? _kIconRadius;
    iconSize = Helper.formatDouble(json['iconSize']) ?? _kIconSize;
    logoSize =
        max(Helper.formatDouble(json['logoSize']) ?? _kLogoSize, _kMinLogoSize);

    if (json['color'] != null) {
      color = HexColor(json['color']);
    }
    if (json['iconColor'] != null) {
      iconColor = HexColor(json['iconColor']);
    }
    if (json['iconBackground'] != null) {
      iconBackground = HexColor(json['iconBackground']);
    }

    searchIcon = json['searchIcon'] != null
        ? MenuIcon.fromJson(json['searchIcon'])
        : null;
    menuIcon =
        json['menuIcon'] != null ? MenuIcon.fromJson(json['menuIcon']) : null;
    cartIcon =
        json['cartIcon'] != null ? MenuIcon.fromJson(json['cartIcon']) : null;
    notificationIcon = json['notificationIcon'] != null
        ? MenuIcon.fromJson(json['notificationIcon'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['showMenu'] = showMenu;
    map['showLogo'] = showLogo;
    map['showSearch'] = showSearch;
    map['showCart'] = showCart;
    map['showNotification'] = showNotification;
    map['textConfig'] = textConfig?.toJson();
    map['logoSize'] = logoSize;
    map['color'] = color;
    if (menuIcon != null) {
      map['menuIcon'] = menuIcon?.toJson();
    }
    if (cartIcon != null) {
      map['cartIcon'] = cartIcon?.toJson();
    }
    if (notificationIcon != null) {
      map['notificationIcon'] = notificationIcon?.toJson();
    }
    return map;
  }
}

/// name : ''
/// fontFamily : ''

class MenuIcon {
  String? name;
  String? fontFamily;

  MenuIcon({this.name, this.fontFamily});

  MenuIcon.fromJson(dynamic json) {
    name = json['name'];
    fontFamily = json['fontFamily'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['fontFamily'] = fontFamily;
    return map;
  }
}
