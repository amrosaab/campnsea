import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/config/configuration_utils.dart';
import '../../../common/constants.dart';
import '../../../common/tools/biometrics_tools.dart';
import '../../../common/tools/tools.dart';
import '../../../data/boxes.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/service_config.dart';
import '../../../widgets/common/webview.dart';
import '../../../widgets/general/index.dart';
import '../../posts/post_screen.dart';
import '../../users/user_point_screen.dart';
import '../rate_myapp_mixin.dart';
import 'setting_item/setting_item_notification_widget.dart';
import 'setting_item/setting_item_widget.dart';

const itemPadding = 15.0;

class DynamicSettingItemWidget extends StatefulWidget {
  const DynamicSettingItemWidget({
    super.key,
    required this.type,
    this.subGeneralSetting,
    this.user,
    required this.cardStyle,
  });
  final String type;
  final Map? subGeneralSetting;
  final User? user;
  final SettingItemStyle? cardStyle;

  @override
  State<DynamicSettingItemWidget> createState() =>
      _DynamicSettingItemWidgetState();
}

class _DynamicSettingItemWidgetState extends State<DynamicSettingItemWidget>
    with RateMyAppMixin {
  SettingItemStyle? get _cardStyle => widget.cardStyle;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    Widget? trailing;
    Function() onTap;
    var isMultiVendor = ServerConfig().typeName.isMultiVendor;
    var subGeneralSetting = widget.subGeneralSetting != null
        ? ConfigurationUtils.loadSubGeneralSetting(widget.subGeneralSetting!)
        : kSubGeneralSetting;

    var item = subGeneralSetting[widget.type];

    if (widget.type.contains('web')) {
      return GeneralWebWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('post-')) {
      return GeneralPostWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('title')) {
      return GeneralTitleWidget(item: item, itemPadding: itemPadding);
    }

    if (widget.type.contains('button')) {
      return GeneralButtonWidget(item: item);
    }

    if (widget.type.contains('product-')) {
      return GeneralProductWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('category-')) {
      return GeneralCategoryWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('banner-')) {
      return GeneralBannerWidget(item: item);
    }

    if (widget.type.contains('blog-')) {
      return GeneralBlogWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('blogCategory-')) {
      return GeneralBlogCategoryWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('screen-')) {
      return GeneralScreenWidget(item: item, cardStyle: _cardStyle);
    }

    switch (widget.type) {
      case 'products':
        {
          if (!(widget.user != null ? widget.user!.isVender : false) ||
              !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).myProducts;
          icon = CupertinoIcons.cube_box;
          onTap = () => FluxNavigate.pushNamed(RouteList.productSell);
          break;
        }

      case 'chat':
        {
          if (widget.user == null ||
              ServerConfig().isListingType ||
              !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).conversations;
          icon = CupertinoIcons.chat_bubble_2;
          onTap = () {
            Navigator.pushNamed(
              context,
              RouteList.listChat,
              arguments: isMultiVendor && widget.user?.isVender == true,
            );
          };
          break;
        }
      case 'wallet':
        {
          if (widget.user == null || !ServerConfig().isWooType) {
            return const SizedBox();
          }
          title = S.of(context).myWallet;
          icon = CupertinoIcons.square_favorites_alt;
          onTap = () async {
            if (BiometricsTools.instance.isWalletSupported) {
              var didAuth = await BiometricsTools.instance.localAuth(context);
              if (!didAuth) {
                return;
              }
            }

            await FluxNavigate.pushNamed(
              RouteList.myWallet,
              forceRootNavigator: true,
            );
          };
          break;
        }
      case 'wishlist':
        {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<ProductWishListModel>(
                builder: (context, model, child) {
                  if (model.products.isNotEmpty) {
                    return Text(
                      '${model.products.length} ${S.of(context).items}',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
            ],
          );

          title = S.of(context).myWishList;
          icon = CupertinoIcons.heart;
          onTap = () => Navigator.of(context).pushNamed(RouteList.wishlist);
          break;
        }
      case 'notifications':
        {
          return SettingNotificationWidget(cardStyle: _cardStyle);
        }
      case 'language':
        {
          return Selector<AppModel, String?>(
            selector: (context, model) => model.langCode,
            builder: (context, langCode, _) {
              final languages = getLanguages();
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: CupertinoIcons.globe,
                title: S.of(context).language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languages.firstWhere(
                        (element) => langCode == element['code'],
                        orElse: () => {'text': ''},
                      )['text'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.language);
                },
              );
            },
          );
        }
      case 'currencies':
        {
          if (ServerConfig().isListingType) {
            return const SizedBox();
          }
          return Selector<AppModel, String?>(
            selector: (context, model) => model.currency,
            builder: (context, currency, _) {
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: CupertinoIcons.money_dollar_circle,
                title: S.of(context).currencies,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currency',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.currencies);
                },
              );
            },
          );
        }
      case 'darkTheme':
        {
          return Selector<AppModel, bool>(
            selector: (context, model) => model.darkTheme,
            builder: (context, darkTheme, _) {
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: darkTheme ? CupertinoIcons.moon : CupertinoIcons.sun_min,
                title: S.of(context).appearance,
                trailing: Text(
                  darkTheme
                      ? S.of(context).darkTheme
                      : S.of(context).lightTheme,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  context.read<AppModel>().updateTheme(!darkTheme);
                },
              );
            },
          );
        }
      case 'order':
        {
          var items = UserBox().orders;
          if (widget.user == null && items.isEmpty) {
            return const SizedBox();
          }
          if (ServerConfig().isListingType &&
              (ServerConfig().multiVendorType?.isEmpty ?? true)) {
            return const SizedBox();
          }
          icon = CupertinoIcons.time;
          title = S.of(context).orderHistory;
          onTap = () {
            final user = Provider.of<UserModel>(context, listen: false).user;
            FluxNavigate.pushNamed(
              RouteList.orders,
              arguments: user,
            );
          };
          break;
        }
      case 'point':
        {
          if (!(kAdvanceConfig.enablePointReward && widget.user != null)) {
            return const SizedBox();
          }
          if (ServerConfig().isListingType) {
            return const SizedBox();
          }
          icon = CupertinoIcons.bag_badge_plus;
          title = S.of(context).myPoints;
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPointScreen(),
                ),
              );
          break;
        }
      case 'rating':
        {
          icon = CupertinoIcons.star;
          title = S.of(context).rateTheApp;
          onTap = showRateMyApp;
          break;
        }
      case 'privacy':
        {
          icon = CupertinoIcons.doc_text;
          title = S.of(context).agreeWithPrivacy;
          onTap = () {
            final privacy = subGeneralSetting['privacy'];
            final pageId = privacy?.pageId ??
                (privacy?.webUrl == null
                    ? kAdvanceConfig.privacyPoliciesPageId
                    : null);
            String? pageUrl =
                privacy?.webUrl ?? kAdvanceConfig.privacyPoliciesPageUrl;
            if (pageId != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(
                      pageId: pageId,
                      pageTitle: S.of(context).agreeWithPrivacy,
                    ),
                  ));
              return;
            }
            if (pageUrl.isNotEmpty) {
              ///Display multiple languages WebView
              var locale =
                  Provider.of<AppModel>(context, listen: false).langCode;
              pageUrl += '?lang=$locale';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: pageUrl,
                    title: S.of(context).agreeWithPrivacy,
                  ),
                ),
              );
            }
          };
          break;
        }
      case 'about':
        {
          icon = CupertinoIcons.info;
          title = S.of(context).aboutUs;
          onTap = () {
            final about = subGeneralSetting['about'];
            final aboutUrl = about?.webUrl ?? SettingConstants.aboutUsUrl;

            if (kIsWeb) {
              return Tools.launchURL(aboutUrl);
            }
            return FluxNavigate.push(
              MaterialPageRoute(
                builder: (context) => WebView(
                  url: aboutUrl,
                  // title: S.of(context).aboutUs,
                ),
              ),
            );
          };
          break;
        }

      case 'post':
        {
          if (widget.user != null) {
            trailing = const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGrey600,
            );
            title = S.of(context).postManagement;
            icon = CupertinoIcons.chat_bubble_2;
            onTap = () {
              Navigator.of(context).pushNamed(RouteList.postManagement);
            };
          } else {
            return const SizedBox();
          }

          break;
        }
      case 'biometrics':
        {
          if (!BiometricsTools.instance.isSupported) {
            return const SizedBox();
          }

          return SettingItemWidget(
            cardStyle: _cardStyle,
            icon: CupertinoIcons.lock,
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).lockScreenAndSecurity,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  S.of(context).fingerprintsTouchID,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGrey600,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(RouteList.biometrics);
            },
          );
        }
      default:
        {
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          icon = Icons.error;
          title = S.of(context).dataEmpty;
          onTap = () {};
        }
    }

    return SettingItemWidget(
      icon: icon,
      title: title,
      trailing: trailing,
      onTap: onTap,
      cardStyle: widget.cardStyle,
    );
  }
}
