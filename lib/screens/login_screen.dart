import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/screens/home_screen.dart';

import '../constants/assets_constants.dart';
import '../constants/sizes.dart';
import '../constants/strings.dart';
import '../repository/auth_repository.dart';
import '../utils/snackbar_manager.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(authRepositoryProvider).signInWithGoogle().then((errorModel) {
      if (errorModel.error == null) {
        ref.read(userProvider.notifier).update((state) => errorModel.data);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        SnackBarManager.showSuccessSnackBar(context, errorModel.error!);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
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
