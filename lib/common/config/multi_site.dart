import 'dart:io';

import 'package:inspireui/utils/logs.dart';
import 'package:quiver/strings.dart';

void printValidationLog(String message) {
  printLog('===============================================================');
  printLog('❓ multiSiteConfigs error: $message');
  printLog('===============================================================');
}

class MultiSiteConfig {
  const MultiSiteConfig(
      {this.configFolder,
      this.serverConfig,
      this.name,
      this.icon,
      this.languageCode,
      this.currencyCode});

  final String? configFolder;
  final Map? serverConfig;
  final String? name;
  final String? icon;
  final String? languageCode;
  final String? currencyCode;

  factory MultiSiteConfig.fromJson(Map json) {
    if (!isNotBlank(json['name'])) {
      printValidationLog('name is required');
      exit(0);
    }
    if (!isNotBlank(json['configFolder'])) {
      printValidationLog('configFolder is required');
      exit(0);
    }
    if (json['serverConfig'] == null || json['serverConfig'] is! Map) {
      printValidationLog('serverConfig is invalid');
      exit(0);
    }
    return MultiSiteConfig(
      configFolder: json['configFolder'],
      serverConfig: json['serverConfig'],
      name: json['name'],
      icon: json['icon'],
      languageCode: json['languageCode'],
      currencyCode: json['currencyCode'],
    );
  }
}
