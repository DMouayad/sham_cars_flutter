import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late final List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fieldCount,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(widget.fieldCount, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void selectDigitField(int index) {
    if (index < 0 || index >= controllers.length) return;

    focusNodes[index].requestFocus();

    // Post-frame: ensures EditableText has the latest value before selection set.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final len = controllers[index].text.length;
      controllers[index].selection = TextSelection(
        baseOffset: 0,
        extentOffset: len.clamp(0, len),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = List.generate(widget.fieldCount, (i) {
      return SizedBox(
        width: widget.digitFieldDimension,
        child: _DigitTextField(
          autofocus: i == 0,
          focusNode: focusNodes[i],
          dimension: widget.digitFieldDimension,
          border: widget.digitFieldBorder,
          onTap: () => selectDigitField(i),
          controller: controllers[i],
          textInputAction: i == widget.fieldCount - 1
              ? TextInputAction.done
              : TextInputAction.next,
          onChanged: (raw) {
            // Strong guard: only keep the last digit if something weird gets in
            final value = raw.isEmpty ? '' : raw.characters.last;

            if (raw != value) {
              controllers[i].text = value;
              controllers[i].selection = TextSelection.collapsed(
                offset: value.length,
              );
            }

            widget.onChanged(i, value);

            if (value.isNotEmpty) {
              final isLast = i == widget.fieldCount - 1;
              if (isLast) {
                FocusScope.of(context).unfocus();
              } else {
                selectDigitField(i + 1);
              }
            }
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
    required this.focusNode,
    required this.autofocus,
    this.dimension = 54,
    this.border,
  });

  final TextInputAction textInputAction;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final double dimension;
  final InputBorder? border;
  final VoidCallback onTap;
  final FocusNode focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppTheme.lightGreyColor),
    );

    return TextFormField(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      maxLength: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: context.textTheme.titleLarge,
      decoration: InputDecoration(
        counterText: '',
        constraints: BoxConstraints.tightFor(width: dimension),
        border: baseBorder,
        enabledBorder: border ?? baseBorder,
        errorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
      ),
      validator: (value) => (value?.isEmpty ?? true) ? '' : null,
    );
  }
}
