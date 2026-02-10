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
  final String bodyType;
  final int? yearStart;
  final int? yearEnd;
  final int? priceMin;
  final int? priceMax;
  final String? currency;
  final String? description;
  final bool isFeatured;
  final List<String> images;
  final SpecValue range;
  final SpecValue batteryCapacity;
  final SpecValue acceleration;
  final Map<String, String> specs;

  const CarTrim({
    required this.id,
    required this.name,
    required this.modelName,
    required this.makeName,
    required this.bodyType,
    this.yearStart,
    this.yearEnd,
    this.priceMin,
    this.priceMax,
    this.currency,
    this.description,
    this.isFeatured = false,
    this.images = const [],
    required this.range,
    required this.batteryCapacity,
    required this.acceleration,
    this.specs = const {},
  });

  factory CarTrim.fromJson(Map<String, dynamic> json) => CarTrim(
    id: json['id'],
    name: json['name'] ?? '',
    modelName: json['model_name'] ?? '',
    makeName: json['make_name'] ?? '',
    bodyType: json['body_type'] ?? '',
    yearStart: _parseInt(json['year_start']),
    yearEnd: _parseInt(json['year_end']),
    priceMin: _parseInt(json['price_min']),
    priceMax: _parseInt(json['price_max']),
    currency: json['currency'],
    description: json['description'],
    isFeatured: _parseBool(json['is_featured']) ?? false,
    images: List<String>.from(json['images'] ?? []),
    range: SpecValue.fromJson(json['range']),
    batteryCapacity: SpecValue.fromJson(json['battery_capacity']),
    acceleration: SpecValue.fromJson(json['acceleration']),
    specs: _parseSpecs(json['specs']),
  );

  static Map<String, String> _parseSpecs(dynamic specsJson) {
    if (specsJson == null) return {};
    if (specsJson is Map) {
      return specsJson.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }

  // Display helpers
  String get fullName => '$makeName $modelName $name'.trim();
  String get displayName => '$modelName $name'.trim();
  String get displayImage => images.isNotEmpty ? images.first : '';

  String? get yearDisplay {
    if (yearStart == null) return null;
    if (yearEnd != null && yearEnd != yearStart) {
      return '$yearStart - $yearEnd';
    }
    return '$yearStart';
  }

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
    _ => currency != null ? '$currency ' : '',
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

/// Lightweight trim for lists (home, vehicles screen)

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return double.tryParse(value)?.toInt();
  }
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (_parseInt(value) == 0) return false;
  if (_parseInt(value) == 1) return true;
  return null;
}

class CarTrimSummary {
  final int id;
  final String name;
  final String modelName;
  final String makeName;
  final String bodyType;
  final int? yearStart;
  final int? yearEnd;
  final int? priceMin;
  final int? priceMax;
  final String? currency;
  final bool isFeatured;
  final String? imageUrl;
  final SpecValue range;
  final SpecValue batteryCapacity;
  final SpecValue acceleration;
  final double? avgRating;
  final int? reviewsCount;

  const CarTrimSummary({
    required this.id,
    required this.name,
    required this.modelName,
    required this.makeName,
    required this.bodyType,
    this.yearStart,
    this.yearEnd,
    this.priceMin,
    this.priceMax,
    this.currency,
    this.isFeatured = false,
    this.imageUrl,
    required this.range,
    required this.batteryCapacity,
    required this.acceleration,
    this.avgRating,
    this.reviewsCount,
  });

  factory CarTrimSummary.fromJson(Map<String, dynamic> json) => CarTrimSummary(
    id: json['id'],
    name: json['name'] ?? '',
    modelName: json['model_name'] ?? '',
    makeName: json['make_name'] ?? '',
    bodyType: json['body_type'] ?? '',
    yearStart: _parseInt(json['year_start']),
    yearEnd: _parseInt(json['year_end']),
    priceMin: _parseInt(json['price_min']),
    priceMax: _parseInt(json['price_max']),
    reviewsCount: _parseInt(json['reviews_count']),
    avgRating: _parseDouble(json['avg_rating']),
    currency: json['currency'],
    isFeatured: _parseBool(json['is_featured']) ?? false,
    imageUrl: json['image_url'],
    range: SpecValue.fromJson(json['range']),
    batteryCapacity: SpecValue.fromJson(json['battery_capacity']),
    acceleration: SpecValue.fromJson(json['acceleration']),
  );

