import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'package:fstore/services/firebase/firebase_crashlytics_service.dart';

class FirebaseCrashlyticsServiceImpl extends FirebaseCrashlyticsService {
  // late FirebaseCrashlytics crashlytics;

  @override
  void init() async {
    // crashlytics = FirebaseCrashlytics.instance;
    //
    // await FirebaseCrashlytics.instance
    //     .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  @override
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameter,
  }) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameter);
  }
}
