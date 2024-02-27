import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../common/delete_account_mixin.dart';
import '../mixins/setting_nomarl_mixin.dart';
import '../setting_builder_layout.dart';

class SettingLayoutStyle01Widget extends StatefulWidget {
  const SettingLayoutStyle01Widget({super.key, required this.dataSettings});

  final DataSettingScreen dataSettings;

  @override
  State<SettingLayoutStyle01Widget> createState() =>
      _SettingLayoutStyle01WidgetState();
}

class _SettingLayoutStyle01WidgetState extends State<SettingLayoutStyle01Widget>
    with DeleteAccountMixin, SettingNormalMixin {
  @override
  DataSettingScreen get dataSettings => widget.dataSettings;
  @override
  bool get showBackground => false;

  @override
  EdgeInsets get paddingContentInfoUser =>
      EdgeInsets.only(bottom: isLoginned ? 10 : 0, top: isLoginned ? 0 : 0);

  @override
  BuildContext get buildContext => context;

  @override
  ScrollController get scrollController => PrimaryScrollController.of(context);

  @override
  BoxDecoration? get decoration => [
        SettingItemStyle.flatShadow,
        SettingItemStyle.listTile
      ].contains(cardStyle)
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset.zero,
                )
              ],
            );

  @override
  Widget build(BuildContext context) {
    final generalSetting = Text(
      S.of(context).generalSetting,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
    final userCard =
        userInfoWidget == null ? const SizedBox() : userInfoWidget!;

    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        appBarWidget,
        // Items
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Padding(
                padding: const EdgeInsets.all(8).copyWith(top: 20),
                child: Container(
                  margin: marginHorizontalItemDynamic,
                  decoration: decoration,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: userCard,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0)
                    .copyWith(top: 20)
                    .copyWith(bottom: 10),
                child: generalSetting,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: marginHorizontalItemDynamic,
                  decoration: decoration,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Vendor
                      vendorAdminWidget,

                      /// Render some extra menu for Vendor.
                      /// Currently support WCFM & Dokan. Will support WooCommerce soon.
                      ...someExtraMenuForVendorWidget,

                      deliveryBoyWidget,

                      /// Render custom Wallet feature
                      // webViewProfileWidget,

                      /// render some extra menu for Listing
                      ...settingListingWidget,

                      const SizedBox(height: 10.0),

                      /// render list of dynamic menu
                      /// this could be manage from the Fluxbuilder
                      ...listDynamicItems,

                      /// Delete account
                      if (deleteAccountItem != null)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: itemPadding),
                          child: deleteAccountItem,
                        ),
                    ],
                  ),
                ),
              ),
              if (logoutItemWidget != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(top: 20),
                  child: logoutItemWidget,
                ),
              const SizedBox(height: 180),
            ],
          ),
        ),
      ],
    );
  }
}
