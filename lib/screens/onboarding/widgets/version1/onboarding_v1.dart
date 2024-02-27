import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../../../common/config/models/onboarding_config.dart';
import '../../../../common/constants.dart';
import '../../../../common/tools/navigate_tools.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/services.dart';
import '../../../../widgets/common/flux_image.dart';
import '../../../../widgets/onboarding/multi_language_text_button.dart';
import '../../../home/change_language_mixin.dart';
import '../../onboarding_mixin.dart';

class OnBoardingV1 extends StatefulWidget {
  final OnBoardingConfig config;
  const OnBoardingV1({
    super.key,
    required this.config,
  });

  @override
  State<OnBoardingV1> createState() => _OnBoardingV1State();
}

class _OnBoardingV1State extends State<OnBoardingV1>
    with ChangeLanguage, OnBoardingMixin {
  List<ContentConfig> getSlides(List<dynamic> data) {
    final slides = <ContentConfig>[];

    Widget renderLoginWidget(String imagePath) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FluxImage(
            imageUrl: imagePath,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: onTapSignIn,
                  child: Text(
                    S.of(context).signIn,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Text(
                  '    |    ',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20.0),
                ),
                GestureDetector(
                  onTap: () async {
                    setHasSeen();
                    NavigateTools.navigateRegister(
                      context,
                      replacement: true,
                    );
                  },
                  child: Text(
                    S.of(context).signUp,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    for (var i = 0; i < data.length; i++) {
      final isLastItem = i == data.length - 1;

      var slide = ContentConfig(
        title: data[i].title,
        description: data[i].desc,
        marginTitle: const EdgeInsets.only(
          top: 100.0,
          bottom: 50.0,
        ),
        maxLineTextDescription: 2,
        styleTitle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          color: kGrey900,
        ),
        backgroundColor: Colors.white,
        marginDescription: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0),
        styleDescription: const TextStyle(
          fontSize: 15.0,
          color: kGrey600,
        ),
        foregroundImageFit: BoxFit.fitWidth,
        centerWidget: isLastItem
            ? renderLoginWidget(
                data[i].image,
              )
            : FluxImage(
                imageUrl: data[i].image,
                fit: BoxFit.fitWidth,
              ),
      );
      slides.add(slide);
    }
    return slides;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.config.items;
    final isRequiredLogin = Services().widget.isRequiredLogin;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IntroSlider(
            listContentConfig: getSlides(data),
            renderSkipBtn:
                MultiLanguageTextButton(getText: () => S.of(context).skip),
            renderDoneBtn: MultiLanguageTextButton(
                getText: () => isRequiredLogin ? '' : S.of(context).done),
            renderPrevBtn:
                MultiLanguageTextButton(getText: () => S.of(context).prev),
            renderNextBtn:
                MultiLanguageTextButton(getText: () => S.of(context).next),
            isShowDoneBtn: !isRequiredLogin,
            onDonePress: onTapDone,
          ),
          if (widget.config.showLanguage) iconLanguage(),
        ],
      ),
    );
  }
}
