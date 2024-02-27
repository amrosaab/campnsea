import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app.dart';
import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../common/events.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/index.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../services/index.dart';
import '../../../common/delete_account_mixin.dart';
import '../../../users/delete_account_screen.dart';
import '../../widgets/app_bar_setting_widget.dart';
import '../../widgets/dynamic_setting_item_widget.dart';
import '../../widgets/setting_delivery_boy_widget.dart';
import '../../widgets/setting_item/setting_item_widget.dart';
import '../../widgets/setting_user_info_widget.dart';
import '../../widgets/setting_vendor_admin_widget.dart';
import '../../widgets/setting_vendor_vacation_widget.dart';
import '../setting_builder_layout.dart';

mixin SettingNormalMixin on DeleteAccountMixin {
  ScrollController get scrollController;
  bool isAbleToPostManagement = false;
  final bannerHigh = 150.0;

  DataSettingScreen get dataSettings;
  BuildContext get buildContext;

  User? get user => Provider.of<UserModel>(buildContext).user;

  /// ----- Style Setting -----

  // style for screen setting
  SettingStyle get settingStyle => dataSettings.settingStyle;

  // style for item setting
  SettingItemStyle get cardStyle => dataSettings.cardStyle;

  bool get hideUser => dataSettings.hideUser;
  bool get showBackground => dataSettings.showBackground ?? true;
  List get settings => dataSettings.settings;
  Map? get drawerIcon => dataSettings.drawerIcon;
  bool get isLoginned => user != null;

  // Data UI
  String? get background => dataSettings.background;
  double get itemPadding => cardStyle.paddingHorizontal;
  Color get backgroundColor => cardStyle.backgroundColor(buildContext);
  BoxDecoration? get decoration => cardStyle.decorationCardItem(buildContext);
  EdgeInsets? get marginHorizontalItemDynamic =>
      cardStyle == SettingItemStyle.flatListTile
          ? const EdgeInsets.symmetric(horizontal: 16)
          : null;

  void _onLogout() {
    eventBus.fire(const EventExpiredCookie());
  }

  void _processDeleteAccount() async {
    final result = await FluxNavigate.pushNamed(
      RouteList.deleteAccount,
      arguments: DeleteAccountArguments(
        confirmCaptcha: kAdvanceConfig.gdprConfig.confirmCaptcha,
        userToken:
            Provider.of<UserModel>(buildContext, listen: false).user?.cookie ??
                '',
      ),
    ) as bool?;
    if (result ?? false) {
      Services().firebase.deleteAccount();
      eventBus.fire(const EventExpiredCookie());
    }
  }

  ///----------------------------
  ///---------- WIDGET ----------
  ///----------------------------

  /// App Bar
  AppBarSettingWidget get appBarWidget => AppBarSettingWidget(
        background: background,
        showBackground: showBackground,
        drawerIcon: drawerIcon,
      );

  /// User Info
  EdgeInsets get paddingContentInfoUser =>
      const EdgeInsets.only(top: 10, bottom: 30);
  SettingUserInfoWidget? get userInfoWidget => hideUser
      ? null
      : SettingUserInfoWidget(
          paddingContent: paddingContentInfoUser,
          cartStyle: cardStyle,
          onTapLogout: _onLogout,
        );

  /// Vendor Admin
  SettingVendorAdminWidget get vendorAdminWidget => SettingVendorAdminWidget(
        user: user,
        cardStyle: cardStyle,
      );

  /// Render some extra menu for Vendor.
  /// Currently support WCFM & Dokan. Will support WooCommerce soon.
  bool get isRenderSomeExtraMenuForVendor =>
      ServerConfig().isVendorType() && (user?.isVender ?? false);
  List<Widget> get someExtraMenuForVendorWidget =>
      isRenderSomeExtraMenuForVendor
          ? <Widget>[
              Services().widget.renderVendorOrder(buildContext, cardStyle),
              SettingVendorVacationWidget(
                user: user,
                cardStyle: cardStyle,
              ),
            ]
          : <Widget>[];

  /// SettingDeliveryBoyWidget
  SettingDeliveryBoyWidget get deliveryBoyWidget => SettingDeliveryBoyWidget(
        user: user,
        cardStyle: cardStyle,
      );

  /// Render custom Wallet feature
  // final webViewProfileWidget = WebViewProfileWidget(user: user, cardStyle: cardStyle);

  /// render some extra menu for Listing
  bool get isRenderListing => user != null && ServerConfig().isListingType;
  List<Widget> get settingListingWidget => isRenderListing
      ? <Widget>[
          Services().widget.renderNewListing(buildContext, cardStyle),
          Services().widget.renderBookingHistory(buildContext, cardStyle),
        ]
      : <Widget>[];

  /// render list of dynamic menu
  /// this could be manage from the Fluxbuilder
  List<Widget> get listDynamicItems => List.generate(
        settings.length,
        (index) {
          var item = settings[index];
          if (item is! String) {
            return const SizedBox();
          } else {
            var isTitle = item.contains('title');
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTitle ? 0.0 : itemPadding,
              ),
              child: DynamicSettingItemWidget(
                type: item,
                cardStyle: cardStyle,
                user: user,
                subGeneralSetting: dataSettings.subGeneralSetting,
              ),
            );
          }
        },
      );

  /// Delete account
  bool get isShowDeleteAccount =>
      user != null &&
      kAdvanceConfig.gdprConfig.showDeleteAccount &&
      ServerConfig().isSupportDeleteAccount;
  SettingItemWidget? get deleteAccountItem => isShowDeleteAccount
      ? SettingItemWidget(
          cardStyle: cardStyle,
          iconWidget: const Icon(
            CupertinoIcons.delete,
            color: kColorRed,
            size: 22,
          ),
          iconColor: kColorRed,
          titleWidget: Text(
            S.current.deleteAccount,
            style: const TextStyle(color: kColorRed),
          ),
          trailing: const SizedBox(),
          onTap: () async {
            final acceptDelete = await showConfirmDeleteAccountDialog(
              App.fluxStoreNavigatorKey.currentContext ?? buildContext,
            );
            if (acceptDelete) {
              _processDeleteAccount();
            }
          },
        )
      : null;

  /// Logout
  bool get isShowLogoutSettingItemStyleListTile =>
      user != null && cardStyle != SettingItemStyle.listTile;
  Widget? get logoutItemWidget => isShowLogoutSettingItemStyleListTile
      ? ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(
            Icons.logout,
            size: 20,
            // color: Theme.of(buildContext).colorScheme.secondary,
          ),
          onPressed: _onLogout,
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              S.of(buildContext).logout,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        )
      : null;
}
