// ignore_for_file: prefer_single_quotes, lines_longer_than_80_chars final
import 'common/constants/country_phone_codes.dart';

Map<String, dynamic> environment = {
  "appConfig": "https://raw.githubusercontent.com/campnsea/CampnseaApp/main/config_ar.json",
  "serverConfig": {
    'type': 'shopify',

    /// 🌍 The register URL domain that matches with Envato Purchase Code
    /// 🔑 Also, make sure to update the envatoPurchaseCode from configs/env.properties
    'url': 'https://campnsea.com',
    'accessToken': 'ed9373d237b10f301dc1be61b6de6176',

    /// Wordpress blog, it could be removed if using the same above url
    // 'blog': 'https://mstore.io',
  },

  /// ➡️ lib/common/config/general.dart
  "defaultDarkTheme": false,
  "enableRemoteConfigFirebase": false,
  "enableFirebaseAnalytics": true,
  "loginSMSConstants": {
    "countryCodeDefault": "KW",
    "dialCodeDefault": "+965",
    "phoneNumberFormat": '#### ####',
    "nameDefault": "Kuwait",
  },
  "phoneNumberConfig": {
    "enable": true,
    "enablePhoneNumberValidation": true,
    "countryCodeDefault": "KW",
    "dialCodeDefault": "+965",
    "phoneNumberFormat": '#### ####',
    "useInternationalFormat": true,
    "selectorFlagAsPrefixIcon": true,
    "showCountryFlag": true,
    "customCountryList": countryPhoneCodes.map((e) => e['code']),
    "selectorType": "BOTTOM_SHEET", // [DROPDOWN, BOTTOM_SHEET, DIALOG]
  },
  "appRatingConfig": {
    'showOnOpen': false,
    'android': 'campnsea.android.app',
    'ios': '1633440879',
    'minDays': 7,
    'minLaunches': 10,
    'remindDays': 7,
    'remindLaunches': 10,
  },
  "advanceConfig": {
    "DefaultLanguage": "en",
    "DetailedBlogLayout": "halfSizeImageType",
    "EnablePointReward": false,
    "hideOutOfStock": false,
    "HideEmptyTags": true,
    "HideEmptyCategories": true,
    "EnableRating": true,
    "hideEmptyProductListRating": true,

    "EnableCart": true,

    /// Enable search by SKU in search screen
    "EnableSkuSearch": true,

    /// Show stock Status on product List & Product Detail
    "showStockStatus": false,

    /// Gird count setting on Category screen
    "GridCount": 3,

    /// set isCaching to true if you have upload the config file to mstore-api
    /// set kIsResizeImage to true if you have finished running Re-generate image plugin
    /// ref: https://support.inspireui.com/help-center/articles/3/8/19/app-performance
    "isCaching": false,
    "kIsResizeImage": false,
    "httpCache": true,

    /// Stripe payment only: set currencyCode and smallestUnitRate.
    /// All API requests expect amounts to be provided in a currency’s smallest unit.
    /// For example, to charge 10 USD, provide an amount value of 1000 (i.e., 1000 cents).
    /// Reference: https://stripe.com/docs/currencies#zero-decimal
    "DefaultCurrency": {
      "symbol": "KD",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": "KWD",
      "currencyCode": "KW",
      "smallestUnitRate": 1,
      "countryCode": "KW",
      "rate": 1,

      /// 100 cents = 1 usd
    },
    "Currencies": [
      {
        "symbol": "KD",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "KWD",
        "currencyCode": "KW",
        "rate": 1,
        "smallestUnitRate": 1,
        "countryCode": "KW",
      },
      {
        "symbol": "AE",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "AED",
        "currencyCode": "AE",
        "rate": 12,
        "smallestUnitRate": 1,
        "countryCode": "AE",
      },
      {
        "symbol": "OM",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "OMR",
        "currencyCode": "OM",
        "rate": 1.3,
        "smallestUnitRate": 1,
        "countryCode": "OM",
      },
      {
        "symbol": "QA",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "QAR",
        "currencyCode": "QA",
        "rate": 12,
        "smallestUnitRate": 1,
        "countryCode": "QA",
      },
      {
        "symbol": "SAR",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "SAR",
        "currencyCode": "SA",
        "rate": 12.5,
        "smallestUnitRate": 1,
        "countryCode": "SA",
      },
      {
        "symbol": "USD",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "USD",
        "currencyCode": "US",
        "rate": 3.3,
        "smallestUnitRate": 1,
        "countryCode": "US",
      },
    ],

    /// Below config is used for Magento store
    "DefaultStoreViewCode": "",
    "EnableAttributesConfigurableProduct": ["color", "size"],
    "EnableAttributesLabelConfigurableProduct": ["color", "size"],

    /// if the woo commerce website supports multi languages
    /// set false if the website only have one language
    "isMultiLanguages": true,

    ///Review gets approved automatically on woocommerce admin without requiring administrator to approve.
    "EnableApprovedReview": false,

    /// Sync Cart from website and mobile
    "EnableSyncCartFromWebsite": false,
    "EnableSyncCartToWebsite": false,

    /// Enable firebase to support FCM, realtime chat for Fluxstore MV
    "EnableFirebase": true,

    /// ratio Product Image, default value is 1.2 = height / width
    "RatioProductImage": 1.2,

    /// Enable Coupon Code When checkout
    "EnableCouponCode": true,

    /// Enable to Show Coupon list.
    "ShowCouponList": false,

    /// Enable this will show all coupons in Coupon list.
    /// Disable will show only coupons which is restricted to the current user"s email.
    "ShowAllCoupons": false,

    /// Show expired coupons in Coupon list.
    "ShowExpiredCoupons": false,
    "AlwaysShowTabBar": false,

    /// Privacy Policies page ID. Accessible in the app via Settings > Privacy menu.
    "PrivacyPoliciesPageId": null,

    /// If page id null
    /// Privacy Policies page Url. Accessible in the app via Settings > Privacy menu.
    "PrivacyPoliciesPageUrl": "https://campnsea.com/pages/shipping-returns",

    "SupportPageUrl": "https://campnsea.com/pages/about-us",

    "DownloadPageUrl": 'https://campnsea.com/pages/about-us',

    "SocialConnectUrl": [
      {
        "name": "Facebook",
        "icon": "assets/icons/logins/facebook.png",
        "url": "https://www.facebook.com/campnsea/"
      },
      {
        "name": "Instagram",
        "icon": "assets/icons/logins/instagram.png",
        "url": "https://www.instagram.com/campnsea.kw/"
      },
    ],

    "AutoDetectLanguage": false,
    "QueryRadiusDistance": 10,
    "MinQueryRadiusDistance": 1,

    /// Distance by km
    "MaxQueryRadiusDistance": 10,

    /// Enable Membership Pro Ultimate WP
    "EnableMembershipUltimate": false,

    /// Enable Paid Membership Pro
    "EnablePaidMembershipPro": false,

    /// Enable Delivery Date when doing checkout
    "EnableDeliveryDateOnCheckout": true,

    /// Enable new SMS Login
    "EnableNewSMSLogin": false,

    /// Enable bottom add to cart from product card view
    "EnableBottomAddToCart": false,

    /// Disable inAppWebView to use webview_flutter
    /// so webview can navigate to external app.
    /// Useful for webview checkout which need to handle payment in another app.
    "inAppWebView": false,
    'AlwaysClearWebViewCache': false,
    "WebViewScript": "",

    'AlwaysRefreshBlog': false,

    ///support multi currency via WOOCS – Currency Switcher for WooCommerce plugin (https://wordpress.org/plugins/woocommerce-currency-switcher/)
    "EnableWOOCSCurrencySwitcher": true,

    /// Enable product backdrop layout - https://tppr.me/L5Pnf
    "enableProductBackdrop": false,

    /// false: show category menu as Text https://tppr.me/v3bLI
    /// true: show as Category Image
    "categoryImageMenu": true,

    ///Support Digits : WordPress Mobile Number Signup and Login plugin (https://codecanyon.net/item/digits-wordpress-mobile-number-signup-and-login/19801105)
    "EnableDigitsMobileLogin": false,
    "EnableDigitsMobileFirebase": false,
    "EnableDigitsMobileWhatsApp": false,

    /// Enable Ajax Search Pro, https://your-domain/wp-json/ajax-search-pro/v0/woo_search?s=
    "AjaxSearchURL": "",

    "gdpr": {
      "showPrivacyPolicyFirstTime": false,
      "showDeleteAccount": true,
      "confirmCaptcha": "PERMANENTLY DELETE",
    },

    /// show order notes in order detail with private notes
    "OrderNotesWithPrivateNote": true,

    "OrderNotesLinkSupport": false,

    /// Just accept select the country on this list
    /// example: {"vn", "ae"}
    "supportCountriesShipping": null,

    // Enable the request Notify permission from onboarding
    "showRequestNotification": true,

    "EnableVersionCheck": true,
    "inAppUpdateForAndroid": {
      "enable": true,
      "typeUpdate": "immediate", // "flexible, immediate"
    },
    "categoryConfig": {
      // Enable this option when the store has more than 100 category items
      "enableLargeCategories": false,
      "deepLevel": 3,
    },

    /// Example: "pinnedProductTags": ["feature", "new"],
    /// will show the tag before product title in the product list.
    "pinnedProductTags": [],

    /// Enable WooCommerce Wholesale Prices
    "EnableWooCommerceWholesalePrices": false,
  },
  "defaultDrawer": {
    "logo": "assets/images/logo.png",
    "background": null,
    "items": [
      {"type": "home", "show": true},
      {"type": "blog", "show": false},
      {"type": "categories", "show": true},
      {"type": "cart", "show": true},
      {"type": "profile", "show": true},
      {"type": "login", "show": true},
      {"type": "category", "show": true}
    ]
  },
  "defaultSettings": [
    "products",
    "wishlist",
    "notifications",
    "language",
    "currencies",
    "darkTheme",
    "order",
    "rating",
    // "biometrics",
    // "products",
    // "chat",
    // "wishlist",
    // "notifications",
    // "language",
    // "currencies",
    // "darkTheme",
    // "order",
    // "point",
    // "rating",
    // "privacy",
    // "about",
  ],
  "loginSetting": {
    "IsRequiredLogin": false,
    "showAppleLogin": false,
    "showFacebook": false,
    "showSMSLogin": false,
    "showGoogleLogin": false,
    "showPhoneNumberWhenRegister": false,
    "requirePhoneNumberWhenRegister": false,
    "isResetPasswordSupported": true,
    "smsLoginAsDefault": false,

    /// For Facebook login.
    /// These configs are only used for FluxBuilder's Auto build feature.
    /// To update manually, follow this below doc:
    /// https://support.inspireui.com/help-center/articles/42/44/32/social-login#login
    "facebookAppId": "430258564493822",
    "facebookLoginProtocolScheme": "fb430258564493822",
  },
  "oneSignalKey": {
    "enable": true,
    "appID": "af2705c3-1a0a-4437-9f66-7f0e66450dc5"
  },

  /// ➡️ lib/common/onboarding.dart
  "onBoardingConfig": {
    'enableOnBoarding': false,
    'version': 1,
    'autoCropImageByDesign': true,
    'isOnlyShowOnFirstTime': true,
    "showLanguage": true,
    'data': [
      {
        'title': 'Welcome to Campnsea',
        'image': 'assets/images/fogg-delivery-1.png',
        'desc': 'Fluxstore is on the way to serve you. '
      },
      {
        'title': 'Connect Surrounding World',
        'image': 'assets/images/fogg-uploading-1.png',
        'desc':
            'See all things happening around you just by a click in your phone. Fast, convenient and clean.'
      },
      {
        'title': "Let's Get Started",
        'image': 'assets/images/fogg-order-completed.png',
        'desc': "Waiting no more, let's see what we get!"
      }
    ],
  },

  "vendorOnBoardingData": [
    {
      'title': 'Welcome aboard',
      'image': 'assets/images/searching.png',
      'desc': 'Just a few more steps to become our vendor'
    },
    {
      'title': 'Let\'s Get Started',
      'image': 'assets/images/manage.png',
      'desc': 'Good Luck for great beginnings.'
    }
  ],

  /// ➡️ lib/common/advertise.dart
  "adConfig": {
    "enable": false,
    "facebookTestingId": "",
    "googleTestingId": [],
    "ads": [
      {
        "type": "banner",
        "provider": "google",
        "iosId": "ca-app-pub-3940256099942544/2934735716",
        "androidId": "ca-app-pub-3940256099942544/6300978111",
        "showOnScreens": ["home", "search"],
        "waitingTimeToDisplay": 2,
      },
      {
        "type": "banner",
        "provider": "google",
        "iosId": "ca-app-pub-2101182411274198/5418791562",
        "androidId": "ca-app-pub-2101182411274198/4052745095",

        /// "showOnScreens": ["home", "category", "product-detail"],
      },
      {
        "type": "interstitial",
        "provider": "google",
        "iosId": "ca-app-pub-3940256099942544/4411468910",
        "androidId": "ca-app-pub-3940256099942544/4411468910",
        "showOnScreens": ["profile"],
        "waitingTimeToDisplay": 5,
      },
      {
        "type": "reward",
        "provider": "google",
        "iosId": "ca-app-pub-3940256099942544/1712485313",
        "androidId": "ca-app-pub-3940256099942544/4411468910",
        "showOnScreens": ["cart"],

        /// "waitingTimeToDisplay": 8,
      },
      {
        "type": "banner",
        "provider": "facebook",
        "iosId": "IMG_16_9_APP_INSTALL#430258564493822_876131259906548",
        "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489007588618919",
        "showOnScreens": ["home"],

        /// "waitingTimeToDisplay": 8,
      },
      {
        "type": "interstitial",
        "provider": "facebook",
        "iosId": "430258564493822_489092398610438",
        "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489092398610438",

        /// "showOnScreens": ["profile"],
        /// "waitingTimeToDisplay": 8,
      },
    ],

    /// "adMobAppId" is only used for FluxBuilder's Auto build feature.
    /// To update manually, follow this below doc:
    /// https://support.inspireui.com/help-center/articles/42/44/17/admob-and-facebook-ads#2-setup-google-admob-for-flutter
    "adMobAppIdIos": "ca-app-pub-7432665165146018~2664444130",
    "adMobAppIdAndroid": "ca-app-pub-7432665165146018~2664444130",
  },

  /// ➡️ lib/common/dynamic_link.dart
  "firebaseDynamicLinkConfig": {
    "isEnabled": true,
    "shortDynamicLinkEnable": false,

    /// Domain is the domain name for your product.
    /// Let’s assume here that your product domain is “example.com”.
    /// Then you have to mention the domain name as : https://example.page.link.
    "uriPrefix": "https://campnsea.com/",
    //The link your app will open
    "link": "https://campnsea.com/",
    //----------* Android Setting *----------//
    "androidPackageName": "campnsea.android.app",
    "androidAppMinimumVersion": 1,
    //----------* iOS Setting *----------//
    "iOSBundleId": "ios.app.campnsea",
    "iOSAppMinimumVersion": "1.0.1",
    "iOSAppStoreId": "1450508421"
  },

  /// ➡️ lib/common/languages.dart
  "languagesInfo": [
    {
      "name": "Arabic",
      "icon": "assets/images/country/ar.png",
      "code": "ar",
      "text": "العربية",
      "storeViewCode": "ar"
    },
    // 1 English - en.arb
    {
      "name": "English",
      "icon": "assets/images/country/gb.png",
      "code": "en",
      "text": "English",
      "storeViewCode": ""
    },

    // 1 English - intl_en.arb
    /* {
      "name": "English",
      "icon": "assets/images/country/gb.png",
      "code": "en",
      "text": "English",
      "storeViewCode": ""
    },
    // 2 Hindi - intl_hi.arb
    {
      "name": "Hindi",
      "icon": "assets/images/country/in.png",
      "code": "hi",
      "text": "हिन्दी",
      "storeViewCode": "hi"
    },
    // 3 Spanish - intl_es.arb
    {
      "name": "Spanish",
      "icon": "assets/images/country/es.png",
      "code": "es",
      "text": "Español",
      "storeViewCode": ""
    },
    // 4 French - intl_fr.arb
    {
      "name": "French",
      "icon": "assets/images/country/fr.png",
      "code": "fr",
      "text": "Français",
      "storeViewCode": "fr"
    },
    // 5 Arabic - intl_ar.arb
    {
      "name": "Arabic",
      "icon": "assets/images/country/ar.png",
      "code": "ar",
      "text": "العربية",
      "storeViewCode": "ar"
    },
    // 6 Russian - intl_ru.arb
    {
      "name": "Russian",
      "icon": "assets/images/country/ru.png",
      "code": "ru",
      "text": "Русский",
      "storeViewCode": "ru"
    },
    // 7 Indonesian - intl_id.arb
    {
      "name": "Indonesian",
      "icon": "assets/images/country/id.png",
      "code": "id",
      "text": "Bahasa Indonesia",
      "storeViewCode": "id"
    },
    // 8 Japanese - intl_ja.arb
    {
      "name": "Japanese",
      "icon": "assets/images/country/ja.png",
      "code": "ja",
      "text": "日本語",
      "storeViewCode": ""
    },
    // 9 Korean - intl_ko.arb
    {
      "name": "Korean",
      "icon": "assets/images/country/ko.png",
      "code": "ko",
      "text": "한국어/조선말",
      "storeViewCode": "ko"
    },
    // 10 Vietnamese - intl_vi.arb
    {
      "name": "Vietnamese",
      "icon": "assets/images/country/vn.png",
      "code": "vi",
      "text": "Tiếng Việt",
      "storeViewCode": ""
    },
    // 11 Romanian - intl_ro.arb
    {
      "name": "Romanian",
      "icon": "assets/images/country/ro.png",
      "code": "ro",
      "text": "Românește",
      "storeViewCode": "ro"
    },
    // 12 Turkish - intl_tr.arb
    {
      "name": "Turkish",
      "icon": "assets/images/country/tr.png",
      "code": "tr",
      "text": "Türkçe",
      "storeViewCode": "tr"
    },
    // 13 Italian - intl_it.arb
    {
      "name": "Italian",
      "icon": "assets/images/country/it.png",
      "code": "it",
      "text": "Italiano",
      "storeViewCode": "it"
    },
    // 14 German - intl_de.arb
    {
      "name": "German",
      "icon": "assets/images/country/de.png",
      "code": "de",
      "text": "Deutsch",
      "storeViewCode": "de"
    },
    // 15 Brazilian Portuguese - intl_pt_BR.arb
    {
      "name": "Brazilian Portuguese",
      "icon": "assets/images/country/br.png",
      "code": "pt_BR",
      "text": "Português do Brasil",
      "storeViewCode": ""
    },
    // 16 Portuguese from Portugal - intl_pt_PT.arb
    {
      "name": "Portuguese from Portugal",
      "icon": "assets/images/country/pt.png",
      "code": "pt_PT",
      "text": "Português de Portugal",
      "storeViewCode": ""
    },
    // 17 Hungarian - intl_hu.arb
    {
      "name": "Hungarian",
      "icon": "assets/images/country/hu.png",
      "code": "hu",
      "text": "Magyar nyelv",
      "storeViewCode": "hu"
    },
    // 18 Hebrew - intl_he.arb
    {
      "name": "Hebrew",
      "icon": "assets/images/country/he.png",
      "code": "he",
      "text": "עִבְרִית",
      "storeViewCode": "he"
    },
    // 19 Thai - intl_th.arb
    {
      "name": "Thai",
      "icon": "assets/images/country/th.png",
      "code": "th",
      "text": "ภาษาไทย",
      "storeViewCode": "th"
    },
    // 20 Dutch - intl_nl.arb
    {
      "name": "Dutch",
      "icon": "assets/images/country/nl.png",
      "code": "nl",
      "text": "Nederlands",
      "storeViewCode": "nl"
    },
    // 21 Serbian - intl_sr.arb
    {
      "name": "Serbian",
      "icon": "assets/images/country/sr.jpeg",
      "code": "sr",
      "text": "српски",
      "storeViewCode": "sr"
    },
    // 22 Polish - intl_pl.arb
    {
      "name": "Polish",
      "icon": "assets/images/country/pl.png",
      "code": "pl",
      "text": "Język polski",
      "storeViewCode": "pl"
    },
    // 23 Persian - intl_fa.arb
    {
      "name": "Persian",
      "icon": "assets/images/country/fa.png",
      "code": "fa",
      "text": "زبان فارسی",
      "storeViewCode": ""
    },
    // 24 Ukrainian - intl_uk.arb
    {
      "name": "Ukrainian",
      "icon": "assets/images/country/uk.png",
      "code": "uk",
      "text": "Українська мова",
      "storeViewCode": ""
    },
    // 25 Bengali - intl_bn.arb
    {
      "name": "Bengali",
      "icon": "assets/images/country/bn.png",
      "code": "bn",
      "text": "বাংলা",
      "storeViewCode": ""
    },
    // 26 Tamil - intl_ta.arb
    {
      "name": "Tamil",
      "icon": "assets/images/country/ta.png",
      "code": "ta",
      "text": "தமிழ்",
      "storeViewCode": ""
    },
    // 27 Kurdish - intl_ku.arb
    {
      "name": "Kurdish",
      "icon": "assets/images/country/ku.png",
      "code": "ku",
      "text": "Kurdî / کوردی",
      "storeViewCode": ""
    },
    // 28 Czech - intl_cs.arb
    {
      "name": "Czech",
      "icon": "assets/images/country/cs.png",
      "code": "cs",
      "text": "Čeština",
      "storeViewCode": "cs"
    },
    // 29 Swedish - intl_sv.arb
    {
      "name": "Swedish",
      "icon": "assets/images/country/sv.png",
      "code": "sv",
      "text": "Svenska",
      "storeViewCode": ""
    },
    // 30 Finland - intl_fi.arb
    {
      "name": "Finland",
      "icon": "assets/images/country/fi.png",
      "code": "fi",
      "text": "Suomi",
      "storeViewCode": ""
    },
    // 31 Greek - intl_el.arb
    {
      "name": "Greek",
      "icon": "assets/images/country/el.png",
      "code": "el",
      "text": "Ελληνικά",
      "storeViewCode": ""
    },
    // 32 Khmer - intl_km.arb
    {
      "name": "Khmer",
      "icon": "assets/images/country/km.png",
      "code": "km",
      "text": "ភាសាខ្មែរ",
      "storeViewCode": ""
    },
    // 33 Kannada - intl_kn.arb
    {
      "name": "Kannada",
      "icon": "assets/images/country/kn.png",
      "code": "kn",
      "text": "ಕನ್ನಡ",
      "storeViewCode": ""
    },
    // 34 Marathi - intl_mr.arb
    {
      "name": "Marathi",
      "icon": "assets/images/country/mr.jpeg",
      "code": "mr",
      "text": "मराठी भाषा",
      "storeViewCode": ""
    },
    // 35 Malay - intl_ms.arb
    {
      "name": "Malay",
      "icon": "assets/images/country/ms.jpeg",
      "code": "ms",
      "text": "بهاس ملايو",
      "storeViewCode": ""
    },
    // 36 Bosnian - intl_bs.arb
    {
      "name": "Bosnian",
      "icon": "assets/images/country/bs.png",
      "code": "bs",
      "text": "босански",
      "storeViewCode": ""
    },
    // 37 Lao - intl_lo.arb
    {
      "name": "Lao",
      "icon": "assets/images/country/lo.png",
      "code": "lo",
      "text": "ພາສາລາວ",
      "storeViewCode": ""
    },
    // 38 Slovak - intl_sk.arb
    {
      "name": "Slovak",
      "icon": "assets/images/country/sk.png",
      "code": "sk",
      "text": "Slovaščina",
      "storeViewCode": ""
    },
    // 39 Swahili - intl_sw.arb
    {
      "name": "Swahili",
      "icon": "assets/images/country/sw.png",
      "code": "sw",
      "text": "كِيْسَوَاحِيْلِيْ",
      "storeViewCode": ""
    },
    // 40 Chinese - intl_zh.arb
    {
      "name": "Chinese",
      "icon": "assets/images/country/zh.png",
      "code": "zh",
      "text": "中文",
      "storeViewCode": ""
    },
    // 41 Chinese Traditional - intl_zh_TW.arb
    {
      "name": "Chinese (traditional)",
      "icon": "assets/images/country/zh.png",
      "code": "zh_TW",
      "text": "漢語",
      "storeViewCode": ""
    },
    // 42 Chinese Simplified - intl_zh_CN.arb
    {
      "name": "Chinese (simplified)",
      "icon": "assets/images/country/zh.png",
      "code": "zh_CN",
      "text": "汉语",
      "storeViewCode": ""
    },
    // 43 Burmese - intl_my.arb
    {
      "name": "Burmese",
      "icon": "assets/images/country/my.png",
      "code": "my",
      "text": "မြန်မာဘာသာစကား",
      "storeViewCode": ""
    },
    // 44 Albanian - intl_sq.arb
    {
      "name": "Albanian",
      "icon": "assets/images/country/sq.png",
      "code": "sq",
      "text": "Shqip",
      "storeViewCode": ""
    },
    // 45 Danish - intl_da.arb
    {
      "name": "Danish",
      "icon": "assets/images/country/da.svg",
      "code": "da",
      "text": "Dansk",
      "storeViewCode": ""
    },
    // 46 Tigrinya - intl_ti.arb
    {
      "name": "Tigrinya",
      "icon": "assets/images/country/er.png",
      "code": "ti",
      "text": "ትግርኛ",
      "storeViewCode": "ti"
    },
    // 47 Urdu - intl_ur.arb
    {
      "name": "Urdu",
      "icon": "assets/images/country/pk.png",
      "code": "ur",
      "text": "اُردُو",
      "storeViewCode": ""
    },
    // 48 Azerbaijani- intl_az.arb
    {
      "name": "Azerbaijani",
      "icon": "assets/images/country/az.jpg",
      "code": "az",
      "text": "Azərbaycan dili",
      "storeViewCode": ""
    },
    // 49 Kazakhstan - intl_kk.arb
    {
      "name": "Kazakhstan",
      "icon": "assets/images/country/kz.png",
      "code": "kk",
      "text": "Қазақ тілі",
      "storeViewCode": ""
    },
    // 50 Uzbek - intl_uz.arb
    {
      "name": "Uzbek",
      "icon": "assets/images/country/uz.png",
      "code": "uz",
      "text": "O'zbek",
      "storeViewCode": ""
    } */
  ],

  /// ➡️  lib/common/config/payments.dart
  "paymentConfig": {
    "DefaultCountryISOCode": "KW",

    "DefaultStateISOCode": "",

    /// Enable the Shipping option from Checkout, support for the Digital Download
    /// hokshedit
    "EnableShipping": false,

    /// Enable the address shipping.
    /// Set false if use for the app like Download Digial Asset which is not required the shipping feature.
    "EnableAddress": false,

    /// Allow customers to add note when order
    "EnableCustomerNote": true,

    /// Allow customers to add address location link to order note
    "EnableAddressLocationNote": false,

    /// Allow both alphabetical and numerical characters in ZIP code
    "EnableAlphanumericZipCode": false,

    /// Enable the product review option
    "EnableReview": false,

    /// Enable the Google Maps picker from Billing Address.
    "allowSearchingAddress": false,

    "GuestCheckout": true,

    /// Enable Payment option
    "EnableOnePageCheckout": true,
    "NativeOnePageCheckout": false,

    "ShowWebviewCheckoutSuccessScreen": true,

    /// This config is same with checkout page slug in the website
    "CheckoutPageSlug": {"en": "checkout"},

    /// Enable Credit card payment (only available for Fluxstore Shopify)
    "EnableCreditCard": false,

    /// Enable update order status to processing after checkout by COD on woo commerce
    "UpdateOrderStatus": true,

    /// Show order notes in order history detail.
    "ShowOrderNotes": true,

    /// Show Refund and Cancel button on Order Detail
    "EnableRefundCancel": true,

    /// If the order completed date is after this period (days), the refund button will be hidden.
    "RefundPeriod": 7,

    /// Apply the extra fee for the COD method
    /// amountStop: Amount to stop charge the extra fee
    "SmartCOD": {"enabled": true, "extraFee": 10, "amountStop": 200},

    /// List ids to hide some unnecessary payment methods
    "excludedPaymentIds": [],
  },
  "payments": {
    "stripe_v2_apple_pay": "assets/icons/payment/apple-pay-mark.svg",
    "stripe_v2_google_pay": "assets/icons/payment/google-pay-mark.png",
    "paypal": "assets/icons/payment/paypal.svg",
    "stripe": "assets/icons/payment/stripe.svg",
    "razorpay": "assets/icons/payment/razorpay.svg",
    "tap": "assets/icons/payment/tap.png"
  },
  "shopifyPaymentConfig": {
    "shopName": "FluxStore",
    "countryCode": "US",
    "productionMode": false,
    "paymentCardConfig": {
      "enable": true,
      "serverEndpoint": "https://test-stripe-nine.vercel.app",
    },
    "applePayConfig": {
      "enable": true,
      "merchantId": "merchant.com.inspireui.fluxstore",
    },
    "googlePayConfig": {
      "enable": true,
      "stripePublishableKey": "pk_test_O3awus9i5mA2wIX9a7pU3MSi00gZPcpJWX",
      "merchantId": "merchant.com.inspireui.fluxstore"
    },
  },
  "stripeConfig": {
    "serverEndpoint": "https://stripe-server-node.vercel.app",
    "publishableKey": "pk_test_syl720IY4iwLkNzmOeL7nz3J",
    "paymentMethodIds": ["stripe"],
    "enabled": true,
    "enableApplePay": true,
    "enableGooglePay": true,
    "merchantDisplayName": "FluxStore",
    "merchantIdentifier": "merchant.com.inspireui.mstore.flutter",
    "merchantCountryCode": "US",
    "useV1": false,
    "returnUrl": "fluxstore://inspireui.com",

    /// Enable this automatically captures funds when the customer authorizes the payment.
    /// Disable will Place a hold on the funds when the customer authorizes the payment,
    /// but don’t capture the funds until later. (Not all payment methods support this.)
    /// https://stripe.com/docs/payments/capture-later
    /// Default: false
    "enableManualCapture": false
  },
  "paypalConfig": {
    "clientId":
        "ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w",
    "secret":
        "ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G",
    "production": false,
    "paymentMethodId": "paypal",
    "enabled": true,
    "nativeMode": false,
  },
  "razorpayConfig": {
    "keyId": "rzp_test_SDo2WKBNQXDk5Y",
    "keySecret": "RrgfT3oxbJdaeHSzvuzaJRZf",
    "paymentMethodId": "razorpay",
    "enabled": true
  },
  "tapConfig": {
    "SecretKey": "sk_test_XKokBfNWv6FIYuTMg5sLPjhJ",
    "paymentMethodId": "tap",
    "enabled": true
  },
  "mercadoPagoConfig": {
    "accessToken":
        "TEST-5726912977510261-102413-65873095dc5b0a877969b7f6ffcceee4-613803978",
    "production": false,
    "paymentMethodId": "woo-mercado-pago-basic",
    "enabled": true
  },
  "payTmConfig": {
    "paymentMethodId": "paytm",
    "merchantId": "your-merchant-id",
    "production": false,
    "enabled": true
  },
  "payStackConfig": {
    'paymentMethodId': 'paystack',
    'publicKey': 'pk_test_a1a37615c9ca90dead5dd84dedbb5e476b640a6f',
    'secretKey': 'sk_test_d833fcaa6c02a61a9431d2026046c0517888a4a7',
    'supportedCurrencies': ['ZAR'],
    'enableMobileMoney': true,
    'production': false,
    'enabled': true
  },
  "flutterwaveConfig": {
    'paymentMethodId': 'rave',
    'publicKey': 'FLWPUBK_TEST-72b90e0734da8c9e43916adf63cd711e-X',
    'production': false,
    'enabled': true
  },
  "myFatoorahConfig": {
    "paymentMethodId": "myfatoorah_v2",
    "apiToken":
        "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
    'accountCountry': 'KW',
    // KW (KUWAIT), SA (SAUDI_ARABIA), BH (BAHRAIN), AR (UNITED_ARAB_EMIRATES), QA (QATAR), OM (OMAN), JO (JORDAN), EG (EGYPT)
    "production": false,
    "enabled": true
  },
  "midtransConfig": {
    'paymentMethodId': 'midtrans',
    'clientKey': 'SB-Mid-client-he8W_FIlvugfA2RD',
    'enabled': true
  },
  "inAppPurchaseConfig": {
    'consumableProductIDs': [
      'com.inspireui.fluxstore.test',
    ],
    'nonConsumableProductIDs': [],
    'subscriptionProductIDs': [
      'com.inspireui.fluxstore.subscription.test',
    ],
    "enabled": false
  },
  "xenditConfig": {
    'paymentMethodId': 'xendit',
    'secretApiKey':
        'xnd_development_4E9ql5zFiC1BBmhK2r7wr9mNYyyvjLs0fIal00tGuHEj1iEYCu7B7tCUudv3Xe',
    'enabled': true
  },
  "expressPayConfig": {
    'paymentMethodId': 'shahbandrpay',
    'merchantKey': 'b2be2ffc-c8b9-11ed-82a9-42eb4e39c8ae',
    'merchantPassword': '4a00a5fd3c63dd2b743c75746af6ffe2',
    "merchantId": "merchant.com.inspireui.mstore.flutter",
    "production": false,
    'enabled': true
  },
  "defaultCountryShipping": [],

  /// config for after shipping
  "afterShip": {
    "api": "e2e9bae8-ee39-46a9-a084-781d0139274f",
    "tracking_url": "https://fluxstore.aftership.com"
  },

  /// Ref: https://support.inspireui.com/help-center/articles/3/25/16/google-map-address
  "googleApiKey": {
    'android': 'AIzaSyCekjtdFdn2F0lnvYslE4RCFoiLzK5Y-m8',
    'ios': 'AIzaSyBcI8rKDEFSXyV7-cpAdqVoRRLGjmHzSO8',
    'web': 'AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg'
  },

  /// ➡️ lib/common/products.dart
  "productDetail": {
    "height": 0.6,
    "marginTop": 0,
    "safeArea": false,
    "showVideo": true,
    "showBrand": true,
    "showThumbnailAtLeast": 1,
    "layout": "simpleType",
    "borderRadius": 3.0,

    /// Enable this to show selected image variant in the top banner.
    "ShowSelectedImageVariant": true,

    "autoPlayGallery": true,
    "SliderShowGoBackButton": true,
    "ShowImageGallery": true,

    /// "SliderIndicatorType" can be "number", "dot". Default: "number".
    "SliderIndicatorType": 'number',

    /// Enable this to add a white background to top banner for transparent product image.
    "ForceWhiteBackground": false,

    /// Auto select first attribute of variable product if there is no default attribute.
    "AutoSelectFirstAttribute": true,

    /// Enable this to show review in product description.
    "enableReview": true,
    "attributeImagesSize": 50.0,
    "showSku": true,
    "showStockQuantity": true,
    "showProductCategories": false,
    "showProductTags": false,
    "hideInvalidAttributes": true,

    /// Enable this to show a quantity selector in product list.
    "showQuantityInList": false,

    /// Enable this to show Add to cart icon in search result list.
    "showAddToCartInSearchResult": true,

    /// Increase this number if you have yellow layout overflow error in product list.
    /// Should check "RatioProductImage" before changing this number.
    "productListItemHeight": 125,

    /// Limit the time a user can make an appointment. Units are in days.
    /// If the value is not set, there will be no limit on the appointment date.
    /// For example:
    ///  Today is October 11, 2020 and limitDayBooking is 7 days.
    /// --> So users can only book appointments from October 11, 2020 to October 18, 2020
    "limitDayBooking": 14,

    // Hide or show related products in product detail screen.
    "showRelatedProductFromSameStore": true,
    "showRelatedProduct": true,
    "showRecentProduct": true,

    // Product image layout
    "productImageLayout": "page",

    "expandDescription": true,
    "expandInfors": true,
    "expandCategories": true,
    "expandTags": true,
    "expandReviews": true,
    "expandTaxonomies": true,
    "expandListingMenu": true,
    "expandMap": true,

    "fixedBuyButtonToBottom": true
  },
  "blogDetail": {
    'showComment': false,
    'showHeart': false,
    'showSharing': false,
    'showTextAdjustment': false,
    'enableAudioSupport': false,
  },
  "productVariantLayout": {
    "color": "color",
    "size": "box",
    "height": "option",
    "color-image": "image"
  },
  "productAddons": {
    /// Set the allowed file type for file upload.
    /// On iOS will open Photos app.
    "allowImageType": true,
    "allowVideoType": true,

    /// Enable to allow upload files other than image/video.
    /// On iOS will open Files app.
    "allowCustomType": true,

    /// Set allowed file extensions for custom type.
    /// Leave empty ("allowedCustomType": []) to support all extensions.
    "allowedCustomType": ["png", "pdf", "docx"],

    /// NOTE: WordPress might restrict some file types for security purpose.
    /// To allow it, you can add this line to wp-config.php:
    /// define('ALLOW_UNFILTERED_UPLOADS', true);
    /// - which is NOT recommended.
    /// Instead, try to use a plugin like https://wordpress.org/plugins/wp-extra-file-types
    /// to allow custom file types.
    /// Allow selecting multiple files for upload. Default: false.
    "allowMultiple": false,

    /// Set the file size limit (in MB) for upload. Recommended: <15MB.
    "fileUploadSizeLimit": 5.0
  },
  "cartDetail": {
    "minAllowTotalCartValue": 1,
    "maxAllowQuantity": 10,

    /// Cart Style: normal, style01
    "style": "style01"
  },

  /// Translate the product variant by languages
  /// As it could be limited with the REST API when request variant
  "productVariantLanguage": {
    "en": {
      "color": "Color",
      "size": "Size",
      "height": "Height",
      "color-image": "Color"
    },
    "ar": {
      "color": "اللون",
      "size": "بحجم",
      "height": "ارتفاع",
      "color-image": "اللون"
    },
    "vi": {
      "color": "Màu",
      "size": "Kích thước",
      "height": "Chiều Cao",
      "color-image": "Màu"
    }
  },

  /// Exclude these categories from the list, for example "311,23,208"
  "excludedCategory": "311",
  "saleOffProduct": {
    /// Show Count Down for product type SaleOff
    "ShowCountDown": true,
    "HideEmptySaleOffLayout": false,
    "Color": "#C7222B"
  },

  /// This is strict mode option to check the `visible` option from product variant
  /// https://tppr.me/4DJJs - default value is false
  "notStrictVisibleVariant": true,

  /// ➡️ lib/common/smartchat.dart
  "configChat": {
    "EnableSmartChat": false,
    "UseRealtimeChat": false,
    "showOnScreens": ["profile"],
    "hideOnScreens": [],
    "version": "2",
  },
  "openAIConfig": {
    'enableChat': false,
    'supabaseUrl': 'https://rtkrqvtslujdzjxhjocu.supabase.co',
    'supabaseAnonKey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0a3JxdnRzbHVqZHpqeGhqb2N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU5OTI5MzMsImV4cCI6MTk5MTU2ODkzM30.qKtfNHhL6AKqGsmDfjMq90bIWIWlnN3UVgnwcLF_vGY',
    'revenueAppleApiKey': 'appl_XNtOUZPHwUzelbvwdSezFsMrNeT',
    'revenueGoogleApiKey': 'goog_kpDTQdItiHkSrdjDdvLIwAdjOzG',
    'revenueProductsIos': [
      'gpt_3999_1y_1w0',
      'gpt_399_1m_1w0',
    ],
    'revenueProductsAndroid': [
      'gpt_pro_v1',
    ],
    'enableSubscription': false,
    'enableInputKey': false,
  },

  /// config for the chat app
  /// config Whatapp: https://faq.whatsapp.com/en/iphone/23559013
  "smartChat": [
    {
      "app": "firebase",
      "imageData":
          "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a392cceb1b534aa92a83e/previews/611a392dceb1b534aa92a84d/download",
      "description": "Realtime Chat",
    },
    {
      "app": "chatGPT",
      "imageData": "https://i.imgur.com/pp1qlPd.png",
      "description": "Chat GPT"
    },
    {
      "app": "https://wa.me/849908854",
      "iconData": "whatsapp",
      "description": "WhatsApp"
    },
    {"app": "tel:8499999999", "iconData": "phone", "description": "Call Us"},
    {"app": "sms://8499999999", "iconData": "sms", "description": "Send SMS"},
    {
      "app": "https://tawk.to/chat/5d830419c22bdd393bb69888/default",
      "iconData": "whatsapp",
      "description": "Tawk Chat"
    },
    {
      "app": "http://m.me/inspireui",
      "iconData": "facebookMessenger",
      "description": "Facebook Chat"
    },
    {
      "app":
          "https://twitter.com/messages/compose?recipient_id=821597032011931648",
      "imageData":
          "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a38d026894f10dc1091c8/previews/611a38d126894f10dc1091d6/download",
      "description": "Twitter Chat"
    }
  ],
  "adminEmail": "info@Campnsea.com",
  "adminName": "Campnsea",

  /// ➡️ lib/common/vendor.dart
  "vendorConfig": {
    /// Show Register by Vendor
    "VendorRegister": false,

    /// Disable show shipping methods by vendor
    "DisableVendorShipping": false,

    /// Enable/Disable showing all vendor markers on Map screen
    "ShowAllVendorMarkers": true,

    /// Enable/Disable native store management
    "DisableNativeStoreManagement": true,

    /// Dokan Vendor Dashboard
    "dokan": "my-account?vendor_admin=true",
    "wcfm": "store-manager?vendor_admin=true",

    /// Disable multivendor checkout
    "DisableMultiVendorCheckout": true,

    /// If this is false, then when creating/modifying products in FluxStore Manager
    /// The publish status will be removed.
    "DisablePendingProduct": false,

    /// Default status when Add New Product from MV app.
    /// Support 'draft', 'pending', 'publish'.
    "NewProductStatus": "draft",

    /// Default Vendor image.
    "DefaultStoreImage": "assets/images/default-store-banner.png",

    /// Set this to true to automatically approve the vendor application.
    /// When it is set to false, these are the cases:
    /// - For WCFM - It will set the registered role to subscribe with the meta "wcfm_membership_application_status": "pending".
    /// - For Dokan - It still keeps the registered role as "seller" but the selling capability will be set to false. The meta for it is "dokan_enable_selling" : false
    "EnableAutoApplicationApproval": false,

    "BannerFit": "cover",
    "ExpandStoreLocationByDefault": true,

    /// Enable/Disable native delivery boy management
    "DisableDeliveryManagement": true,

    "hideChatInfoContact": true
  },

  /// Enable Delivery Boy Management in FluxStore Manager(WCFM)
  "deliveryConfig": {
    'appLogo': 'assets/images/app_icon_transparent.png',
    'appName': 'FluxStore Delivery',
    'dashboardName1': 'FluxStore',
    'dashboardName2': 'Delivery',
    'enableSystemNotes': false,
  },

  /// Enable Vendor Admin in FluxStore manager
  "managerConfig": {
    'appLogo': 'assets/images/app_icon_transparent.png',
    'appName': 'Campnsea Admin',
    'enableDeliveryFeature': false,
  },

  /// ➡️ lib/common/loading.dart
  "loadingIcon": {"size": 30.0, "type": "fadingCube"},
  "splashScreen": {
    "enable": true,

    /// duration in milliseconds, used for all types except "rive" and "flare"
    "duration": 5000,

    ///  Type should be: 'fade-in', 'zoom-in', 'zoom-out', 'top-down', 'rive', 'flare', ''static'
    "type": "static",
    "image": "assets/images/splash.gif",

    /// AnimationName's is used for 'rive' and 'flare' type
    "animationName": "Campnsea",

    "boxFit": "contain",
    "backgroundColor": "#ffffff",
    "paddingTop": 80,
    "paddingBottom": 80,
    "paddingLeft": 80,
    "paddingRight": 80,
  },
  "reviewConfig": {
    "service": "native",
    "enableReview": false,
    "enableReviewImage": false,
    "judgeConfig": {
      "domain": "https://campnsea.myshopify.com",
      "apiKey": "ebab9b75c5a987ecba21bf239c5f0450",
    }
  },
  "addressFields": [
    {
      'country': 'KW',
      'addressFields': [
        {
          'type': 'firstName',
          'visible': true,
          'position': 1,
          'editable': true,
          'required': true,
          'defaultValue': '',
        },
        {
          'type': 'lastName',
          'visible': true,
          'position': 2,
          'editable': true,
          'required': true,
          'defaultValue': '',
        },
        {
          'type': 'phoneNumber',
          'visible': true,
          'position': 3,
          'editable': true,
          'required': true,
          'defaultValue': '',
        },
        {
          'type': 'email',
          'visible': true,
          'position': 4,
          'editable': true,
          'required': true,
          'defaultValue': '',
        },
        {
          'type': 'searchAddress',
          'visible': true,
          'position': 5,
        },
        {
          'type': 'selectAddress',
          'visible': true,
          'position': 6,
        },
        {
          'type': 'country',
          'visible': true,
          'position': 7,
          'editable': false,
          'required': true,
          'defaultValue': '',
        },
        {
          'type': 'city',
          'visible': false,
          'position': 8,
          'editable': false,
          'required': true,
          'defaultValue': 'KW',
        },
        {
          'type': 'state',
          'visible': true,
          'position': 9,
        },

        {
          'type': 'province',
          'visible': true,
          'position': 10,
          'editable': true,
          'required': false,
          'defaultValue': '',
        },
        {
          'type': 'sector',
          'visible': true,
          'position': 10,
          'editable': true,
          'required': false,
          'defaultValue': '',
        },

        {
          'type': 'street',
          'visible': true,
          'position': 11,
          'editable': true,
          'required': false,
          'defaultValue': '',
        },
        {
          'type': 'block',
          'visible': true,
          'position': 12,
          'editable': true,
          'required': false,
          'defaultValue': '',
        },



        {
          'type': 'block2',
          'visible': true,
          'position': 13,
          'editable': true,
          'required': false,
          'defaultValue': '',
        },
        {
          'type': 'apartment',
          'visible': true,
          'position': 14,
          'editable': true,
          'required': false,
        }
        ,
        {
          'type': 'zipCode',
          'visible': false,
          'position': 15,
          'editable': false,
          'required': true,
          'defaultValue': '00000',
        },
      ]
    },

    // {
    //   'country': 'SA',
    //   'addressFields': [
    //     {
    //       'type': 'firstName',
    //       'visible': true,
    //       'position': 1,
    //       'editable': true,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'lastName',
    //       'visible': true,
    //       'position': 2,
    //       'editable': true,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'phoneNumber',
    //       'visible': true,
    //       'position': 3,
    //       'editable': true,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'email',
    //       'visible': true,
    //       'position': 4,
    //       'editable': true,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'searchAddress',
    //       'visible': true,
    //       'position': 5,
    //     },
    //     {
    //       'type': 'selectAddress',
    //       'visible': true,
    //       'position': 6,
    //     },
    //     {
    //       'type': 'country',
    //       'visible': true,
    //       'position': 7,
    //       'editable': false,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'city',
    //       'visible': true,
    //       'position': 8,
    //       'editable': true,
    //       'required': true,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'block2',
    //       'visible': true,
    //       'position': 10,
    //       'editable': true,
    //       'required': false,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'apartment',
    //       'visible': true,
    //       'position': 11,
    //       'editable': true,
    //       'required': false,
    //     },
    //     {
    //       'type': 'block',
    //       'visible': true,
    //       'position': 12,
    //       'editable': true,
    //       'required': false,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'street',
    //       'visible': true,
    //       'position': 13,
    //       'editable': true,
    //       'required': false,
    //       'defaultValue': '',
    //     },
    //     {
    //       'type': 'zipCode',
    //       'visible': false,
    //       'position': 14,
    //       'editable': false,
    //       'required': true,
    //       'defaultValue': '00000',
    //     },
    //   ],
    // },
  ],
};
