import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/extensions/sizes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double get textScaleFactor =>
      MediaQuery.of(context).size.width < 360 ? 0.7 : 1.0;
  double get iconSize => MediaQuery.of(context).size.width < 360 ? 16.0 : 24.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.greenGradient,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 30),
                  bottomRight: Radius.elliptical(500, 30),
                ),
              ),
              height: 287.h,
            ),
          ),
        ],
      ),
    );
  }
}
