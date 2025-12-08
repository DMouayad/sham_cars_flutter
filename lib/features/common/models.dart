class Location {
  final String id;
  final LocationDescription? description;
  final double? lat;
  final double? long;

  const Location({required this.id, this.description, this.lat, this.long})
      : assert((lat != null && long != null) || description != null);
}

class LocationDescription {
  final String city;
  final String street;
  final String? additionalInfo;

  const LocationDescription({
    required this.city,
    required this.street,
    required this.additionalInfo,
  });
}
