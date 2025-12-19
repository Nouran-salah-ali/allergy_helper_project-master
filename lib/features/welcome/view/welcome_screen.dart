import 'package:allergy_helper_project/core/constants/app_images/app_images.dart';
import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/welcome/logic/welcome_provider.dart';
import 'package:allergy_helper_project/features/welcome/view/widgets/custom_dots_indicator.dart';
import 'package:allergy_helper_project/features/welcome/view/widgets/welcome_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    final pages = [
      WelcomeScreenItem(
        title: "Scanner",
        subtitle: "Quickly scan product barcodes to check if they're safe based on your allergies. Fast, reliable, and tailored to your needs. ",
        image: AppImages.welcomeImage1,
      ),
      WelcomeScreenItem(
        title: "Select and Preferences",
        subtitle: "Customize your allergy preferences and let the app recommend products that suit your lifestyle.",
        image: AppImages.welcomeImage2,
      ),
      WelcomeScreenItem(
        title: "Group chat",
        subtitle: "Join a supportive community to share experiences, tips, and recommendations.",
        image: AppImages.welcomeImage3,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 40.0,
        ),
        child: Consumer<WelcomeProvider>(
          builder: (context, provider, _) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //calling skip button
                  SkipButton(
                    onPressed: () {
                      provider.setWelcomeScreenPreferences();
                      provider.changeShowWelcomeScreenState();
                    },
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) => provider.updatePage(value),
                  children: [...pages],
                ),
              ),
              const SizedBox(height: 24),
              //**************************************** coustom indecator
              CustomDotsIndicator(
                index: provider.currentIndex,
              ),
              //***********************************************
              const SizedBox(height: 24),
              //***************************************do not show again
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do not show again?"),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: provider.welcomeScreenCheckbox,
                    //from t to f f to t
                    onChanged: (_) => provider.updateWelcomeScreenCheckbox(),
                  )
                ],
              ),
              const SizedBox(height: 24),
              //*****************************next button
              NextButton(
                onPressed: () {
                  if (provider.lastPage) {
                    provider.setWelcomeScreenPreferences();
                    provider.changeShowWelcomeScreenState();
                  } else {
                    provider.nextPage();
                    // If we still have a client it will update the page controller
                    if (pageController.hasClients) {
                      pageController.animateToPage(
                        provider.currentIndex,
                        duration: Duration(microseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}//class welcome
//**************************************************skip buttom
class SkipButton extends StatelessWidget {
  const SkipButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Skip',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          color: Color(0xff898989),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}//skip button
//**************************************************************next button
class NextButton extends StatelessWidget {
  const NextButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.primaryColor,
          foregroundColor: AppColorsLight.secondaryColor,
          fixedSize: Size(100, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
      onPressed: onPressed,
      child: Text("Next"),
    );
  }
}//next button
