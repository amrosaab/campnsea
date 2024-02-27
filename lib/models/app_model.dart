import 'dart:async';
import 'dart:convert' as convert;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/config/multi_site.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../modules/dynamic_layout/config/app_config.dart';
// import '../modules/salesiq_mobilisten/salesiq_services.dart';
import '../services/index.dart';
import 'advertisement/index.dart' show AdvertisementConfig;
import 'cart/cart_model.dart';
import 'category/category_model.dart';
import 'entities/currency.dart';
import 'filter_attribute_model.dart';
import 'product_wish_list_model.dart';
import 'user_model.dart';

class AppModel with ChangeNotifier {
  MultiSiteConfig? multiSiteConfig;
  AppConfig? appConfig;
  AdvertisementConfig advertisement = const AdvertisementConfig();
  Map? deeplink;
  late bool isMultivendor;

  /// Loading State setting
  bool isLoading = true;
  bool isInit = false;
  bool isOpenFloatMenu = false;

  /// Current and Payment settings
  String? currency;
  String? currencyCode;
  Map<String, dynamic> currencyRate = <String, dynamic>{};
  int? smallestUnitRate;

  /// Language Code
  String _langCode = kAdvanceConfig.defaultLanguage;

  String get langCode => _langCode;

  /// Theming values for light or dark theme mode
  ThemeMode? themeMode;

  bool get darkTheme => themeMode == ThemeMode.dark;

  set darkTheme(bool value) =>
      themeMode = value ? ThemeMode.dark : ThemeMode.light;

  ThemeConfig get themeConfig => darkTheme ? kDarkConfig : kLightConfig;

  /// The app will use mainColor from env.dart,
  /// or override it with mainColor from config JSON if found.
  String get mainColor {
    final configJsonMainColor = appConfig?.settings.mainColor;
    if (configJsonMainColor != null && configJsonMainColor.isNotEmpty) {
      return configJsonMainColor;
    }
    return themeConfig.mainColor;
  }

  /// Product and Category Layout setting
  List<String>? categories;
  List<Map>? remapCategories;
  Map? categoriesIcons;
  String categoryLayout = '';
  String vendorLayout = '';

  String get productListLayout => appConfig!.settings.productListLayout;

  double get ratioProductImage =>
      appConfig!.settings.ratioProductImage ??
      (kAdvanceConfig.ratioProductImage * 1.0);

  String get productDetailLayout =>
      appConfig!.settings.productDetail ?? kProductDetail.layout;

  kBlogLayout get blogDetailLayout => appConfig!.settings.blogDetail != null
      ? kBlogLayout.values.byName(appConfig!.settings.blogDetail!)
      : kAdvanceConfig.detailedBlogLayout;

  String? get countryCode => SettingsBox().countryCode;

  /// App Model Constructor
  AppModel([String? lang]) {
    _langCode = lang ?? _langCode;

    advertisement = AdvertisementConfig.fromJson(adConfig: kAdConfig);
    isMultivendor = ServerConfig().typeName.isMultiVendor;
  }

  void _updateAndSaveDefaultLanguage(String? lang) {
    final prefLang = SettingsBox().languageCode;
    _langCode =
        prefLang != null && prefLang.isNotEmpty ? prefLang : lang ?? _langCode;
    SettingsBox().languageCode = _langCode.split('-').first.toLowerCase();
  }

