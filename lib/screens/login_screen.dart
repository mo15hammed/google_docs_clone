import 'package:flutter/material.dart';

import '../constants/assets_constants.dart';
import '../constants/sizes.dart';
import '../constants/strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Image.asset(
            AssetsConstants.googleLogo,
            height: Sizes.s20,
          ),
          label: const Text(Strings.signInWithGoogle),
        ),
      ),
    );
  }
}
