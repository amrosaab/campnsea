import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';

import '../../../common/config.dart';
import '../helper/helper.dart';
import 'box_shadow_config.dart';

/// category : '57'
/// name : 'Woman Collections'
/// layout : 'threeColumn'
/// isSnapping : true

enum CardDesign {
  card,
  glass,
  horizontal,
  simpleCard,
  quiltedCard,
  flat,
  ;

  bool get isGlass => this == CardDesign.glass;
  bool get isCard => this == CardDesign.card;
  bool get isHorizontal => this == CardDesign.horizontal;
  bool get isSimpleCard => this == CardDesign.simpleCard;
  bool get isFlat => this == CardDesign.flat;
  bool get isQuiltedCard => this == CardDesign.quiltedCard;

  factory CardDesign.fromString(String? cardDesign) {
    if (cardDesign == glass.name) {
      return CardDesign.glass;
    }

    if (cardDesign == horizontal.name) {
      return CardDesign.horizontal;
    }

    if (cardDesign == simpleCard.name) {
      return CardDesign.simpleCard;
    }

    if (cardDesign == flat.name) {
      return CardDesign.flat;
    }

    if (cardDesign == quiltedCard.name) {
      return CardDesign.quiltedCard;
    }

    return CardDesign.card;
  }
}

class ProductConfig {
  String? category;
  String? tag;
  String? image;
  String? name;
  String? layout;
  bool? isSnapping;
  double? height;
  double? imageWidth;
  double? borderRadius;
  double hMargin = 6.0;
  double vMargin = 0;
  double hPadding = 6.0;
  double vPadding = 2.0;
  dynamic jsonData;
  BoxShadowConfig? boxShadow;
  String? backgroundImage;
  num? spaceWidth;
  EdgeInsets? paddingBGP;
  EdgeInsets? marginBGP;
  num? backgroundHeight;
  num? backgroundWidth;
  bool? backgroundWidthMode;
  String? backgroundBoxFit;
  CardDesign cardDesign = CardDesign.card;
  int? titleLine;

  /// date, price,...
  String? orderby;

  /// asc, dsc
  String? order;

  int? limit;

  /// limit product
  List? include;

  /// load special products
  Map<String, dynamic>? advancedParams;

  Color? backgroundColor;
  double backgroundRadius = 10;

  bool showCountDown = false;
  bool onSale = false;
  int rows = 1;
  int columns = 3;
  double imageRatio = 1.2;
  String imageBoxfit = 'cover';
  bool hidePrice = false;
  bool hideStore = false;
  bool hideTitle = false;
  bool? featured;
  bool enableRating = true;
  bool showStockStatus = true;
  bool hideEmptyProductListRating = false;
  bool showHeart = false;
  bool showCartButton = false;
  bool showCartIcon = true;
  bool showCartIconColor = false;
  double cartIconRadius = 12;
  bool showQuantity = false;
  bool enableBottomAddToCart = kAdvanceConfig.enableBottomAddToCart;
  bool showOnlyImage = false;
  bool showCartButtonWithQuantity = false;
  bool enableParallax = false;
  double parallaxImageRatio = 1.2;
  bool hideEmptyProductLayout = false;
  double productListItemHeight = 125.0;
  bool enableAutoSliding = false;
  int? durationAutoSliding;
  bool showSeeAll = true;

