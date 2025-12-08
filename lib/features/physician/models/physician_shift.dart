import 'package:flutter/material.dart';
import 'package:sham_cars/features/common/models.dart';

enum WeekDay { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

class PhysicianShift {
  final String id;
  final WeekDay startDay;
  final WeekDay endDay;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Location location;

  const PhysicianShift({
    required this.id,
    required this.location,
    required this.startDay,
    required this.endDay,
    required this.startTime,
    required this.endTime,
  });
}
