import 'package:flutter/material.dart';

class VideoPlaceholder extends StatelessWidget {
  final String? message;

  const VideoPlaceholder({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.titleMedium ?? const TextStyle();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      height: 200.0,
      alignment: Alignment.center,
      child: Text(
        message ??
            'Video widget is not supported for reviewing on Desktop. Please test on the real devices.',
        style: textStyle.copyWith(
          color: textStyle.color?.withOpacity(0.5),
        ),
      ),
    );
  }
}
