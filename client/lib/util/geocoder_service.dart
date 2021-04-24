import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';

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

Future<List<String>> getCoordinates(String plz) async {
  final query = plz;
  List<Location> address = await locationFromAddress(query);

  List<String> ret = [];

  ret.add(address.first.latitude.toString());
  ret.add(address.first.longitude.toString());

  return ret;
}