  ProductConfig({
    this.category,
    this.image,
    this.name,
    required this.layout,
    this.isSnapping,
    this.onSale = false,
    this.featured,
    this.height,
    this.imageWidth,
    this.showCountDown = false,
    this.jsonData,
    this.boxShadow,
    this.borderRadius,
    this.vMargin = 0.0,
    this.hMargin = 6.0,
    this.vPadding = 2.0,
    this.hPadding = 6.0,
    this.showHeart = false,
    this.showCartButton = false,
    this.showCartIcon = true,
    this.cartIconRadius = 9,
    this.showCartIconColor = false,
    this.showQuantity = false,
    this.enableBottomAddToCart = false,
    this.showOnlyImage = false,
    this.backgroundImage,
    this.spaceWidth,
    this.paddingBGP,
    this.marginBGP,
    this.backgroundHeight,
    this.backgroundWidth,
    this.backgroundBoxFit,
    this.backgroundWidthMode,
    this.showCartButtonWithQuantity = false,
    this.enableParallax = false,
    this.parallaxImageRatio = 1.2,
    this.titleLine,
    this.order,
    this.orderby,
    this.limit,
    this.hideEmptyProductLayout = false,
    this.advancedParams,
    this.enableAutoSliding = false,
    this.durationAutoSliding,
    this.tag,
    this.cardDesign = CardDesign.card,
    this.include,
    this.backgroundColor,
    this.backgroundRadius = 10,
    this.showSeeAll = true,
    required this.rows,
    required this.columns,
    required this.imageRatio,
    required this.imageBoxfit,
    required this.hidePrice,
    required this.hideStore,
    required this.hideTitle,
    required this.enableRating,
    required this.showStockStatus,
    required this.hideEmptyProductListRating,
    required this.productListItemHeight,
  });

  ProductConfig.empty() {
    layout = Layout.threeColumn;

    rows = 1;
    columns = 3;
    titleLine = Helper.formatInt(kProductCard.titleLine);
    order = kProductCard.order;
    orderby = kProductCard.orderby;
    vMargin = Helper.formatDouble(kProductCard.vMargin) ?? 0.0;
    hMargin = Helper.formatDouble(kProductCard.hMargin) ?? 6.0;
    imageRatio = kAdvanceConfig.ratioProductImage * 1.0;
    imageBoxfit = Configurations.productCard['boxFit'] ??
        Configurations.productCard['fit'] ??
        'cover';
    hidePrice = kProductCard.hidePrice;
    hideTitle = kProductCard.hideTitle;
    hideStore = kProductCard.hideStore;
    showCartButton = kProductCard.showCartButton;
    showCartIcon = kProductCard.showCartIcon;
    showCartIconColor = kProductCard.showCartIconColor;
    enableBottomAddToCart = kAdvanceConfig.enableBottomAddToCart;
    showCartButtonWithQuantity = kProductCard.showCartButtonWithQuantity;
    showQuantity = kProductDetail.showQuantityInList;
    enableRating = kProductCard.enableRating;
    showCountDown = false;
    hideEmptyProductListRating = kProductCard.hideEmptyProductListRating;
    showStockStatus = kAdvanceConfig.showStockStatus;
    if (kProductCard.borderRadius != null) {
      borderRadius = Helper.formatDouble(kProductCard.borderRadius);
    }
    if (kProductCard.boxShadow != null) {
      boxShadow = BoxShadowConfig.fromJson(kProductCard.boxShadow);
    }
    cardDesign = CardDesign.fromString(kProductCard.cardDesign);
    productListItemHeight = kProductDetail.productListItemHeight;
  }

