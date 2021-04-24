import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/* Future<List<String>> getCoordinates(String plz) async {
  final query = plz;
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var firstAddress = addresses.first;
  print('${firstAddress.featureName} : ${firstAddress.coordinates}');

  var _coordinates = firstAddress.coordinates
      .toString()
      .substring(1, firstAddress.coordinates.toString().length - 1);

  var __coordinates = _coordinates.split(",");

  __coordinates.forEach((element) {
    print(element);
  });

  return __coordinates;
} */

Future<List<String>> getActualCoordinates() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var address = await Geolocator.getCurrentPosition();

  List<String> ret = [];

  ret.add(address.latitude.toString());
  ret.add(address.longitude.toString());

  return ret;
}

Future<List<String>> getCoordinatesFromAddress(String plz) async {
  final query = plz;
  List<Location> address = await locationFromAddress(query);

  List<String> ret = [];

  ret.add(address.first.latitude.toString());
  ret.add(address.first.longitude.toString());

  return ret;
}
