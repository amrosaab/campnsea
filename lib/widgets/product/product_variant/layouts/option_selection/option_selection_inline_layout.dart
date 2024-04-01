import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';

class OptionSelectionInlineLayout extends StatelessWidget {
  const OptionSelectionInlineLayout({
    required this.options,
    super.key,
    this.value,
    this.title,
    this.type,
    this.onChanged,
  });

  final List<String?> options;
  final String? value;
  final String? title;
  final String? type;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;



    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title?.capitalize() ?? '',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Wrap(
              spacing: 0.0,
              runSpacing: 5.0,
              children: List.generate(
                options.length,
                (index) {

                  final item = options[index];
                  final isSelected = item == value;
                  final isColor = type == 'color';
                  print('hee');

                  print(item
                      .toString()
                      .replaceAll(' ', '_')
                      .replaceAll('-', '')
                      .toLowerCase());
                  final colorItem = isColor
                      ? (item!.toUpperCase() == value!.toUpperCase()
                          ? HexColor(kNameToHex[item
                                  .toString()
                                  .replaceAll(' ', '_')
                                  .replaceAll('-', '')
                                  .toLowerCase()] ??
                              '#ffffff')
                          : HexColor(kNameToHex[item
                                      .toString()
                                      .replaceAll(' ', '_')
                                      .replaceAll('-', '')
                                      .toLowerCase()] ??
                                  '#ffffff')
                              .withOpacity(0.6))
                      : (item!.toUpperCase() == value!.toUpperCase()
                          ? primaryColor
                          : Colors.transparent);

                  return GestureDetector(
                    onTap: () => onChanged!(item),
                    behavior: HitTestBehavior.opaque,
                    child: Tooltip(
                      message: item.toString(),
                      verticalOffset: 32,
                      preferBelow: false,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        margin: const EdgeInsets.only(
                          right: 5.0,
                          top: 8.0,
                        ),
                        padding:
                            isColor ? const EdgeInsets.all(5) : EdgeInsets.zero,
                        decoration: isColor && isSelected
                            ? BoxDecoration(
                                color: colorItem.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                              )
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          decoration: isColor
                              ? BoxDecoration(
                                  color: colorItem,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.3),
                                  ),
                                )
                              : BoxDecoration(
                                  color: colorItem,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.3),
                                  ),
                                ),
                          child: isColor
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: colorItem
                                              .getColorBasedOnBackground,
                                          size: 16,
                                        )
                                      : const SizedBox(),
                                )
                              : Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 30),
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
