import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../common/config/models/onboarding_config.dart';
import '../../../home/change_language_mixin.dart';
import '../../onboarding_mixin.dart';
import 'render_slider_widget.dart';

class OnBoardingV2 extends StatefulWidget {
  final OnBoardingConfig config;
  const OnBoardingV2({
    super.key,
    required this.config,
  });

  @override
  State<OnBoardingV2> createState() => _OnBoardingV2State();
}

class _OnBoardingV2State extends State<OnBoardingV2>
    with OnBoardingMixin, ChangeLanguage {
  final controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.config.items;
    final numItems = items.length;

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    for (final item in items)
                      RenderSliderWidget(
                        config: item,
                        autoCropImageByDesign:
                            widget.config.autoCropImageByDesign,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: controller,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor:
                            Theme.of(context).primaryIconTheme.color ??
                                Colors.black,
                        dotHeight: 7,
                        dotWidth: 7,
                        expansionFactor: 3,
                      ),
                      count: numItems,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.page?.toInt() == numItems - 1) {
                            onTapDone();
                            return;
                          }
                          controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          foregroundColor: Theme.of(context).primaryColorLight,
                          backgroundColor:
                              Theme.of(context).primaryIconTheme.color,
                        ),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          if (widget.config.showLanguage)
            iconLanguage(
              backgroundColor: Colors.black.withOpacity(0.3),
            )
        ],
      ),
    );
  }
}
