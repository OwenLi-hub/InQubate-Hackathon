import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../components/background.dart';
import 'components/profile/profile_form.dart';
import 'components/profile/profile_top_image.dart';
import 'components/signup/sign_up_top_image.dart';
import 'components/profile/profile_form.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileProfileSetupScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: ProfileTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: ProfileForm(),
                    ),
                    SizedBox(height: defaultPadding / 2),
                    // SocialSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileProfileSetupScreen extends StatelessWidget {
  const MobileProfileSetupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ProfileTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: ProfileForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}