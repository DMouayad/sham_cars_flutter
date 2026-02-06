import 'package:flutter/material.dart';
import 'package:sham_cars/l10n/app_localizations.dart'; // Import this

class SpecItem {
  final String label;
  final String value;
  final IconData icon;
  const SpecItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class SpecGroup {
  final String title;
  final IconData icon;
  final List<SpecItem> items;
  const SpecGroup({
    required this.title,
    required this.icon,
    required this.items,
  });
}

enum _SpecCat {
  batteryRange,
  charging,
  performanceDrive,
  dimensionsPractical,
  engineFuel,
  chassisTransmission,
  other,
}

List<SpecGroup> groupSpecs(
  AppLocalizations l10n, // <--- Add this parameter
  Map<String, String> specs, {
  bool evOnly = false,
}) {
  final groups = <_SpecCat, List<SpecItem>>{
    _SpecCat.batteryRange: [],
    _SpecCat.charging: [],
    _SpecCat.performanceDrive: [],
    _SpecCat.dimensionsPractical: [],
    _SpecCat.engineFuel: [],
    _SpecCat.chassisTransmission: [],
    _SpecCat.other: [],
  };

  for (final entry in specs.entries) {
    final cat = _classify(entry.key, entry.value);
    if (evOnly && cat == _SpecCat.engineFuel) {
      groups[_SpecCat.other]!.add(
        SpecItem(
          label: entry.key,
          value: entry.value,
          icon: Icons.info_outline,
        ),
      );
    } else {
      groups[cat]!.add(_toItem(entry.key, entry.value, cat));
    }
  }

  // Pass l10n to _makeGroup
  final result = <SpecGroup?>[
    _makeGroup(l10n, _SpecCat.batteryRange, groups[_SpecCat.batteryRange]!),
    _makeGroup(l10n, _SpecCat.charging, groups[_SpecCat.charging]!),
    _makeGroup(
      l10n,
      _SpecCat.performanceDrive,
      groups[_SpecCat.performanceDrive]!,
    ),
    _makeGroup(
      l10n,
      _SpecCat.dimensionsPractical,
      groups[_SpecCat.dimensionsPractical]!,
    ),
    if (!evOnly)
      _makeGroup(l10n, _SpecCat.engineFuel, groups[_SpecCat.engineFuel]!),
    _makeGroup(
      l10n,
      _SpecCat.chassisTransmission,
      groups[_SpecCat.chassisTransmission]!,
    ),
    _makeGroup(l10n, _SpecCat.other, groups[_SpecCat.other]!),
  ].whereType<SpecGroup>().toList();

  return result;
}

SpecItem _toItem(String k, String v, _SpecCat cat) {
  final icon = switch (cat) {
    _SpecCat.batteryRange => Icons.battery_charging_full,
    _SpecCat.charging => Icons.ev_station,
    _SpecCat.performanceDrive => Icons.speed,
    _SpecCat.dimensionsPractical => Icons.straighten,
    _SpecCat.engineFuel => Icons.local_gas_station,
    _SpecCat.chassisTransmission => Icons.settings,
    _SpecCat.other => Icons.info_outline,
  };
  return SpecItem(label: k, value: v, icon: icon);
}

SpecGroup? _makeGroup(
  AppLocalizations l10n,
  _SpecCat cat,
  List<SpecItem> items,
) {
  if (items.isEmpty) return null;

  return switch (cat) {
    _SpecCat.batteryRange => SpecGroup(
      title: l10n.specGroupBatteryRange,
      icon: Icons.battery_charging_full,
      items: items,
    ),
    _SpecCat.charging => SpecGroup(
      title: l10n.specGroupCharging,
      icon: Icons.ev_station,
      items: items,
    ),
    _SpecCat.performanceDrive => SpecGroup(
      title: l10n.specGroupPerformanceDrive,
      icon: Icons.speed,
      items: items,
    ),
    _SpecCat.dimensionsPractical => SpecGroup(
      title: l10n.specGroupDimensionsPractical,
      icon: Icons.straighten,
      items: items,
    ),
    _SpecCat.engineFuel => SpecGroup(
      title: l10n.specGroupEngineFuel,
      icon: Icons.local_gas_station,
      items: items,
    ),
    _SpecCat.chassisTransmission => SpecGroup(
      title: l10n.specGroupChassisTransmission,
      icon: Icons.settings,
      items: items,
    ),
    _SpecCat.other => SpecGroup(
      title: l10n.specGroupOther,
      icon: Icons.info_outline,
      items: items,
    ),
  };
}

// ... _classify and _tokens functions remain exactly the same ...
_SpecCat _classify(String key, String value) {
  // ... (Keep existing implementation)
  final k = _tokens(key);
  _tokens(value);

  bool kHas(Set<String> s) => k.any(s.contains);

  // Units / value hints
  final valueLower = value.toLowerCase();
  final hasKwh = valueLower.contains('kwh');
  final hasCm3 = valueLower.contains('cm3') || valueLower.contains('cc');
  final hasLitre =
      valueLower.contains('litre') ||
      valueLower.contains('liter') ||
      valueLower.contains('l ');
  final hasRpm = valueLower.contains('rpm');
  final hasNm = valueLower.contains('nm') || valueLower.contains('n*m');
  final hasBhp = valueLower.contains('bhp') || valueLower.contains('hp');

  // 1) Battery/Range
  if (hasKwh) return _SpecCat.batteryRange;
  if (kHas({'real', 'world', 'range'}) ||
      key.toLowerCase().contains('real-world range')) {
    return _SpecCat.batteryRange;
  }
  if (kHas({'battery'}) || kHas({'wltp', 'epa', 'range'})) {
    return _SpecCat.batteryRange;
  }

  // 2) Charging
  if (kHas({
    'charging',
    'charge',
    'charger',
    'port',
    'plug',
    'connector',
    'ccs',
    'chademo',
    'type2',
    'ac',
    'dc',
    'fast',
    'home',
  })) {
    return _SpecCat.charging;
  }

  // 3) Performance & drivetrain
  if (kHas({
        'acceleration',
        'speed',
        'torque',
        'horsepower',
        'power',
        'drive',
        'awd',
        'rwd',
        'fwd',
      }) ||
      hasNm ||
      hasBhp) {
    return _SpecCat.performanceDrive;
  }

  // 4) Dimensions & practicality
  if (kHas({
    'width',
    'length',
    'height',
    'wheelbase',
    'track',
    'ground',
    'clearance',
    'turning',
    'circle',
    'weight',
    'payload',
    'trunk',
    'cargo',
    'capacity',
    'seater',
    'seats',
    'litre',
    'liter',
    'l',
    'mm',
    'kg',
  })) {
    if (k.length == 1 && k.first == 'capacity' && hasCm3) {
      return _SpecCat.engineFuel;
    }
    return _SpecCat.dimensionsPractical;
  }

  // 5) Engine / fuel
  if (hasCm3 ||
      hasRpm ||
      hasLitre ||
      kHas({
        'engine',
        'fuel',
        'gasoline',
        'diesel',
        'hybrid',
        'injection',
        'cylinder',
        'valves',
        'layout',
        'ron',
        'euro',
        'emission',
      })) {
    return _SpecCat.engineFuel;
  }

  // 6) Chassis / transmission
  if (kHas({
    'gearbox',
    'transmission',
    'cvt',
    'manual',
    'automatic',
    'gear',
    'suspension',
    'brakes',
    'disc',
    'drum',
    'macpherson',
    'wishbone',
    'de',
    'dion',
    'torsion',
    'stabilizer',
    'spring',
  })) {
    return _SpecCat.chassisTransmission;
  }

  return _SpecCat.other;
}

List<String> _tokens(String s) => RegExp(
  r'[a-z0-9]+',
).allMatches(s.toLowerCase()).map((m) => m.group(0)!).toList();