  /// Get persist config from Share Preference
  Future<bool> getPrefConfig({String? lang}) async {
    try {
      if (multiSiteConfig?.languageCode?.isEmpty ?? true) {
        _updateAndSaveDefaultLanguage(lang);
      }

      var defaultCurrency = kAdvanceConfig.defaultCurrency;

      darkTheme = SettingsBox().isDarkTheme ?? kDefaultDarkTheme;
      currency = SettingsBox().currency ?? defaultCurrency?.currencyDisplay;
      currencyCode =
          SettingsBox().currencyCode ?? defaultCurrency?.currencyCode;
      SettingsBox().countryCode = defaultCurrency?.countryCode;
      smallestUnitRate = _getCurrencyByCode(currencyCode)?.smallestUnitRate;
      isInit = true;
      await updateTheme(darkTheme);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeLanguage(String languageCode, BuildContext context) async {
    try {
      _langCode = languageCode;
      SettingsBox().languageCode = _langCode;

      await loadAppConfig(isSwitched: true);
      eventBus.fire(const EventChangeLanguage());
      unawaited(loadCurrency());

      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categoryModel.refreshCategoryList();
      unawaited(categoryModel.getCategories(
        lang: _langCode,
        sortingList: categories,
        categoryLayout: categoryLayout,
        remapCategories: remapCategories,
      ));
      unawaited(Provider.of<FilterAttributeModel>(context, listen: false)
          .getFilterAttributes());

      return true;
    } catch (err) {
      return false;
    }
  }

  Currency? _getCurrencyByCode(String? code) {
    final currencies = kAdvanceConfig.currencies;
    return currencies.firstWhereOrNull(
        (e) => e.currencyCode.toLowerCase() == code?.toLowerCase());
  }

  Future<void> changeCurrency(
      BuildContext context, Currency newCurrency) async {
    try {
      final cartModel = Provider.of<CartModel>(context, listen: false);

      currency = newCurrency.currencyDisplay;
      currencyCode = newCurrency.currencyCode;
      SettingsBox().currencyCode = currencyCode;
      SettingsBox().currency = currency;
      SettingsBox().countryCode = newCurrency.countryCode;

      cartModel.changeCurrency(newCurrency.currencyCode);
      cartModel.updatePriceWhenCurrencyChanged();
      smallestUnitRate = _getCurrencyByCode(currencyCode)?.smallestUnitRate;
      notifyListeners();
    } catch (error) {
      printLog('[changeCurrency] error: ${error.toString()}');
    }
  }

  Future<void> updateTheme(bool theme) async {
    try {
      darkTheme = theme;
      SettingsBox().isDarkTheme = theme;
      notifyListeners();
    } catch (error) {
      printLog('[updateTheme] error: ${error.toString()}');
    }
  }

  void loadStreamConfig(config) {
    appConfig = AppConfig.fromJson(config);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCloudAppConfig(String url) async {
    /// Do not enable cache here because we need to get the latest config JSON.
    final appJson = await http.get(
      Uri.encodeFull(url).toUri()!,
      headers: {
        'Accept': 'application/json',
      },
    );
    appConfig = AppConfig.fromJson(
      convert.jsonDecode(
        convert.utf8.decode(appJson.bodyBytes),
      ),
    );
  }

  Future applyAppCaching() async {
    /// apply App Caching if isCaching is enable
    /// not use for Fluxbuilder
    if (!ServerConfig().isBuilder) {
      await Services().widget.onLoadedAppConfig(langCode, (configCache) {
        appConfig = AppConfig.fromJson(configCache);
      });
    }
  }

  void handleCategoryTab(TabBarMenuConfig categoryTab) {
    if (categoryTab.categories != null) {
      categories = List<String>.from(categoryTab.categories ?? []);
      if (ServerConfig().isShopify) {
        /// Support old type category (base64) work with new API
        /// Old type is base64, new type is url like gid://shopify/Collection/123456789
        categories = categories?.map(_parseShopifyCategories).toList();
      }
    }
    if (categoryTab.images != null) {
      categoriesIcons =
          categoryTab.images is Map ? Map.from(categoryTab.images) : null;
    }
    if (categoryTab.remapCategories != null) {
      remapCategories = categoryTab.remapCategories;

      /// Support old type category (base64) work with new API
      /// Old type is base64, new type is url like gid://shopify/Collection/123456789
      if (ServerConfig().isShopify) {
        remapCategories = remapCategories?.map((e) {
          for (var key in ['parent', 'category']) {
            if (e[key] != null) {
              e[key] = _parseShopifyCategories(e[key]);
            }
          }
          return e;
        }).toList();
      }
    }
    categoryLayout = categoryTab.categoryLayout;
  }

  Future<AppConfig?> loadAppConfig(
      {isSwitched = false, Map<String, dynamic>? config}) async {
    isLoading = true;
    notifyListeners();

    var startTime = DateTime.now();

    if (_langCode == '') {
      _langCode = kAdvanceConfig.defaultLanguage;
    }

    try {
      if (!isInit || _langCode.isEmpty) {
        await getPrefConfig();
      }

      if (config != null) {
        appConfig = AppConfig.fromJson(config);
      } else {
        /// load config from Notion
        if (ServerConfig().type == ConfigType.notion) {
          final appCfg = await Services().widget.onGetAppConfig(langCode);

          if (appCfg != null) {
            appConfig = appCfg;
          }
        }

        await _loadConfigJson();
      }

      await applyAppCaching();

      /// Load categories config for the Tabbar menu
      /// User to sort the category Setting
      /// Prefer loading category configuration from the first vendor tab

      final vendorTab = appConfig!.tabBar
          .toList()
          .firstWhereOrNull((e) => e.layout == 'vendors');

      final categoryTab = appConfig!.tabBar
          .toList()
          .firstWhereOrNull((e) => e.layout == 'category');

      if (vendorTab != null) {
        handleCategoryTab(vendorTab);
        vendorLayout = vendorTab.vendorLayout;
      } else if (categoryTab != null) {
        handleCategoryTab(categoryTab);
      }

      if (appConfig?.settings.tabBarConfig.alwaysShowTabBar != null) {
        Configurations().setAlwaysShowTabBar(
            appConfig?.settings.tabBarConfig.alwaysShowTabBar ?? false);
      }
      isLoading = false;

      notifyListeners();
      printLog('[Debug] Finish Load AppConfig', startTime);
      eventBus.fire(const EventLoadedAppConfig());
      return appConfig;
    } catch (err, trace) {
      printLog('🔴 AppConfig JSON loading error');
      printError(err, trace);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> loadCurrency({Function(Map<String, dynamic>)? callback}) async {
    try {
      /// Load the Rate for Product Currency
      final rates = await Services().api.getCurrencyRate();
      if (rates != null) {
        currencyRate = rates;
        callback?.call(rates);
      }
    } catch (_) {}
  }

  void updateProductListLayout(layout) {
    appConfig!.settings =
        appConfig!.settings.copyWith(productListLayout: layout);
    notifyListeners();
  }

  void raiseNotify() {
    notifyListeners();
  }

  String _parseShopifyCategories(String categoryId) {
    try {
      return EncodeUtils.decode(categoryId);
    } on FormatException catch (_) {
      return categoryId;
    }
  }

  void setMainSiteConfig() {
    if (SettingsBox().isSelectedSiteConfig?.isNotEmpty ?? false) {
      multiSiteConfig = Configurations.multiSiteConfigs?.firstWhereOrNull(
          (e) => e.serverConfig?['url'] == SettingsBox().isSelectedSiteConfig);
    }

    multiSiteConfig ??= (Configurations.multiSiteConfigs?.isNotEmpty ?? false)
        ? Configurations.multiSiteConfigs!.first
        : null;
    SettingsBox().selectedSiteConfig = multiSiteConfig?.serverConfig?['url'];
    Configurations.serverConfig =
        multiSiteConfig?.serverConfig ?? Configurations.serverConfig;
    Services().setAppConfig(serverConfig);
    MultiSite.mainSiteUrl = Uri.parse(Configurations.mainSiteUrl);
    _updateAndSaveDefaultLanguage(multiSiteConfig?.languageCode);
  }

  Future changeSiteConfig(BuildContext context, MultiSiteConfig? config) async {
    if (multiSiteConfig?.name != config?.name) {
      try {
        await Provider.of<UserModel>(context, listen: false).logout();
        Provider.of<CartModel>(context, listen: false).clearCart();
        await Provider.of<ProductWishListModel>(context, listen: false)
            .clearWishList();
        UserBox().orders = []; //clear local orders when change site

        multiSiteConfig = config;
        SettingsBox().selectedSiteConfig =
            multiSiteConfig?.serverConfig?['url'];
        Configurations.serverConfig =
            multiSiteConfig?.serverConfig ?? Configurations.serverConfig;
        Services().setAppConfig(serverConfig);
        if (config?.currencyCode?.isNotEmpty ?? false) {
          var currency = _getCurrencyByCode(config!.currencyCode!);
          if (currency != null) {
            await changeCurrency(context, currency);
          }
        }
        await changeLanguage(config?.languageCode ?? _langCode, context);
      } catch (e) {
        rethrow;
      }
    }
  }

  Map? get overrideTranslation {
    if ((appConfig?.overrideTranslation?['@@locale'] ?? '') != langCode) {
      return null;
    }

    return appConfig?.overrideTranslation;
  }

  Future _loadConfigJson() async {
    try {
      var configFolderPath = multiSiteConfig?.configFolder;

      if (kAppConfig.contains('http')) {
        // load on cloud config and update on air
        var path = kAppConfig;
        if (path.contains('.json')) {
          path = path.substring(0, path.lastIndexOf('/'));
          if (configFolderPath?.isNotEmpty ?? false) {
            path += '/$configFolderPath';
          }
          path += '/config_$langCode.json';
        }
        try {
          await fetchCloudAppConfig(path);
        } catch (_) {
          /// In case config_$langCode.json is not found,
          /// load user's original config URL.
          printLog(
              '🚑 Config at $path not found. Loading from $kAppConfig instead.');
          await fetchCloudAppConfig(kAppConfig);
        }
      } else {
        // load local config
        var path = (configFolderPath?.isNotEmpty ?? false)
            ? 'lib/config/$configFolderPath/config_$langCode.json'
            : 'lib/config/config_$langCode.json';

        try {
          final appJson = await rootBundle.loadString(path);
          appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
        } catch (e) {
          printLog(e);
          var path = kAppConfig;
          //load default template for site if config_xx.json is not existed in configFolderPath for multi sites
          if (configFolderPath?.isNotEmpty ?? false) {
            path =
                'lib/config/$configFolderPath/config_${multiSiteConfig?.languageCode ?? 'en'}.json';
          }
          final appJson = await rootBundle.loadString(path);
          appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
