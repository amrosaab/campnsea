import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../services/index.dart';

class FlashHelper {
  static Completer<BuildContext> _buildCompleter = Completer<BuildContext>();

  static void init(BuildContext context) {
    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.complete(context);
    }
  }

  static void dispose() {
    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.completeError(FlutterError('disposed'));
    }
    _buildCompleter = Completer<BuildContext>();
  }

  // Fix bug https://github.com/sososdk/flash/issues/50
  static Brightness brightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  static TextStyle _titleStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    return (theme.dialogTheme.titleTextStyle ?? theme.textTheme.titleMedium)!
        .copyWith(color: color);
  }

  static TextStyle _contentStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    return (theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge)!
        .copyWith(color: color);
  }

  static Future<T?> informationBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return showFlash<T>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return FlashBar(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          dismissDirections: const [FlashDismissDirection.startToEnd],
          backgroundColor: Colors.black87,
          //brightness: brightness(context),
          title: title == null
              ? null
              : Text(title, style: _titleStyle(context, Colors.white)),
          content: Text(message, style: _contentStyle(context, Colors.white)),
          icon: Icon(Icons.info_outline, color: Colors.blue[300]),
          indicatorColor: Colors.blue[300],
        );
      },
    );
  }

  static Future<T?>? errorBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    try {
      return showFlash<T>(
        context: context,
        duration: duration,
        builder: (_, controller) {
          return FlashBar(
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.bottom,
            dismissDirections: const [FlashDismissDirection.startToEnd],
            backgroundColor: Colors.black87,
            //brightness: brightness(context),
            title: title == null
                ? null
                : Text(title, style: _titleStyle(context, Colors.white)),
            content: Text(message, style: _contentStyle(context, Colors.white)),
            icon: Icon(Icons.warning, color: Colors.red[300]),
            indicatorColor: Colors.red[300],
          );
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<T?>? message<T>(
    BuildContext context, {
    IconData? icon,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
    GestureTapCallback? onTap,
  }) {
    try {
      return showFlash<T>(
        context: context,
        duration: duration,
        persistent: !ServerConfig().isBuilder,
        onBarrierTap: onTap != null
            ? () {
                onTap.call();
                return false; //dismiss
              }
            : null,
        barrierDismissible: onTap != null,
        builder: (context, controller) {
          return FlashBar(
            backgroundColor: isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).primaryColor,
            //brightness: brightness(context),
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            dismissDirections: const [FlashDismissDirection.startToEnd],
            icon: Icon(
              icon ?? (isError ? Icons.error_outline : Icons.check),
              color: Colors.white,
            ),
            title: title != null
                ? Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  )
                : null,
            content: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: isError ? 18.0 : 15.0,
              ),
            ),
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(null),
              child: Text(
                S.of(context).close,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          );
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<T?>? errorMessage<T>(
    BuildContext context, {
    IconData? icon,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return FlashHelper.message(
      context,
      message: message,
      icon: icon,
      duration: duration,
      isError: true,
    );
  }
}

typedef ActionCallback = void Function(FlashController controller);
