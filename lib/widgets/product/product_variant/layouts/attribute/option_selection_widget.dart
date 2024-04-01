import 'package:flutter/material.dart';

import '../../../../../common/config/models/product_detail_config.dart';
import '../../../../../common/constants.dart';
import '../../../../../generated/l10n.dart';

class OptionSelection extends StatelessWidget {
  final List<String?> options;
  final String? value;
  final String? title;
  final Function? onChanged;
  final ProductDetailAttributeLayout? layout;

  const OptionSelection({
    required this.options,
    required this.value,
    this.title,
    this.layout,
    this.onChanged,
  });

  // ignore: always_declare_return_types
  showOptions(context) {
    showModalBottomSheet(
      context: context,
      // https://github.com/inspireui/support/issues/4814#issuecomment-684179116
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.85,
          initialChildSize: 0.5,
          snap: true,
          snapSizes: const [
            0.5,
            0.85,
          ],
          minChildSize: 0.25,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      S.of(context).selectTheSize,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                          ),
                    ),
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  for (final option in options)
                    ListTile(
                      onTap: () {
                        onChanged!(option);
                        Navigator.pop(context);
                      },
                      title: Text(
                        option!.replaceAll('&amp;', '&'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showOptions(context),
      child: SizedBox(
        height: 42,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  // ignore: prefer_single_quotes
                  "${title![0].toUpperCase()}${title!.substring(1)}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                value!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: kGrey600)
            ],
          ),
        ),
      ),
    );
  }
}
