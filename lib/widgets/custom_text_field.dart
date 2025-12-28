import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sham_cars/utils/utils.dart';

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool obscure;
  final TextInputType keyboardType;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final bool filled;
  final Color? fillColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Key? formKey;
  final bool isDense;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final String? counterText;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.controller,
    this.onSaved,
    this.prefixIcon,
    this.textInputAction,
    this.obscure = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.onEditingComplete,
    this.filled = true,
    this.fillColor,
    this.textDirection,
    this.hoverColor,
    this.textStyle,
    this.hintTextStyle,
    this.prefixIconColor,
    this.onChanged,
    this.formKey,
    this.isDense = false,
    this.maxLength,
    this.suffixIcon,
    this.suffixIconColor,
    this.inputFormatters,
    required this.labelText,
    this.counterText,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscuredTextIsShown = false;

  Widget? getSuffixIcon() {
    if (widget.obscure) {
      return ExcludeFocus(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () =>
                setState(() => obscuredTextIsShown = !obscuredTextIsShown),
            child: Text(
              obscuredTextIsShown ? context.l10n.hide : context.l10n.show,
            ),
          ),
        ),
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final baseBorder = context.theme.inputDecorationTheme.enabledBorder
        ?.copyWith(borderSide: BorderSide(color: context.colorScheme.outline));
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
      textDirection: widget.textDirection,
      maxLength: widget.maxLength,
      controller: widget.controller,
      key: widget.formKey,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.obscure && !obscuredTextIsShown,
      keyboardType: widget.keyboardType,
      onEditingComplete: widget.onEditingComplete,
      textAlign: widget.textAlign,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      style: widget.textStyle,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        isDense: widget.isDense,
        filled: widget.filled,
        labelText: widget.labelText,
        counterText: widget.counterText,
        errorMaxLines: 6,
        floatingLabelStyle: widget.enabled ? null : context.textTheme.bodyLarge,
        hintStyle: TextStyle(
          color: context.isDarkMode ? Colors.white54 : Colors.black38,
        ),
        fillColor:
            widget.fillColor ??
            (context.isDarkMode ? Colors.black26 : Colors.white60),
        suffixIcon: getSuffixIcon(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 16,
        ),
        suffixIconColor: widget.suffixIconColor,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: widget.prefixIconColor ?? context.colorScheme.onSurface,
          size: 20,
        ),
        hintText: widget.hintText,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder?.copyWith(
          borderSide: BorderSide(
            width: 1.5,
            color: context.colorScheme.primary,
          ),
        ),
        disabledBorder: baseBorder,
        errorBorder: baseBorder?.copyWith(
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        focusedErrorBorder: baseBorder?.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
