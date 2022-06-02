import 'package:flate/flate.dart';
import 'package:location/location.dart';

mixin LocationContext on FlateContext {
  late final LocationProvider locationProvider;

  @override
  Future<void> prepare() async {
    await super.prepare();
    final location = Location();
    locationProvider = LocationProvider(location: location);
  }
}

class LocationProvider {
  final Location _location;

  const LocationProvider({
    required Location location,
  }) : _location = location;

  Future<LocationData> currentLocation() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw LocationServiceDisabled();
      }
    }

    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw LocationOperationsNotPermitted();
      }
    }
    return _location.getLocation();
  }
}

class LocationServiceDisabled implements Exception {}

class LocationOperationsNotPermitted implements Exception {}
