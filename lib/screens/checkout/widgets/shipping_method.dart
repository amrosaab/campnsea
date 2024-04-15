import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

import '../../../common/config.dart'
    show kAdvanceConfig, kEnableCustomerNote, kLoadingWidget, kPaymentConfig;
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/app_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/entities/order_delivery_date.dart';
import '../../../models/order/order.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/shipping_method_model.dart';
import '../../../models/user_model.dart';
import '../../../services/index.dart';
import '../../../widgets/common/common_safe_area.dart';
import 'date_time_picker.dart';
import 'delivery_calendar.dart';

class ShippingMethods extends StatefulWidget {
  final Function? onBack;
  final Function? onNext;
  final Function? onFinish;
  final Function(bool)? onLoading;

  const ShippingMethods({
    this.onBack,
    this.onNext,
    this.onFinish,
    this.onLoading,
  });

  @override
  State<ShippingMethods> createState() => _ShippingMethodsState();
}

class _ShippingMethodsState extends State<ShippingMethods> {
  int? selectedIndex = 0;

  String? selectedId;

  bool isPaying = false;

  TextEditingController note = TextEditingController();

  ShippingMethodModel get shippingMethodModel =>
      Provider.of<ShippingMethodModel>(context, listen: false);

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    note.text = cartModel.notes ?? '';
    Future.delayed(
      Duration.zero,
          () async {
        final shippingMethod = cartModel.shippingMethod;
        final shippingMethods = shippingMethodModel.shippingMethods;
        if (shippingMethods != null &&
            shippingMethods.isNotEmpty &&
            shippingMethod != null) {
          final index = shippingMethods
              .indexWhere((element) => element.id == shippingMethod.id);
          if (index > -1) {
            setState(() {
              selectedIndex = index;
            });
          }
        }
        final langCode = Provider.of<AppModel>(context, listen: false).langCode;
        final token = context.read<UserModel>().user?.cookie;
        final model = Provider.of<PaymentMethodModel>(context, listen: false);
        model
            .getPaymentMethods(
            cartModel: cartModel,
            shippingMethod: cartModel.shippingMethod,
            token: token,
            langCode: langCode)
            .then((value) {
          selectedId = model.paymentMethods.firstWhereOrNull((item) {
            if (true) {
              return item.id != 'wallet' && item.enabled!;
            } else {
              return item.enabled!;
            }
          })?.id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final shippingMethodModel = Provider.of<ShippingMethodModel>(context);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).shippingMethod,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ListenableProvider.value(
                    value: shippingMethodModel,
                    child: Consumer<ShippingMethodModel>(
                      builder: (context, model, child) {
                        if (model.isLoading) {
                          return SizedBox(
                              height: 100, child: kLoadingWidget(context));
                        }

                        if (model.message != null) {
                          return SizedBox(
                            height: 100,
                            child: Center(
                                child: Text(model.message!,
                                    style: const TextStyle(color: kErrorRed))),
                          );
                        }

                        if (model.shippingMethods?.isEmpty ?? true) {
                          return Center(
                            child: Image.asset(
                              'assets/images/empty_shipping.png',
                              width: 120,
                              height: 120,
                            ),
                          );
                        }

                        return _buildShippingMethod(context, model);
                      },
                    ),
                  ),
                  if (kEnableCustomerNote) ...[
                    const SizedBox(height: 20),
                    Text(
                      S.of(context).yourNote,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        maxLines: 5,
                        controller: note,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                            hintText: S.of(context).writeYourNote,
                            hintStyle: const TextStyle(fontSize: 12),
                            border: InputBorder.none),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
        _buildBottom(paymentMethodModel),
      ],
    );
  }

  Widget _buildShippingMethod(BuildContext context, ShippingMethodModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < model.shippingMethods!.length; i++)
          Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? Theme.of(context).primaryColorLight
                      : Colors.transparent,
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: i,
                        groupValue: selectedIndex,
                        onChanged: (dynamic i) {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Services().widget.renderShippingPaymentTitle(
                                context, model.shippingMethods![i].title!),
                            const SizedBox(height: 5),
                            if (model.shippingMethods![i].cost! > 0.0 ||
                                !isNotBlank(
                                    model.shippingMethods![i].classCost))
                              Text(
                                PriceTools.getCurrencyFormatted(
                                    model.shippingMethods![i].cost! +
                                        (model.shippingMethods![i]
                                            .shippingTax ??
                                            0),
                                    cartModel.currencyRates,
                                    currency: cartModel.currencyCode)!,
                                style: const TextStyle(
                                    fontSize: 14, color: kGrey400),
                              ),
                            if (model.shippingMethods![i].cost == 0.0 &&
                                isNotBlank(model.shippingMethods![i].classCost))
                              Text(
                                model.shippingMethods![i].classCost!,
                                style: const TextStyle(
                                    fontSize: 14, color: kGrey400),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              i < model.shippingMethods!.length - 1
                  ? const Divider(height: 1)
                  : const SizedBox()
            ],
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottom(PaymentMethodModel paymentMethodModel) {
    return CommonSafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kPaymentConfig.enableAddress) ...[
            SizedBox(
              width: 130,
              child: OutlinedButton(
                onPressed: () {
                  widget.onBack!();
                },
                child: Text(
                  S.of(context).goBack.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              onPressed: () async {
                // Prevent continue to preview when loading shipping method
                if (shippingMethodModel.isLoading) {
                  return;
                }

                // Set selected shipping method
                if (shippingMethodModel.shippingMethods?.isNotEmpty ?? false) {
                  final selectedShippingMethod =
                  shippingMethodModel.shippingMethods![selectedIndex!];

                  await cartModel.setShippingMethod(selectedShippingMethod);

                  var productList = cartModel.getProductsInCart();

                  unawaited(
                      Services().firebase.firebaseAnalytics?.logAddShippingInfo(
                        coupon: cartModel.couponObj?.code,
                        currency: cartModel.currencyCode,
                        data: productList,
                        price: cartModel.getSubTotal(),
                        shippingTier: cartModel.shippingMethod?.methodTitle,
                      ));

                  //widget.onNext!();
                  /*widget.onNext!(),*/
                  if (note.text.isNotEmpty) {
                    cartModel.setOrderNotes(note.text);
                  }

                  final currencyRate =
                      Provider.of<AppModel>(context, listen: false)
                          .currencyRate;

                  widget.onLoading!(true);
                  isPaying = true;
                  if (paymentMethodModel.paymentMethods.isNotEmpty) {
                    final paymentMethod = paymentMethodModel.paymentMethods
                        .firstWhere((item) => item.id == selectedId);

                    Services().widget.placeOrder(
                      context,
                      cartModel: cartModel,
                      onLoading: widget.onLoading,
                      paymentMethod: paymentMethod,
                      success: (Order? order) async {
                        if (order != null) {
                          for (var item in order.lineItems) {
                            var product =
                            cartModel.getProductById(item.productId!);
                            /*if (product?.bookingInfo != null) {
                                      product!.bookingInfo!.idOrder = order.id;
                                      var booking = await createBooking(product.bookingInfo)!;

                                      Tools.showSnackBar(ScaffoldMessenger.of(context),
                                          booking ? 'Booking success!' : 'Booking error!');
                                    }*/
                          }
                          widget.onFinish!(order);
                        }
                        widget.onLoading?.call(false);
                        isPaying = false;
                      },
                      error: (message) {
                        widget.onLoading?.call(false);
                        if (message != null) {
                          Tools.showSnackBar(
                              ScaffoldMessenger.of(context), message);
                        }

                        isPaying = false;
                      },
                    );
                  }
                  return;
                }

                // If this order doesn't need ship, we can go to the next step
                if ((shippingMethodModel.shippingMethods?.isEmpty ?? true) &&
                    (shippingMethodModel.message?.isEmpty ?? true)) {
                  //widget.onNext!();
                  final cartModel =
                  Provider.of<CartModel>(context, listen: false);
                  /*widget.onNext!(),*/
                  if (note.text.isNotEmpty) {
                    cartModel.setOrderNotes(note.text);
                  }

                  final currencyRate =
                      Provider.of<AppModel>(context, listen: false)
                          .currencyRate;

                  widget.onLoading!(true);
                  isPaying = true;
                  if (paymentMethodModel.paymentMethods.isNotEmpty) {
                    final paymentMethod = paymentMethodModel.paymentMethods
                        .firstWhere((item) => item.id == selectedId);

                    Services().widget.placeOrder(
                      context,
                      cartModel: cartModel,
                      onLoading: widget.onLoading,
                      paymentMethod: paymentMethod,
                      success: (Order? order) async {
                        if (order != null) {
                          for (var item in order.lineItems) {
                            var product =
                            cartModel.getProductById(item.productId!);
                            /*if (product?.bookingInfo != null) {
                                      product!.bookingInfo!.idOrder = order.id;
                                      var booking = await createBooking(product.bookingInfo)!;

                                      Tools.showSnackBar(ScaffoldMessenger.of(context),
                                          booking ? 'Booking success!' : 'Booking error!');
                                    }*/
                          }
                          widget.onFinish!(order);
                        }
                        widget.onLoading?.call(false);
                        isPaying = false;
                      },
                      error: (message) {
                        widget.onLoading?.call(false);
                        if (message != null) {
                          Tools.showSnackBar(
                              ScaffoldMessenger.of(context), message);
                        }

                        isPaying = false;
                      },
                    );
                  }
                  return;
                }
              },

              icon: const Icon(
                Icons.checklist,
                size: 18,
              ),
              label: Text(
                  style:               TextStyle(
                    fontFamily: GoogleFonts.cairo().fontFamily,
                  ),
                  (kPaymentConfig.enableReview
                  ? S.of(context).continueToReview
                  : S.of(context).continueToPayment)
                  .toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryDate() {
    if (!(kAdvanceConfig.enableDeliveryDateOnCheckout)) {
      return const SizedBox();
    }

    Widget deliveryWidget = DateTimePicker(
      onChanged: (DateTime datetime) {
        final orderDeliveryDate = OrderDeliveryDate(datetime);
        orderDeliveryDate.dateString =
            DateFormat('dd-MM-yyyy HH:mm').format(datetime);
        cartModel.selectedDate = orderDeliveryDate;
      },
      minimumDate: DateTime.now(),
      initDate: cartModel.selectedDate?.dateTime,
      border: const OutlineInputBorder(),
    );

    if (shippingMethodModel.deliveryDates?.isNotEmpty ?? false) {
      deliveryWidget =
          DeliveryCalendar(dates: shippingMethodModel.deliveryDates!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              right: Tools.isRTL(context) ? 12.0 : 0.0,
              left: !Tools.isRTL(context) ? 12.0 : 0.0),
          child: Text(S.of(context).deliveryDate,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.7))),
        ),
        const SizedBox(height: 10),
        deliveryWidget,
        const SizedBox(height: 20),
      ],
    );
  }
}