  // Display helpers
  String get fullName => '$makeName $modelName $name'.trim();
  String get displayName => '$modelName $name'.trim();

  String? get yearDisplay {
    if (yearStart == null) return null;
    if (yearEnd != null && yearEnd != yearStart) {
      return '$yearStart - $yearEnd';
    }
    return '$yearStart';
  }

  String? get priceDisplay {
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
    _ => currency != null ? '$currency ' : '',
  };

  static String _formatNumber(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );

  /// Check if we have enough data for a good preview
  bool get hasBasicInfo => makeName.isNotEmpty || displayName.isNotEmpty;
  bool get hasSpecs =>
      range.isNotEmpty || acceleration.isNotEmpty || batteryCapacity.isNotEmpty;

  bool get hasRating => (avgRating != null) && (reviewsCount ?? 0) > 0;

  String get ratingDisplay =>
      avgRating == null ? '' : avgRating!.toStringAsFixed(1);
}

class SpecValue {
  final String value;
  final String unit;
  final String display;

  const SpecValue({
    required this.value,
    required this.unit,
    required this.display,
  });

  factory SpecValue.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SpecValue(value: '', unit: '', display: '');
    return SpecValue(
      value: json['value']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      display: json['display']?.toString() ?? '',
    );
  }

  bool get isEmpty => value.isEmpty;
  bool get isNotEmpty => value.isNotEmpty;

  double? get numericValue => double.tryParse(value);
}

class TrimFilters {
  final String? search;
  final int? makeId;
  final int? modelId;
  final int? bodyTypeId;
  final int? minPrice;
  final int? maxPrice;
  final int? minRangeKm;
  final int? seats;
  final bool? featured;
  final int? take;
  final int? skip;

  const TrimFilters({
    this.search,
    this.makeId,
    this.modelId,
    this.bodyTypeId,
    this.minPrice,
    this.maxPrice,
    this.minRangeKm,
    this.seats,
    this.featured,
    this.take,
    this.skip,
  });

  TrimFilters copyWith({
    String? search,
    int? makeId,
    int? modelId,
    int? bodyTypeId,
    int? minPrice,
    int? maxPrice,
    int? minRangeKm,
    int? seats,
    bool? featured,
    int? take,
    int? skip,
    bool clearSearch = false,
    bool clearMake = false,
    bool clearModel = false,
    bool clearBodyType = false,
    bool clearPrice = false,
    bool clearRange = false,
    bool clearSeats = false,
    bool clearFeatured = false,
  }) {
    return TrimFilters(
      search: clearSearch ? null : (search ?? this.search),
      makeId: clearMake ? null : (makeId ?? this.makeId),
      modelId: clearModel ? null : (modelId ?? this.modelId),
      bodyTypeId: clearBodyType ? null : (bodyTypeId ?? this.bodyTypeId),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      minRangeKm: clearRange ? null : (minRangeKm ?? this.minRangeKm),
      seats: clearSeats ? null : (seats ?? this.seats),
      featured: clearFeatured ? null : (featured ?? this.featured),
      take: take ?? this.take,
      skip: skip ?? this.skip,
    );
  }

  Map<String, String> toQueryParams() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search!,
      if (makeId != null) 'make_id': '$makeId',
      if (modelId != null) 'model_id': '$modelId',
      if (bodyTypeId != null) 'body_type_id': '$bodyTypeId',
      if (minPrice != null) 'min_price': '$minPrice',
      if (maxPrice != null) 'max_price': '$maxPrice',
      if (minRangeKm != null) 'min_range_km': '$minRangeKm',
      if (seats != null) 'seats': '$seats',
      if (featured != null) 'featured': '$featured',
      if (take != null) 'take': '$take',
      if (skip != null) 'skip': '$skip',
    };
  }

  bool get hasFilters =>
      (search != null && search!.isNotEmpty) ||
      makeId != null ||
      modelId != null ||
      bodyTypeId != null ||
      minPrice != null ||
      maxPrice != null ||
      minRangeKm != null ||
      seats != null ||
      featured != null;

  int get activeFilterCount {
    int count = 0;
    if (search != null && search!.isNotEmpty) count++;
    if (makeId != null) count++;
    if (bodyTypeId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minRangeKm != null) count++;
    if (seats != null) count++;
    return count;
  }

  TrimFilters clear() => TrimFilters(take: take);
}
