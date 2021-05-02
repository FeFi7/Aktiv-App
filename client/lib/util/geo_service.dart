import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Breiten- und Laengengrade von User holen über Standortzugriff
Future<List<String>> getActualCoordinates() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Teste ob Location Service verfügbar ist
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // Teste Zugriffsrechte
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  // Teste ob Zugriffsrechte fuer immer gesperrt sind
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // Hole Breiten- und Laengengrade von User (Standortzugriff)
  var address = await Geolocator.getCurrentPosition();

  List<String> ret = [];

  ret.add(address.latitude.toString());
  ret.add(address.longitude.toString());

  return ret;
}

// Breiten- und Längengrad von einer Adresse holen
Future<List<String>> getCoordinatesFromAddress(String plz) async {
  final query = plz;
  List<Location> address = await locationFromAddress(query);

  List<String> ret = [];

  ret.add(address.first.latitude.toString());
  ret.add(address.first.longitude.toString());

  return ret;
}
