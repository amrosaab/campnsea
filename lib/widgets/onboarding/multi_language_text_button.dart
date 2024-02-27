import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_model.dart';

class MultiLanguageTextButton extends StatelessWidget {
  const MultiLanguageTextButton({
    Key? key,
    required this.getText,
  }) : super(key: key);

  final String Function() getText;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, _, __) {
      return Text(
        getText(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
