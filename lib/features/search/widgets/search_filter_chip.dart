import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/utils/utils.dart';

class SearchFilterChip extends StatelessWidget {
  const SearchFilterChip({
    super.key,
    this.label,
    this.onDeleted,
    this.avatarIcon,
    required this.value,
  }) : assert(value != null || label != null);
  final String? label;
  final IconData? avatarIcon;
  final String? value;
  final void Function()? onDeleted;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Chip(
        label: Text(
          label != null ? '$label ${hasValue ? ': $value' : ''}' : value!,
        ),
        labelStyle: context.myTxtTheme.bodyMedium.copyWith(),
        avatar: avatarIcon != null ? Icon(avatarIcon) : null,
        avatarBoxConstraints: const BoxConstraints(maxWidth: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: hasValue
                ? context.colorScheme.primary
                : AppTheme.lightGreyColor,
          ),
        ),
        deleteIconColor: Colors.red,
        onDeleted: hasValue ? onDeleted : null,
      ),
    );
  }
}
