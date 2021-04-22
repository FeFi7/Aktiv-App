import 'package:geocoder/geocoder.dart';

Future<List<String>> getCoordinates(String plz) async {
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
}
