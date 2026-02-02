import 'package:flutter/material.dart';

class CorporateColors {
  // Base (Backgrounds)
  static const Color base100 = Color(0xFFFFFFFF); // oklch(100% 0 0)
  static const Color base200 = Color(0xFFEDEDED); // oklch(93% 0 0)
  static const Color base300 = Color(0xFFDBDBDB); // oklch(86% 0 0)
  static const Color baseContent = Color(
    0xFF2B3440,
  ); // oklch(22.389% 0.031 278.072)

  // Primary (Professional Blue)
  static const Color primary = Color(0xFF4B6BFB); // oklch(58% 0.158 241.966)
  static const Color primaryContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  // Secondary (Greyish Blue)
  static const Color secondary = Color(0xFF7B92B2); // oklch(55% 0.046 257.417)
  static const Color secondaryContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  // Accent (Teal/Greenish - Mapped to Tertiary)
  static const Color accent = Color(0xFF67CBA0); // oklch(60% 0.118 184.704)
  static const Color accentContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  // Neutral (Pure Black)
  static const Color neutral = Color(0xFF000000); // oklch(0% 0 0)
  static const Color neutralContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  // Semantic
  static const Color info = Color(0xFF3ABFF8); // oklch(60% 0.126 221.723)
  static const Color infoContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  static const Color success = Color(0xFF36D399); // oklch(62% 0.194 149.214)
  static const Color successContent = Color(0xFFFFFFFF); // oklch(100% 0 0)

  static const Color warning = Color(0xFFFBBD23); // oklch(85% 0.199 91.936)
  static const Color warningContent = Color(0xFF000000); // oklch(0% 0 0)

  static const Color error = Color.fromARGB(
    255,
    231,
    77,
    77,
  ); // oklch(70% 0.191 22.216)
  static const Color errorContent = Color(0xFF000000); // oklch(0% 0 0)
}

@immutable
class DaisyCustomColors extends ThemeExtension<DaisyCustomColors> {
  final Color? info;
  final Color? onInfo;
  final Color? success;
  final Color? onSuccess;
  final Color? warning;
  final Color? onWarning;

  const DaisyCustomColors({
    required this.info,
    required this.onInfo,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
  });

  @override
  DaisyCustomColors copyWith({
    Color? info,
    Color? onInfo,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
  }) {
    return DaisyCustomColors(
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
    );
  }

  @override
  DaisyCustomColors lerp(ThemeExtension<DaisyCustomColors>? other, double t) {
    if (other is! DaisyCustomColors) return this;
    return DaisyCustomColors(
      info: Color.lerp(info, other.info, t),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
    );
  }

  // Corporate Specific Instance
  static const corporate = DaisyCustomColors(
    info: CorporateColors.info,
    onInfo: CorporateColors.infoContent,
    success: CorporateColors.success,
    onSuccess: CorporateColors.successContent,
    warning: CorporateColors.warning,
    onWarning: CorporateColors.warningContent,
  );
}
