import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard;
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/dynamic_layout_category_model.dart';
import '../../models/index.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/index.dart';
import '../../services/index.dart';
import 'banner/banner_animate_items.dart';
import 'banner/banner_group_items.dart';
import 'banner/banner_horizontal.dart';
import 'banner/banner_slider.dart';
import 'blog/blog_grid.dart';
import 'brand/brand_layout.dart';
import 'button/button.dart';
import 'category/category_icon.dart';
import 'category/category_image.dart';
import 'category/category_menu_with_products.dart';
import 'category/category_text.dart';
import 'config/brand_config.dart';
import 'config/index.dart';
import 'divider/divider.dart';
import 'header/header_search.dart';
import 'header/header_text.dart';
import 'helper/helper.dart';
import 'instagram_story/instagram_story.dart';
import 'logo/logo.dart';
import 'product/product_list_simple.dart';
import 'product/product_recent_placeholder.dart';
import 'slider_testimonial/index.dart';
import 'spacer/spacer.dart';
import 'story/index.dart';
import 'testimonial/index.dart';
import 'tiktok/index.dart';
import 'video/index.dart';

class DynamicLayout extends StatelessWidget {
  final config;
  final bool cleanCache;
  final bool enableSearch;

  const DynamicLayout({
    this.config,
    this.cleanCache = false,
    this.enableSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: true);

    switch (config['layout']) {
      case Layout.logo:
        final themeConfig = appModel.themeConfig;
        return Logo(
          config: LogoConfig.fromJson(config),
          logo: themeConfig.logo,
          totalCart:
              Provider.of<CartModel>(context, listen: true).totalCartQuantity,
          notificationCount:
              Provider.of<NotificationModel>(context).unreadCount,
          onSearch: () {
            FluxNavigate.pushNamed(RouteList.homeSearch);
          },
          onCheckout: () {
            FluxNavigate.pushNamed(RouteList.cart);
          },
          onTapNotifications: () {
            FluxNavigate.pushNamed(RouteList.notify);
          },
          onTapDrawerMenu: () => NavigateTools.onTapOpenDrawerMenu(context),
        );

      case Layout.headerText:
        return HeaderText(
          config: HeaderConfig.fromJson(config),
        );

      case Layout.headerSearch:
        return HeaderSearch(
          config: HeaderConfig.fromJson(config),
          onSearch: () {
            FluxNavigate.pushNamed(
              RouteList.homeSearch,
              forceRootNavigator: true,
            );
          },
        );
      case Layout.featuredVendors:
        return Services().widget.renderFeatureVendor(config);
      case Layout.category:
        return ChangeNotifierProvider(
          create: (context) => DynamicLayoutCategoryModel(
            CategoryConfig.fromJson(config),
          ),
          child: Builder(builder: (context) {
            return Consumer<DynamicLayoutCategoryModel>(
                builder: (context, model, child) {
              return Column(
                children: [
                  if (enableSearch)
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: IntrinsicHeight(
                              child: SearchBox(
                                onChanged: model.onSearch,
                                showQRCode: false,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Center(
                            child: Text(
                              //TODO: Should be fetched from localization.
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'أ-ي'
                                  : 'A-Z',
                            ),
                          ),
                          Switch(
                            value: model.isFilterAlphabetically,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: model.onFilterAlphabetically,
                          )
                        ],
                      ),
                    ),
                  AutoHideKeyboard(
                    child: Column(
                      children: [
                        if (config['type'] == 'image')
                          CategoryImages(
                            config: model.categoryConfig,
                          )
                        else
                          Selector<CategoryModel, Map<String?, Category>>(
                            selector: (_, model) => model.categoryList,
                            builder: (context, categoryList, child) {
                              var configValue = model.categoryConfig;
                              var listCategoryName = categoryList
                                  .map((key, value) => MapEntry(key, value.name));
                              void onShowProductList(CategoryItemConfig item) {
                                FluxNavigate.pushNamed(
                                  RouteList.backdrop,
                                  arguments: BackDropArguments(
                                    config: item.toJson(),
                                    data: item.data,
                                  ),
                                );
                              }

                              if (config['type'] == 'menuWithProducts') {
                                return CategoryMenuWithProducts(
                                  config: configValue,
                                  listCategoryName: listCategoryName,
                                  onShowProductList: onShowProductList,
                                );
                              }

                              if (config['type'] == 'text') {
                                return CategoryTexts(
                                  config: configValue,
                                  listCategoryName: listCategoryName,
                                  onShowProductList: onShowProductList,
                                );
                              }

                              return CategoryIcons(
                                config: configValue,
                                listCategoryName: listCategoryName,
                                onShowProductList: onShowProductList,
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ],
              );
            });
          }),
        );
      case Layout.bannerAnimated:
        if (kIsWeb) return const SizedBox();
        return BannerAnimated(config: BannerConfig.fromJson(config));

      case Layout.bannerImage:
        if (config['isSlider'] == true) {
          return BannerSlider(
            config: BannerConfig.fromJson(config),
            onTap: (itemConfig) {
              if (itemConfig is Map && itemConfig['category'] != null) {
                final categoryList =
                    Provider.of<CategoryModel>(context, listen: false)
                        .categoryList;
                final id = itemConfig['category'].toString();
                itemConfig['name'] =
                    categoryList[id] != null ? categoryList[id]!.name : '';
              }

              NavigateTools.onTapNavigateOptions(
                context: context,
                config: itemConfig,
              );
            },
          );
        }

        if (config['isHorizontal'] == true) {
          return BannerHorizontal(
            config: BannerConfig.fromJson(config),
            onTap: (itemConfig) {
              NavigateTools.onTapNavigateOptions(
                context: context,
                config: itemConfig,
              );
            },
          );
        }

        return BannerGroupItems(
          config: BannerConfig.fromJson(config),
          onTap: (itemConfig) {
            NavigateTools.onTapNavigateOptions(
              context: context,
              config: itemConfig,
            );
          },
        );

      case Layout.blog:
        return BlogGrid(config: BlogConfig.fromJson(config));

      case Layout.video:
        return VideoLayout(config: config);

      case Layout.story:
        return StoryWidget(
          config: config,
        );

      /// Product Layout styles
      case Layout.recentView:
        if (ServerConfig().isBuilder) {
          return ProductRecentPlaceholder();
        }
        return Services().widget.renderHorizontalListItem(config);
      case Layout.fourColumn:
      case Layout.threeColumn:
      case Layout.twoColumn:
      case Layout.staggered:
      case Layout.saleOff:
      case Layout.card:
      case Layout.listTile:
      case Layout.quiltedGridTile:
        return Services()
            .widget
            .renderHorizontalListItem(config, cleanCache: cleanCache);

      /// New product layout style.
      case Layout.largeCardHorizontalListItems:
      case Layout.largeCard:
        return Services().widget.renderLargeCardHorizontalListItems(config);
      case Layout.simpleVerticalListItems:
      case Layout.simpleList:
        return SimpleVerticalProductList(
          config: ProductConfig.fromJson(config),
        );

      case Layout.brand:
        return BrandLayout(
          config: BrandConfig.fromJson(config),
        );

      /// FluxNews
      case Layout.sliderList:
        return Services().widget.renderSliderList(config);
      case Layout.sliderItem:
        return Services().widget.renderSliderItem(config);

      case Layout.geoSearch:
        return Services().widget.renderGeoSearch(config);
      case Layout.divider:
        return DividerLayout(config: DividerConfig.fromJson(config));
      case Layout.spacer:
        return SpacerLayout(config: SpacerConfig.fromJson(config));
      case Layout.button:
        return ButtonLayout(config: ButtonConfig.fromJson(config));
      case Layout.testimonial:
        return TestimonialLayout(config: TestimonialConfig.fromJson(config));
      case Layout.sliderTestimonial:
        return SliderTestimonial(
          config: SliderTestimonialConfig.fromJson(config),
        );
      case Layout.instagramStory:
        return InstagramStory(
          config: InstagramStoryConfig.fromJson(config),
        );
      case Layout.tiktokVideos:
        if (ServerConfig().isBuilder || !isMobile) {
          return TikTokVideosPlaceholder();
        }
        return TikTokVideos(
          config: TikTokVideosConfig.fromJson(config),
        );
      default:
        return const SizedBox();
    }
  }
}
