// lib/utils/spec_icons.dart
import 'package:flutter/material.dart';

class SpecIcons {
  static const _iconMap = <String, IconData>{
    // Range & Battery
    'range': Icons.route,
    'battery': Icons.battery_charging_full,
    'battery_capacity': Icons.battery_charging_full,

    // Performance
    'acceleration': Icons.speed,
    'top_speed': Icons.shutter_speed,
    'power': Icons.bolt,
    'torque': Icons.rotate_right,

    // Charging
    'fast_charge': Icons.electrical_services,
    'charge_time': Icons.timer,
    'charge_port': Icons.ev_station,

    // Physical
    'seats': Icons.event_seat,
    'doors': Icons.door_front_door,
    'trunk': Icons.luggage,
    'weight': Icons.scale,

    // Drive
    'drive_type': Icons.settings,
    'awd': Icons.all_inclusive,

    // Other
    'body_type': Icons.directions_car,
    'year': Icons.calendar_today,
    'warranty': Icons.verified_user,
  };

  /// Get icon for a spec key (tries to match keywords)
  static IconData forKey(String key) {
    final lower = key.toLowerCase();

    // Direct match
    if (_iconMap.containsKey(lower)) {
      return _iconMap[lower]!;
    }

    // Keyword matching
    if (lower.contains('range') || lower.contains('مدى')) {
      return Icons.route;
    }
    if (lower.contains('battery') || lower.contains('بطارية')) {
      return Icons.battery_charging_full;
    }
    if (lower.contains('accel') ||
        lower.contains('تسارع') ||
        lower.contains('0-100')) {
      return Icons.speed;
    }
    if (lower.contains('speed') || lower.contains('سرعة')) {
      return Icons.shutter_speed;
    }
    if (lower.contains('seat') || lower.contains('مقعد')) {
      return Icons.event_seat;
    }
    if (lower.contains('charge') || lower.contains('شحن')) {
      return Icons.ev_station;
    }
    if (lower.contains('power') ||
        lower.contains('قوة') ||
        lower.contains('kw') ||
        lower.contains('hp')) {
      return Icons.bolt;
    }
    if (lower.contains('torque') || lower.contains('عزم')) {
      return Icons.rotate_right;
    }
    if (lower.contains('drive') || lower.contains('دفع')) {
      return Icons.settings;
    }
    if (lower.contains('trunk') ||
        lower.contains('cargo') ||
        lower.contains('صندوق')) {
      return Icons.luggage;
    }
    if (lower.contains('weight') || lower.contains('وزن')) {
      return Icons.scale;
    }
    if (lower.contains('door') || lower.contains('باب')) {
      return Icons.door_front_door;
    }
    if (lower.contains('warranty') || lower.contains('ضمان')) {
      return Icons.verified_user;
    }

    // Default
    return Icons.info_outline;
  }

  /// Get color for spec type
  static Color colorFor(String key, ColorScheme cs) {
    final lower = key.toLowerCase();

    if (lower.contains('range') || lower.contains('battery')) {
      return Colors.green;
    }
    if (lower.contains('accel') ||
        lower.contains('speed') ||
        lower.contains('power')) {
      return Colors.orange;
    }
    if (lower.contains('charge')) {
      return Colors.blue;
    }

    return cs.primary;
  }
}
