import "package:geolocator/geolocator.dart";
import "package:sham_cars/utils/src/app_error.dart";
import "package:latlong2/latlong.dart";

Future<LatLng> userLatLng() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw AppError.locationServiceDisabled;
  }

  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      throw AppError.locationPermissionDenied;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw AppError.locationPermissionDeniedPermanently;
  }

  final position = await Geolocator.getCurrentPosition();
  return LatLng(position.latitude, position.longitude);
}
