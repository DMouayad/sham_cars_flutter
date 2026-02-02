import 'package:flutter/material.dart';

class ThemeConstants {
  // Spacing
  static const p = 16.0;
  static const pSm = 12.0;
  static const gap = 12.0;

  // Radii (consistent with your web suggestion)
  static const rCard = 16.0; // like rounded-2xl
  static const rThumb = 12.0; // like rounded-xl
  static const rPill = 999.0; // rounded-full

  static BorderRadius cardRadius = BorderRadius.circular(rCard);
  static BorderRadius thumbRadius = BorderRadius.circular(rThumb);
  static BorderRadius pillRadius = BorderRadius.circular(rPill);
}
