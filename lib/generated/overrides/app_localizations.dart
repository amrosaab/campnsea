import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_localization/multiple_localization.dart';

import '../intl/messages_all.dart';
import '../l10n.dart';
import 'mixins/override_translation_data_mixin.dart';
import 'mixins/override_translation_mixin.dart';

class _AppLocalizationCustomDelegate extends AppLocalizationDelegate {
  const _AppLocalizationCustomDelegate();

  @override
  Future<S> load(Locale locale) {
    return MultipleLocalizations.load(
        initializeMessages, locale, (l) => AppLocalization.load(Locale(l)),
        setDefaultLocale: true);
  }
}

class AppLocalization extends S
    with OverrideTranslateActionMixin, OverrideTranslateMixin {
  static Map? _customLanguage;
  static S _parent = S();

  static const AppLocalizationDelegate delegate =
      _AppLocalizationCustomDelegate();

  /// reload data custom language
  static void loadCustomLanguage(Map? customLanguage) {
    _customLanguage = customLanguage;
  }

  static Future<AppLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();

    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) async {
      Intl.defaultLocale = localeName;
      final instance = AppLocalization();
      _parent = await S.load(locale);
      return instance;
    });
  }

  @protected
  @override
  String getCustomTranslate(String key, String defauldValue, {Map? args}) {
    var text = customLanguage?[key];
    if (text is! String) {
      return defauldValue;
    }

    if (args?.isNotEmpty ?? false) {
      var textTrans = text.toString();

      for (var element in args!.entries) {
        textTrans =
            textTrans.replaceAll('{${element.key}}', '${element.value}');
      }

      return textTrans;
    }

    return text;
  }

  @protected
  @override
  S get parent => _parent;

  @protected
  @override
  Map? get customLanguage => _customLanguage;
}
