import 'package:flutter/material.dart';

import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/utils/utils.dart';

class OtpFields extends StatefulWidget {
  const OtpFields({
    super.key,
    required this.fieldCount,
    required this.onChanged,
    this.digitFieldDimension = 54,
    this.digitFieldBorder,
  });
  final int fieldCount;
  final void Function(int, String) onChanged;
  final double digitFieldDimension;
  final InputBorder? digitFieldBorder;

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fieldCount,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void selectDigitField(int index) {
    if (index < controllers.length) {
      controllers[index].selection = TextSelection(
        baseOffset: 0,
        extentOffset: controllers[index].text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = List.generate(growable: false, widget.fieldCount, (i) {
      return Expanded(
        flex: 0,
        child: _DigitTextField(
          dimension: widget.digitFieldDimension,
          border: widget.digitFieldBorder,
          onTap: () => selectDigitField(i),
          controller: controllers[i],
          textInputAction: TextInputAction.next,
          onChanged: (value) async {
            if (value.isNotEmpty) {
              final isLast = i == widget.fieldCount - 1;

              context.isArabicLocale
                  ? FocusScope.of(context).previousFocus()
                  : FocusScope.of(context).nextFocus();
              if (!isLast) {
                selectDigitField(i + 1);
              }
            }
            widget.onChanged(i, value);
          },
        ),
      );
    });
    return SizedBox(
      width: 300,
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: fields,
      ),
    );
  }
}

class _DigitTextField extends StatelessWidget {
  const _DigitTextField({
    required this.controller,
    required this.textInputAction,
    required this.onChanged,
    required this.onTap,
    this.dimension = 54,
    this.border,
  });
  final TextInputAction textInputAction;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final double dimension;
  final InputBorder? border;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppTheme.lightGreyColor),
    );
    return TextFormField(
      autofocus: true,
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      keyboardType: TextInputType.visiblePassword,
      style: context.textTheme.titleLarge,
      maxLength: 1,
      onTap: onTap,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        counterText: '',
        constraints: BoxConstraints.loose(Size.fromWidth(dimension)),
        border: baseBorder,
        errorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        enabledBorder: border ?? baseBorder,
      ),
    );
  }
}
