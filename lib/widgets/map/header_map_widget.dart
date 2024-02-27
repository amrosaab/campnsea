import 'package:flutter/material.dart';

import '../../models/entities/prediction.dart';
import 'map_address_search_widget.dart';

class HeaderMapWidget extends StatelessWidget {
  final bool canPop;
  final FocusNode? addressFocusNode;
  final TextEditingController? addressController;
  final Function? getAutocompletePlaces;
  final List<Prediction>? autocompletePlaces;
  final Function(int)? getLocationFromPlace;
  final Widget radiusSlider;

  const HeaderMapWidget({
    super.key,
    this.addressFocusNode,
    this.addressController,
    this.canPop = false,
    this.getAutocompletePlaces,
    this.autocompletePlaces,
    this.getLocationFromPlace,
    required this.radiusSlider,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              if (canPop)
                InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 3.0, left: 5.0),
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      height: 35.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: MapAddressSearchWidget(
                              controller: addressController,
                              focusNode: addressFocusNode,
                              onChangedCallBack: (val) =>
                                  getAutocompletePlaces?.call(),
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                    if (autocompletePlaces?.isNotEmpty ?? false)
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 20, right: 70.0),
                        padding: const EdgeInsets.all(
                          10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            autocompletePlaces!.length,
                            (index) => InkWell(
                              onTap: () => getLocationFromPlace?.call(index),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_rounded),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      autocompletePlaces?[index].description ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          radiusSlider,
        ],
      ),
    );
  }
}
