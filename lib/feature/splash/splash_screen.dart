import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [CustomText(text: "Splash Screen")]),
      ),
    );
  }
}
