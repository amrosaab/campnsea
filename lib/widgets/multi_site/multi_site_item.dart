import 'package:flutter/material.dart';

import '../../common/config/multi_site.dart';
import '../common/flux_image.dart';

class MultiSiteItem extends StatelessWidget {
  const MultiSiteItem(
      {Key? key,
      required this.multiSiteConfig,
      required this.selected,
      required this.onTap})
      : super(key: key);
  final MultiSiteConfig multiSiteConfig;
  final bool selected;
  final Function(MultiSiteConfig) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => onTap(multiSiteConfig),
        child: Row(
          children: [
            if (multiSiteConfig.icon?.isNotEmpty ?? false)
              FluxImage(
                imageUrl: multiSiteConfig.icon!,
                width: 70,
                height: 50,
                fit: BoxFit.cover,
              ),
            if (multiSiteConfig.icon?.isNotEmpty ?? false)
              const SizedBox(width: 10),
            Expanded(
              child: Text(
                multiSiteConfig.name ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                size: 25, color: Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }
}
