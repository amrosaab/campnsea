import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/user_model.dart';
import 'setting_card_widget.dart';
import 'setting_item_widget.dart';

class SettingNotificationWidget extends StatelessWidget {
  const SettingNotificationWidget({
    super.key,
    this.cardStyle,
  });

  final SettingItemStyle? cardStyle;
  void _onChanged(
      BuildContext context, NotificationModel model, bool enableNotification) {
    if (enableNotification) {
      model.enableNotification();
    } else {
      model.disableNotification();
    }
    var cookie = Provider.of<UserModel>(context, listen: false).user?.cookie;
    model.updateNotificationStatus(cookie);
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      S.of(context).getNotification,
      style: const TextStyle(fontSize: 16),
    );

    final icon = Icon(
      CupertinoIcons.bell,
      color: Theme.of(context).colorScheme.secondary,
      size: 24,
    );

    const activeColor = Color(0xFF0066B4);
    final messageWidget = SettingItemWidget(
      cardStyle: cardStyle,
      icon: CupertinoIcons.list_bullet,
      title: S.of(context).listMessages,
      onTap: () => Navigator.of(context).pushNamed(RouteList.notify),
    );

    return Consumer<NotificationModel>(builder: (context, model, child) {
      switch (cardStyle) {
        case SettingItemStyle.flatShadow:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flatShadow,
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  activeColor: activeColor,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        case SettingItemStyle.flat:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flat,
                child: SwitchListTile(
                  secondary: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  activeColor: activeColor,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        case SettingItemStyle.flatListTile:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flatListTile,
                child: SwitchListTile(
                  secondary: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  activeColor: activeColor,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        default:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.listTile,
                child: SwitchListTile(
                  secondary: icon,
                  value: model.enable,
                  activeColor: activeColor,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              const Divider(color: Colors.black12, height: 1.0, indent: 75),
              if (model.enable) messageWidget,
            ],
          );
      }
    });
  }
}