  ProductConfig.fromJson(dynamic json) {
    /// init default values
    var env = ProductConfig.empty();
    if (json['cardDesign'] != null) {
      cardDesign = CardDesign.fromString(json['cardDesign']);
    } else {
      cardDesign = env.cardDesign;
    }

    /// nullable
    category = json['category']?.toString();
    tag = json['tag']?.toString();
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    isSnapping = json['isSnapping'] ?? false;
    featured = json['featured'];
    onSale = json['onSale'] ?? false;
    showHeart = json['showHeart'] ?? false;
    showCartButton = json['showCartButton'] ?? env.showCartButton;
    showCartIcon = json['showCartIcon'] ?? env.showCartIcon;
    showCartIconColor = json['showCartIconColor'] ?? env.showCartIconColor;
    enableBottomAddToCart =
        json['enableBottomAddToCart'] ?? env.enableBottomAddToCart;
    backgroundImage = json['backgroundImage'];
    spaceWidth = json['spaceWidth'];
    backgroundHeight = json['backgroundHeight'];
    if (json['backgroundColor'] != null) {
      backgroundColor = HexColor(json['backgroundColor']);
    }
    backgroundWidth = json['backgroundWidth'];
    backgroundRadius = Helper.formatDouble(json['backgroundRadius']) ?? 10.0;

    backgroundBoxFit = json['backgroundBoxFit'];
    backgroundWidthMode = json['backgroundWidthMode'];
    if (json['paddingBGP'] != null) {
      paddingBGP = EdgeInsets.fromLTRB(
        Helper.formatDouble(json['paddingBGP']['left']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['top']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['right']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['bottom']) ?? 0.0,
      );
    }
    if (json['marginBGP'] != null) {
      marginBGP = EdgeInsets.fromLTRB(
        Helper.formatDouble(json['marginBGP']['left']) ?? 0.0,
        Helper.formatDouble(json['marginBGP']['top']) ?? 0.0,
        Helper.formatDouble(json['marginBGP']['right']) ?? 0.0,
        Helper.formatDouble(json['marginBGP']['bottom']) ?? 0.0,
      );
    }
    // ignore: prefer_initializing_formals
    jsonData = json;
    height = Helper.formatDouble(json['height']);
    cartIconRadius = Helper.formatDouble(json['cartIconRadius']) ?? 9;
    imageWidth = Helper.formatDouble(json['imageWidth']);
    vMargin = Helper.formatDouble(json['vMargin']) ?? env.vMargin;
    hMargin = Helper.formatDouble(json['hMargin']) ?? env.hMargin;
    vPadding = Helper.formatDouble(json['vPadding']) ?? 2.0;
    hPadding = Helper.formatDouble(json['hPadding']) ?? 6.0;
    titleLine = Helper.formatInt(json['titleLine']) ?? env.titleLine;
    order = json['order'] ?? env.order;
    orderby = json['orderby'] ?? env.orderby;

    borderRadius =
        Helper.formatDouble(json['borderRadius']) ?? env.borderRadius ?? 3;
    if (json['boxShadow'] != null) {
      boxShadow = BoxShadowConfig.fromJson(json['boxShadow']);
    }

    /// support new advance config not nullable
    layout = json['layout'] ?? env.layout;

    /// only show count down for Sale off product
    showCountDown = (json['showCountDown'] ?? env.showCountDown) &&
        (layout == Layout.saleOff || layout == Layout.pinterest);

    rows = Helper.formatInt(json['rows']) ?? env.rows;
    showQuantity = json['showQuantity'] ?? env.showQuantity;
    columns = Helper.formatInt(json['columns']) ?? env.columns;
    imageRatio = Helper.formatDouble(json['imageRatio']) ?? env.imageRatio;
    imageBoxfit = json['imageBoxfit'] ?? env.imageBoxfit;
    hidePrice = json['hidePrice'] ?? env.hidePrice;
    hideTitle = json['hideTitle'] ?? env.hideTitle;
    hideStore = json['hideStore'] ?? env.hideStore;
    showStockStatus = json['showStockStatus'] ?? env.showStockStatus;
    enableRating = json['enableRating'] ?? env.enableRating;
    hideEmptyProductListRating =
        json['hideEmptyProductListRating'] ?? env.hideEmptyProductListRating;
    showOnlyImage = json['showOnlyImage'] ?? false;
    showCartButtonWithQuantity = json['showCartButtonWithQuantity'] ?? false;
    limit = Helper.formatInt(json['limit']);
    include = json['include'];
    advancedParams = json['advancedParams'];

    enableParallax = json['parallax'] ?? false;
    parallaxImageRatio = Helper.formatDouble(json['parallaxImageRatio']) ?? 1.2;
    hideEmptyProductLayout = json['hideEmptyProductLayout'] ?? false;
    productListItemHeight =
        Helper.formatDouble(json['productListItemHeight']) ??
            env.productListItemHeight;

    enableAutoSliding = json['enableAutoSliding'] ?? env.enableAutoSliding;
    durationAutoSliding = Helper.formatInt(json['durationAutoSliding']) ??
        env.durationAutoSliding;
    showSeeAll = json['showSeeAll'] ?? env.showSeeAll;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (jsonData is Map) {
      map.addAll(Map<String, dynamic>.from(jsonData));
    }
    map['category'] = category;
    map['name'] = name;
    map['layout'] = layout;
    map['isSnapping'] = isSnapping;
    map['tag'] = tag;
    map['image'] = image;
    map['height'] = height;
    map['imageWidth'] = imageWidth;
    map['borderRadius'] = borderRadius;
    map['hMargin'] = hMargin;
    map['vMargin'] = vMargin;
    map['hPadding'] = hPadding;
    map['vPadding'] = vPadding;
    map['boxShadow'] = boxShadow?.toJson();
    map['backgroundImage'] = backgroundImage;
    map['spaceWidth'] = spaceWidth;
    if (paddingBGP != null) {
      map['paddingBGP'] = {
        'left': paddingBGP?.left,
        'right': paddingBGP?.right,
        'top': paddingBGP?.top,
        'bottom': paddingBGP?.bottom,
      };
    }
    if (marginBGP != null) {
      map['marginBGP'] = {
        'left': marginBGP?.left,
        'right': marginBGP?.right,
        'top': marginBGP?.top,
        'bottom': marginBGP?.bottom,
      };
    }
    map['backgroundHeight'] = backgroundHeight;
    map['backgroundWidth'] = backgroundWidth;
    map['backgroundBoxFit'] = backgroundBoxFit;
    map['backgroundWidthMode'] = backgroundWidthMode;
    map['cardDesign'] = cardDesign.toString().split('.').last;
    map['titleLine'] = titleLine;
    map['order'] = order;
    map['orderby'] = orderby;
    map['limit'] = limit;
    map['include'] = include;
    map['advancedParams'] = advancedParams;
    map['backgroundColor'] = backgroundColor?.value.toRadixString(16);
    map['backgroundRadius'] = backgroundRadius;
    map['showCountDown'] = showCountDown;
    map['onSale'] = onSale;
    map['rows'] = rows;
    map['columns'] = columns;
    map['imageRatio'] = imageRatio;
    map['imageBoxfit'] = imageBoxfit;
    map['hidePrice'] = hidePrice;
    map['hideStore'] = hideStore;
    map['hideTitle'] = hideTitle;
    map['featured'] = featured;
    map['enableRating'] = enableRating;
    map['showStockStatus'] = showStockStatus;
    map['hideEmptyProductListRating'] = hideEmptyProductListRating;
    map['showHeart'] = showHeart;
    map['showCartButton'] = showCartButton;
    map['showCartIcon'] = showCartIcon;
    map['showCartIconColor'] = showCartIconColor;
    map['cartIconRadius'] = cartIconRadius;
    map['showQuantity'] = showQuantity;
    map['enableBottomAddToCart'] = enableBottomAddToCart;
    map['showOnlyImage'] = showOnlyImage;
    map['showCartButtonWithQuantity'] = showCartButtonWithQuantity;
    map['parallax'] = enableParallax;
    map['parallaxImageRatio'] = parallaxImageRatio;
    map['hideEmptyProductLayout'] = hideEmptyProductLayout;
    map['productListItemHeight'] = productListItemHeight;
    map['enableAutoSliding'] = enableAutoSliding;
    map['durationAutoSliding'] = durationAutoSliding;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return '♻️ ProductConfig:: '
        'category:$category, '
        'image:$image, '
        'name:$name, '
        'layout:$layout, '
        'showCountDown:$showCountDown, '
        'onSale:$onSale, '
        'advancedParams:$advancedParams, ';
  }

