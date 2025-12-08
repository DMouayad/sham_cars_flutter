import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/models/signup_form_helper.dart';
import 'package:sham_cars/utils/utils.dart';

class BaseSignupForm extends StatelessWidget {
  const BaseSignupForm({super.key, required this.builder});
  final List<Widget> Function(SignupFormHelper, Padding) builder;

  @override
  Widget build(BuildContext context) {
    final formHelper = context.read<SignupCubit>().formHelper;
    const formGap = Padding(padding: EdgeInsets.all(10));
    return Form(
      key: formHelper.formKey,
      child: Center(
        child: Container(
          constraints: BoxConstraints.tight(
            Size.fromWidth(min(400, context.screenWidth * .9)),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/images/logo.svg', height: 50),
                const SizedBox(height: 58),
                ...builder(formHelper, formGap),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
