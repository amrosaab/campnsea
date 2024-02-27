import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart' show RouteList, printLog;
import '../../menu/index.dart' show MainTabControlDelegate;
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/config/tab_bar_config.dart';
import '../../screens/base_screen.dart';
import '../../services/index.dart';
import 'mixin/smart_chat_mixin.dart';

class OverlayControlDelegate {
  Function(String? nameRoute)? emitRoute;
  Function(String? nameRoute)? emitTab;
  static OverlayControlDelegate? _instance;

  factory OverlayControlDelegate() {
    return _instance ??= OverlayControlDelegate._();
  }

  OverlayControlDelegate._();
}

abstract class CustomOverlayState<T extends StatefulWidget>
    extends BaseScreen<T> with SmartChatMixin, TickerProviderStateMixin {
  double bottomBarHeight = kBottomNavigationBarHeight - 15;

  OverlayEntry? _overlayEntry;

  final _tag = 'custom-overlay';

  final overlayController = StreamController<bool>.broadcast()..add(false);

  bool get hasLabelInBottomBar;

  TabBarConfig? get tabBarConfig =>
      Provider.of<AppModel>(context, listen: false)
          .appConfig
          ?.settings
          .tabBarConfig;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        EasyDebounce.debounce(_tag, const Duration(seconds: 2), () {
          OverlayControlDelegate().emitRoute = _handleBottomBarHeight;
          OverlayControlDelegate().emitTab =
              (tabName) => _handleBottomBarHeight(tabName, onBottomBar: true);
          _overlayEntry = _buildOverlayEntry();
          Overlay.of(context).insert(_overlayEntry!);
          overlayController.sink.add(true);
          _handleBottomBarHeight(
            MainTabControlDelegate.getInstance().currentTabName(),
            onBottomBar: true,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancel(_tag);
    // This will make the FluxBuilder App run without errors
    // Because OverlayEntry close after this State dispose
    // overlayController.close();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleBottomBarHeight(String? screenName, {bool onBottomBar = false}) {
    var routeName = screenName;
    const excludeRoutes = [
      RouteList.dashboard,
      RouteList.products,
      RouteList.productDetail,
    ];
    final isExcludeRoute = screenName != null &&
        excludeRoutes.contains(screenName.split('?').first);
    if (isExcludeRoute || onBottomBar) {
      bottomBarHeight = kBottomNavigationBarHeight - 8;

      if (mounted && hasLabelInBottomBar) {
        bottomBarHeight += 20;
      }

      // Process when pop screen
      if (screenName == RouteList.dashboard) {
        final currentTabName =
            MainTabControlDelegate.getInstance().currentTabName();
        routeName = currentTabName;
      }
    } else {
      bottomBarHeight = 10;
    }

    printLog('[ScreenName] $routeName');
    final uri = Uri.parse(routeName ?? '');
    Services().advertisement.handleAd(uri.path);
    handleSmartChat(uri.path);
    overlayController.sink.add(true);
  }

  OverlayEntry _buildOverlayEntry() {
    final overlayMarginBottom = (tabBarConfig?.paddingTop ?? 0) +
        (tabBarConfig?.paddingBottom ?? 0) +
        (tabBarConfig?.marginBottom ?? 0);

    return OverlayEntry(
      builder: (_) {
        return StreamBuilder<bool>(
            stream: overlayController.stream,
            builder: (context, snapshot) {
              if (snapshot.data == false) return const SizedBox();
              return Positioned(
                bottom: bottomBarHeight +
                    MediaQuery.of(_).padding.bottom +
                    overlayMarginBottom,
                left: 0,
                right: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSmartChatWidget(),
                      Services().getAudioWidget(),
                      if (!ServerConfig().isBuilder)
                        Services().advertisement.getAdWidget(),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
