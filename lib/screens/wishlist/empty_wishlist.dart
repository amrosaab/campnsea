import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Product;
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../../widgets/product/dialog_add_to_cart.dart';
import '../../widgets/product/widgets/pricing.dart';

class EmptyWishlist extends StatelessWidget {
  final VoidCallback onShowHome;
  final VoidCallback onSearchForItem;

  const EmptyWishlist({
    required this.onShowHome,
    required this.onSearchForItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 80),
          Image.asset(
            kEmptySearch,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).noFavoritesYet,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(S.of(context).emptyWishlistSubtitle,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: onShowHome,
                    child: Text(

                      S.of(context).startShopping.toUpperCase(),
                        style:               TextStyle(
                          fontFamily: GoogleFonts.cairo().fontFamily,
                        )
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // foregroundColor: kGrey400,
                      backgroundColor: Theme.of(context).brightness == Brightness.dark?kGrey400.withOpacity(.5):Colors.white,
                    ),
                    onPressed: onSearchForItem,
                    child: Text(S.of(context).searchForItems.toUpperCase(),style: Theme.of(context).textTheme.bodySmall?.copyWith(color:
                    Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.teal[900],)



                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class WishlistItem extends StatelessWidget {
  const WishlistItem({required this.product, this.onAddToCart, this.onRemove});

  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteList.productDetail,
                arguments: product,
              );
            },
            child: Row(
              key: ValueKey(product.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                              height: constraints.maxWidth * 0.3,
                              child: ImageResize(
                                  url: product.imageFeature,
                                  size: kSize.medium),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? '',
                                    style: localTheme.textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 7),
                                  ProductPricing(
                                    product: product,
                                    hide: false,
                                  ),
                                  const SizedBox(height: 10),
                                  if (Services()
                                          .widget
                                          .enableShoppingCart(product) &&
                                      !ServerConfig().isListingType)
                                    SizedBox(
                                      height: 28,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              localTheme.primaryColor,
                                        ),
                                        onPressed: () => DialogAddToCart.show(
                                            context,
                                            product: product),
                                        child: (product.isPurchased &&
                                                product.isDownloadable!)
                                            ? Text(S
                                                .of(context)
                                                .download
                                                .toUpperCase(),style: TextStyle(
                                          fontFamily: GoogleFonts.cairo().fontFamily,

                                        ),)
                                            : Text(S
                                                .of(context)
                                                .addToCart
                                                .toUpperCase(),style: TextStyle(
                                          fontFamily: GoogleFonts.cairo().fontFamily,

                                        ),),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          const Divider(color: kGrey200, height: 1),
          const SizedBox(height: 10.0),
        ]);
      },
    );
  }
}
