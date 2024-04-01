import 'package:flutter/material.dart';

import '../../../../../common/config/models/product_detail_config.dart';
import '../../../../../common/constants.dart';
import '../../../../../generated/l10n.dart';

class ColorSelection extends StatelessWidget {
  final List<String> options;
  final String value;
  final Function? onChanged;
  final ProductDetailAttributeLayout? layout;

  const ColorSelection(
      {required this.options,
      required this.value,
      this.layout,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (layout == ProductDetailAttributeLayout.dropdown) {
      return GestureDetector(
        onTap: () => showOptions(context),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1.0, color: kGrey200)),
          height: 42,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(S.of(context).color,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: kNameToHex[value.toLowerCase()] != null
                            ? HexColor(kNameToHex[value.toLowerCase()]!)
                            : Colors.transparent)),
                const SizedBox(width: 5),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: kGrey600)
              ],
            ),
          ),
        ),
      );
    }

    print('hee1');

    return SizedBox(
      height: 25,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Center(
              child: Text(
                S.of(context).color,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 15.0),
            for (var item in options)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                margin: const EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  color: item == value
                      ? HexColor(kNameToHex[item.toLowerCase()]!)
                      : HexColor(kNameToHex[item.toLowerCase()]!)
                          .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                      width: 1.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5)),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    onChanged!(item);
                  },
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: item == value
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final option in options)
                ListTile(
                  onTap: () {
                    onChanged!(option);
                    Navigator.pop(context);
                  },
                  title: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        border: Border.all(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.secondary),
                        color: HexColor(kNameToHex[option.toLowerCase()]!),
                      ),
                    ),
                  ),
                ),
              Container(
                height: 1,
                decoration: const BoxDecoration(color: kGrey200),
              ),
              ListTile(
                title: Text(
                  S.of(context).selectTheColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
