import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sham_cars/utils/utils.dart';

class AppName extends StatelessWidget {
  const AppName({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.bold),
        child: SvgPicture.asset(
          'assets/images/app-name.svg',
          // height: 40,
          theme: SvgTheme(currentColor: color ?? context.colorScheme.secondary),
        ),
      ),
    );
  }
}
