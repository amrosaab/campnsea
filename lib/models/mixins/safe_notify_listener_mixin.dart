import 'package:flutter/cupertino.dart';

/// Use this mixin to avoid calling notifyListeners() after the widget is disposed.
/// This is useful when you call a function that calls notifyListeners() after
/// an async operation.
mixin SafeNotifyListenerMixin on ChangeNotifier {
  var _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