  // write copyWith function
  ProductConfig copyWith({
    String? category,
    String? name,
    String? layout,
    bool? isSnapping,
    String? tag,
    String? image,
    double? height,
    double? imageWidth,
    double? borderRadius,
    double? hMargin,
    double? vMargin,
    double? hPadding,
    double? vPadding,
    BoxShadowConfig? boxShadow,
    String? backgroundImage,
    double? spaceWidth,
    EdgeInsets? paddingBGP,
    EdgeInsets? marginBGP,
    double? backgroundHeight,
    double? backgroundWidth,
    BoxFit? backgroundBoxFit,
    CardDesign? cardDesign,
    int? titleLine,
    String? order,
    String? orderby,
    int? limit,
    List? include,
    dynamic advancedParams,
    Color? backgroundColor,
    double? backgroundRadius,
    bool? showCountDown,
    bool? onSale,
    int? rows,
    int? columns,
    double? imageRatio,
    BoxFit? imageBoxfit,
    bool? hidePrice,
    bool? hideStore,
    bool? hideTitle,
    bool? featured,
    bool? enableRating,
    bool? showStockStatus,
    bool? hideEmptyProductListRating,
    bool? showHeart,
    bool? showCartButton,
    bool? showCartIcon,
    bool? showCartIconColor,
    double? cartIconRadius,
    bool? showQuantity,
    bool? enableBottomAddToCart,
    bool? showOnlyImage,
    bool? showCartButtonWithQuantity,
    bool? enableParallax,
    double? parallaxImageRatio,
    bool? hideEmptyProductLayout,
    double? productListItemHeight,
    bool? enableAutoSliding,
    int? durationAutoSliding,
    bool? backgroundWidthMode,
  }) {
    return ProductConfig(
      category: category ?? this.category,
      name: name ?? this.name,
      layout: layout ?? this.layout,
      isSnapping: isSnapping ?? this.isSnapping,
      tag: tag ?? this.tag,
      image: image ?? this.image,
      height: height ?? this.height,
      imageWidth: imageWidth ?? this.imageWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      hMargin: hMargin ?? this.hMargin,
      vMargin: vMargin ?? this.vMargin,
      hPadding: hPadding ?? this.hPadding,
      vPadding: vPadding ?? this.vPadding,
      boxShadow: boxShadow ?? this.boxShadow,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      spaceWidth: spaceWidth ?? this.spaceWidth,
      paddingBGP: paddingBGP ?? this.paddingBGP,
      marginBGP: marginBGP ?? this.marginBGP,
      backgroundHeight: backgroundHeight ?? this.backgroundHeight,
      backgroundWidth: backgroundWidth ?? this.backgroundWidth,
      backgroundBoxFit: backgroundBoxFit?.name ?? this.backgroundBoxFit,
      backgroundWidthMode: backgroundWidthMode ?? backgroundWidthMode,
      cardDesign: cardDesign ?? this.cardDesign,
      titleLine: titleLine ?? this.titleLine,
      order: order ?? this.order,
      orderby: orderby ?? this.orderby,
      limit: limit ?? this.limit,
      include: include?.toList() ?? this.include?.toList(),
      advancedParams: advancedParams ?? this.advancedParams,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundRadius: backgroundRadius ?? this.backgroundRadius,
      showCountDown: showCountDown ?? this.showCountDown,
      onSale: onSale ?? this.onSale,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      imageRatio: imageRatio ?? this.imageRatio,
      imageBoxfit: imageBoxfit?.name ?? this.imageBoxfit,
      hidePrice: hidePrice ?? this.hidePrice,
      hideStore: hideStore ?? this.hideStore,
      hideTitle: hideTitle ?? this.hideTitle,
      featured: featured ?? this.featured,
      enableRating: enableRating ?? this.enableRating,
      showStockStatus: showStockStatus ?? this.showStockStatus,
      hideEmptyProductListRating:
          hideEmptyProductListRating ?? this.hideEmptyProductListRating,
      showHeart: showHeart ?? this.showHeart,
      showCartButton: showCartButton ?? this.showCartButton,
      showCartIcon: showCartIcon ?? this.showCartIcon,
      showCartIconColor: showCartIconColor ?? this.showCartIconColor,
      cartIconRadius: cartIconRadius ?? this.cartIconRadius,
      showQuantity: showQuantity ?? this.showQuantity,
      enableBottomAddToCart:
          enableBottomAddToCart ?? this.enableBottomAddToCart,
      showOnlyImage: showOnlyImage ?? this.showOnlyImage,
      showCartButtonWithQuantity:
          showCartButtonWithQuantity ?? this.showCartButtonWithQuantity,
      enableParallax: enableParallax ?? this.enableParallax,
      parallaxImageRatio: parallaxImageRatio ?? this.parallaxImageRatio,
      hideEmptyProductLayout:
          hideEmptyProductLayout ?? this.hideEmptyProductLayout,
      productListItemHeight:
          productListItemHeight ?? this.productListItemHeight,
      enableAutoSliding: enableAutoSliding ?? this.enableAutoSliding,
      durationAutoSliding: durationAutoSliding ?? this.durationAutoSliding,
    );
  }
}
