import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../models/entities/user.dart';
import '../../../../services/service_config.dart';
import '../../../../widgets/common/flux_image.dart';
import 'setting_card_widget.dart';

class SettingItemUserInfoWidget extends StatelessWidget {
  const SettingItemUserInfoWidget({
    super.key,
    required this.user,
    this.onTapUpdateProfile,
    this.cardStyle,
  });

  final User user;
  final SettingItemStyle? cardStyle;
  final void Function()? onTapUpdateProfile;

  @override
  Widget build(BuildContext context) {
    if ([
      SettingItemStyle.flat,
      SettingItemStyle.flatShadow,
      SettingItemStyle.flatListTile
    ].contains(cardStyle)) {
      final item = ListTile(
        leading: (user.picture?.isNotEmpty ?? false)
            ? Hero(
                tag: 'user-avatar-${user.picture}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FluxImage(
                    imageUrl: user.picture!,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              )
            : const Icon(Icons.face),
        title: Text(
          user.name ?? '',
          style: const TextStyle(fontSize: 16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        horizontalTitleGap: 24.0,
        subtitle: (user.identifierInformation.isNotEmpty)
            ? Text(
                user.identifierInformation,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary),
              )
            : null,
        onTap: onTapUpdateProfile,
        trailing: !ServerConfig().isWordPress
            ? IconButton(
                onPressed: onTapUpdateProfile,
                icon: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: FittedBox(
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              )
            : null,
      );

      return SettingCardWidget(
        style: cardStyle,
        child: Container(
          decoration: cardStyle?.decorationCardItem(context),
          child: item,
        ),
      );
    }

    return ListTile(
      leading: (user.picture?.isNotEmpty ?? false)
          ? Hero(
              tag: 'user-avatar-${user.picture}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FluxImage(
                  imageUrl: user.picture!,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
              ),
            )
          : const Icon(Icons.face),
      title: Text(
        user.name ?? '',
        style: const TextStyle(fontSize: 16),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      horizontalTitleGap: 24.0,
      subtitle: (user.identifierInformation.isNotEmpty)
          ? Text(
              user.identifierInformation,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.secondary),
            )
          : null,
      onTap: onTapUpdateProfile,
      trailing: !ServerConfig().isWordPress
          ? IconButton(
              onPressed: onTapUpdateProfile,
              icon: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
