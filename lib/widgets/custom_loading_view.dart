import 'package:flutter/material.dart';

class CustomLoadingView extends StatelessWidget {
  const CustomLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
