import 'onboarding_item_config.dart';

const int _kVersion = 1;
const bool _kEnableOnBoarding = true;
const bool _kAutoCropImageByDesign = false;
const bool _kIsOnlyShowOnFirstTime = true;
const bool _showLanguage = true;

class OnBoardingConfig {
  final bool _enableOnBoarding;
  final int version;
  final List<OnBoardingItemConfig> items;
  final bool autoCropImageByDesign;
  final bool isOnlyShowOnFirstTime;
  final bool showLanguage;

  bool get enableOnBoarding => _enableOnBoarding && items.isNotEmpty;

  OnBoardingConfig({
    bool enableOnBoarding = _kEnableOnBoarding,
    this.version = _kVersion,
    required this.items,
    this.autoCropImageByDesign = _kAutoCropImageByDesign,
    this.isOnlyShowOnFirstTime = _kIsOnlyShowOnFirstTime,
    this.showLanguage = _showLanguage,
  }) : _enableOnBoarding = enableOnBoarding;

  factory OnBoardingConfig.fromJson(Map json) {
    List onBoardingItems = json['data'] ?? [];
    var items = <OnBoardingItemConfig>[];

    for (var i = 0; i < onBoardingItems.length; i++) {
      items.add(OnBoardingItemConfig.fromJson(onBoardingItems[i]));
    }

    return OnBoardingConfig(
      enableOnBoarding: json['enableOnBoarding'] ?? _kEnableOnBoarding,
      version: json['version'] ?? _kVersion,
      items: items,
      autoCropImageByDesign:
          json['autoCropImageByDesign'] ?? _kAutoCropImageByDesign,
      isOnlyShowOnFirstTime:
          json['isOnlyShowOnFirstTime'] ?? _kIsOnlyShowOnFirstTime,
      showLanguage: json['showLanguage'] ?? _showLanguage,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['enableOnBoarding'] = _enableOnBoarding;
    data['version'] = version;
    data['data'] = items.map((v) => v.toJson()).toList();
    data['autoCropImageByDesign'] = autoCropImageByDesign;
    data['isOnlyShowOnFirstTime'] = isOnlyShowOnFirstTime;
    data['showLanguage'] = showLanguage;
    return data;
  }

  OnBoardingConfig copyWith({
    bool? enableOnBoarding,
    int? version,
    List<OnBoardingItemConfig>? items,
    bool? autoCropImageByDesign,
    bool? isOnlyShowOnFirstTime,
    bool? showLanguage,
  }) {
    return OnBoardingConfig(
      enableOnBoarding: enableOnBoarding ?? _enableOnBoarding,
      version: version ?? this.version,
      items: items ?? this.items.toList(),
      autoCropImageByDesign:
          autoCropImageByDesign ?? this.autoCropImageByDesign,
      isOnlyShowOnFirstTime:
          isOnlyShowOnFirstTime ?? this.isOnlyShowOnFirstTime,
      showLanguage: showLanguage ?? this.showLanguage,
    );
  }
}
