part of '../../boxes.dart';

extension GeneralSettings on SettingsBox {
  bool get hasFinishedOnboarding {
    return box.get(
      BoxKeys.hasFinishedOnboarding,
      defaultValue: false,
    );
  }

  set hasFinishedOnboarding(bool value) {
    box.put(BoxKeys.hasFinishedOnboarding, value);
  }

  bool get hasSelectedSite {
    return box.get(
      BoxKeys.hasSelectedSite,
      defaultValue: false,
    );
  }

  set hasSelectedSite(bool value) {
    box.put(BoxKeys.hasSelectedSite, value);
  }

  set selectedSiteConfig(String? value) {
    if (value == null) {
      box.delete(BoxKeys.selectedSiteConfig);
      return;
    }
    box.put(BoxKeys.selectedSiteConfig, value);
  }

  String? get isSelectedSiteConfig {
    return box.get(
      BoxKeys.selectedSiteConfig,
      defaultValue: null,
    );
  }

  bool? get isDarkTheme {
    return box.get(
      BoxKeys.isDarkTheme,
    );
  }

  set isDarkTheme(bool? value) {
    if (value == null) {
      box.delete(BoxKeys.isDarkTheme);
      return;
    }
    box.put(BoxKeys.isDarkTheme, value);
  }

  int get popupBannerLastUpdatedTime {
    return box.get(
      BoxKeys.popupBannerLastUpdatedTime,
      defaultValue: 0,
    );
  }

  set popupBannerLastUpdatedTime(int value) {
    box.put(BoxKeys.popupBannerLastUpdatedTime, value);
  }
}
