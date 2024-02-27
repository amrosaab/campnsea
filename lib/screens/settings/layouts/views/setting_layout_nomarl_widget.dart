import 'package:flutter/widgets.dart';

import '../../../../generated/l10n.dart';
import '../../../common/delete_account_mixin.dart';
import '../mixins/setting_nomarl_mixin.dart';
import '../setting_builder_layout.dart';

class SettingLayoutNormalWidget extends StatefulWidget {
  const SettingLayoutNormalWidget({
    super.key,
    required this.dataSettings,
  });

  final DataSettingScreen dataSettings;

  @override
  State<SettingLayoutNormalWidget> createState() =>
      _SettingLayoutNormalWidgetState();
}

class _SettingLayoutNormalWidgetState extends State<SettingLayoutNormalWidget>
    with DeleteAccountMixin, SettingNormalMixin {
  @override
  DataSettingScreen get dataSettings => widget.dataSettings;

  @override
  BuildContext get buildContext => context;

  @override
  ScrollController get scrollController => PrimaryScrollController.of(context);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        appBarWidget,
        // Items
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // UserInfo
                    if (userInfoWidget != null)
                      userInfoWidget!
                    else
                      const SizedBox(height: 30.0),

                    Text(
                      S.of(context).generalSetting,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10.0),

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
                  ],
                ),
              ),
              Container(
                margin: marginHorizontalItemDynamic,
                decoration: decoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// render list of dynamic menu
                    /// this could be manage from the Fluxbuilder
                    ...listDynamicItems,

                    /// Delete account
                    if (deleteAccountItem != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: itemPadding),
                        child: deleteAccountItem,
                      ),
                  ],
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
