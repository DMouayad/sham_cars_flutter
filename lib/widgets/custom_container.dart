import 'dart:math';

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(
        Size.fromWidth(min(400, MediaQuery.of(context).size.width * .9)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}
