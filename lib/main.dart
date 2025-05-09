import 'dart:async';
import 'dart:io' show HttpClient, SecurityContext;

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_firebase/index.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_platform/universal_platform.dart';

import 'app.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'common/tools/biometrics_tools.dart';
import 'data/boxes.dart';
import 'env.dart';
import 'modules/webview/index.dart';
import 'services/dependency_injection.dart';
import 'services/locale_service.dart';
import 'services/services.dart';
import 'dart:isolate';

Future<void> _firebaseMessagingBackgroundHandler(dynamic message) async {
  await Firebase.initializeApp();
  printLog('Handling a background message ${message.messageId}');
}

void _setupApplication() {
  Configurations().setConfigurationValues(environment);

  /// Fix issue android sdk version 22 can not run the app.
  if (UniversalPlatform.isAndroid) {
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(Uint8List.fromList(isrgRootX1.codeUnits));
  }

  /// Support Webview (iframe) for Flutter Web. Requires this below header.
  /// Content-Security-Policy: frame-ancestors 'self' *.yourdomain.com
  registerWebViewWebImplementation();

  /// Hide status bar for splash screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  Provider.debugCheckInvalidValueType = null;

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void main() {
  printLog('[main] ===== START main.dart =======');

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// Call the setup for the application.
    _setupApplication();

    /// get language code default
    var languageCode = kAdvanceConfig.defaultLanguage;

    /// Init Hive boxes.
    await initBoxes();

    if (!foundation.kIsWeb) {
      /// Enable network traffic logging.
      HttpClient.enableTimelineLogging = !foundation.kReleaseMode;

      /// Lock portrait mode.
      unawaited(SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]));
    }

    await GmsCheck().checkGmsAvailability(enableLog: foundation.kDebugMode);

    try {
      if (isMobile) {
        /// Init Firebase settings due to version 0.5.0+ requires to.
        /// Use await to prevent any usage until the initialization is completed.
        await Services().firebase.init();
        await Configurations().loadRemoteConfig();
        await BiometricsTools.instance.init();
      }
    } catch (e) {
      printLog(e);
      printLog('🔴 Firebase init issue');
    }

    await DependencyInjection.inject();
    Services().setAppConfig(serverConfig);

    if (isMobile && kAdvanceConfig.autoDetectLanguage) {
      final lang = SettingsBox().languageCode;

      if (lang?.isEmpty ?? true) {
        languageCode = await LocaleService().getDeviceLanguage();
      } else {
        languageCode = lang.toString();
      }
    }

    if (serverConfig['type'] == 'vendorAdmin') {
      return runApp(Services()
          .getVendorAdminApp(languageCode: languageCode, isFromMV: false));
    }

    if (serverConfig['type'] == 'delivery') {
      return runApp(Services()
          .getDeliveryApp(languageCode: languageCode, isFromMV: false));
    }

    ResponsiveSizingConfig.instance.setCustomBreakpoints(
        const ScreenBreakpoints(desktop: 900, tablet: 600, watch: 100));

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    runApp(App(languageCode: languageCode));
  },  (error, stack) {
    printError(error, stack);
    FirebaseCrashlytics.instance.recordError(error, stack);
  },
  );

}
