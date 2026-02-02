class BodyType {
  final int id;
  final String name;
  final String icon;

  const BodyType({required this.id, required this.name, required this.icon});

  factory BodyType.fromJson(Map<String, dynamic> json) =>
      BodyType(id: json['id'], name: json['name'], icon: json['icon'] ?? '');
}

class CarMake {
  final int id;
  final String name;
  final String? logoUrl;
  final String? country;

  const CarMake({
    required this.id,
    required this.name,
    this.logoUrl,
    this.country,
  });

  factory CarMake.fromJson(Map<String, dynamic> json) => CarMake(
    id: json['id'],
    name: json['name'],
    logoUrl: json['logo_url'],
    country: json['country'],
  );
}

class CarTrim {
  final int id;
  final String name;
  final String modelName;
  final String makeName;
  final int? yearStart;
  final int? priceMin;
  final int? priceMax;
  final String? currency;
  final String? description;
  final bool isFeatured;
  final List<String> images;
  final String? imageUrl; // for list items
  final CarSpecs specs;

  const CarTrim({
    required this.id,
    required this.name,
    required this.modelName,
    required this.makeName,
    this.yearStart,
    this.priceMin,
    this.priceMax,
    this.currency,
    this.description,
    this.isFeatured = false,
    this.images = const [],
    this.imageUrl,
    this.specs = const CarSpecs(),
  });

  factory CarTrim.fromJson(Map<String, dynamic> json) => CarTrim(
    id: json['id'],
    name: json['name'],
    modelName: json['model_name'] ?? '',
    makeName: json['make_name'] ?? '',
    yearStart: json['year_start'],
    priceMin: json['price_min'],
    priceMax: json['price_max'],
    currency: json['currency'],
    description: json['description'],
    isFeatured: json['is_featured'] ?? false,
    images: List<String>.from(json['images'] ?? []),
    imageUrl: json['image_url'],
    specs: CarSpecs.fromJson(json['specs'] ?? {}),
  );

  String? get priceText {
    if (priceMin == null) return null;
    // Simple formatting - enhance as needed
    final symbol = currency == 'USD' ? '\$' : currency ?? '';
    return '$symbol${_formatNumber(priceMin!)}';
  }

  // Display helpers
  String get displayName => '$modelName $name'.trim();
  String get displayImage =>
      imageUrl ?? (images.isNotEmpty ? images.first : '');
  String get fullName => '$makeName $modelName $name'.trim();
  String get modelAndTrim => '$modelName $name'.trim();
  String get brand => makeName;

  String? get priceRangeText {
    if (priceMin == null) return null;
    final symbol = _currencySymbol;
    if (priceMax != null && priceMax != priceMin) {
      return '$symbol${_formatNumber(priceMin!)} - $symbol${_formatNumber(priceMax!)}';
    }
    return '$symbol${_formatNumber(priceMin!)}';
  }

  String get _currencySymbol => switch (currency) {
    'USD' => '\$',
    'EUR' => '€',
    'SYP' => 'ل.س ',
    _ => currency ?? '',
  };

  static String _formatNumber(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}

class CarModel {
  final int id;
  final String name;
  final String makeName;
  final int makeId;
  final int bodyTypeId;

  // Enriched data (populated client-side)
  final BodyType? bodyType;
  final CarMake? make;

  const CarModel({
    required this.id,
    required this.name,
    required this.makeName,
    required this.makeId,
    required this.bodyTypeId,
    this.bodyType,
    this.make,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    id: json['id'],
    name: json['name'],
    makeName: json['make_name'] ?? '',
    makeId: json['make_id'],
    bodyTypeId: json['body_type_id'],
  );

  CarModel enrich({BodyType? bodyType, CarMake? make}) => CarModel(
    id: id,
    name: name,
    makeName: makeName,
    makeId: makeId,
    bodyTypeId: bodyTypeId,
    bodyType: bodyType ?? this.bodyType,
    make: make ?? this.make,
  );

  String get displayName => '$makeName $name'.trim();
}

class CarSpecs {
  final int? rangeKm;
  final int? batteryKwh;
  final double? accelerationSec;
  final int? topSpeedKmh;
  final String? driveType;
  final int? fastChargeKw;
  final int? seats;

  const CarSpecs({
    this.rangeKm,
    this.batteryKwh,
    this.accelerationSec,
    this.topSpeedKmh,
    this.driveType,
    this.fastChargeKw,
    this.seats,
  });

  factory CarSpecs.fromJson(Map<String, dynamic> json) => CarSpecs(
    rangeKm: json['range_km'],
    batteryKwh: json['battery_kwh'],
    accelerationSec: (json['acceleration_sec'] as num?)?.toDouble(),
    topSpeedKmh: json['top_speed_kmh'],
    driveType: json['drive_type'],
    fastChargeKw: json['fast_charge_kw'],
    seats: json['seats'],
  );
}

/// Lightweight vehicle info for embedding in reviews, etc.
class VehicleSummary {
  final int id;
  final String name;
  final String brandName;
  final int? year;
  final String imageUrl;

  const VehicleSummary({
    required this.id,
    required this.name,
    required this.brandName,
    this.year,
    required this.imageUrl,
  });

  factory VehicleSummary.fromJson(Map<String, dynamic> json) => VehicleSummary(
    id: json['id'],
    name: json['name'],
    brandName: json['brand_name'],
    year: json['year'],
    imageUrl: json['image_url'] ?? '',
  );
}
