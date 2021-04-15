import 'package:http/http.dart' as http;
import 'dart:convert';

const SERVER_IP = "85.214.166.230";

Future<http.Response> attemptLogIn(String mail, String passwort) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

  if (mail.isNotEmpty && passwort.isNotEmpty) {
    final response = await http.post(Uri.http(SERVER_IP, 'api/user/login'),
        headers: <String, String>{
          'Content-Type': "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print("Login erfolgreich");
    } else {
      print(response.statusCode);
    }

    return response;
  } else
    return null;
}

Future<http.Response> attemptSignUpWithPLZ(
    String mail, String passwort, String plz) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort, 'plz': plz};
  if (mail.isNotEmpty && passwort.isNotEmpty && plz.isNotEmpty) {
    final response = await http.post(Uri.http(SERVER_IP, '/api/user/signup'),
        headers: <String, String>{
          'Content-Type': "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print("Registrierung erfolgreich");
    } else {
      print(response.statusCode);
    }

    print(response);

    return response;
  } else
    return null;
}

Future<http.Response> attemptSignUp(String mail, String passwort) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

  if (mail.isNotEmpty && passwort.isNotEmpty) {
    final response = await http.post(Uri.http(SERVER_IP, '/api/user/signup'),
        headers: <String, String>{
          'Content-Type': "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print("Registrierung erfolgreich");
    } else {
      print(response.statusCode);
    }

    print(response);

    return response;
  } else
    return null;
}

Future<String> attemptNewAccessToken(String refreshToken) async {
  Map<String, dynamic> body = {'token': refreshToken};

  final response = await http.post(Uri.http(SERVER_IP, 'api/user/token'),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Neuer AccessToken vorhanden");
  } else {
    print(response.statusCode);
  }

  return response.body;
}

Future<String> attemptGetUser(String mail) async {
  Map<String, dynamic> qParams = {'mail': mail};

  final response = await http.get(Uri.http(SERVER_IP, 'api/user/', qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET User erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response.body;
}

Future<http.Response> attemptGetVeranstaltungByID(int veranstaltungsId) async {
  String route = "api/veranstaltungen/" + veranstaltungsId.toString();

  final response = await http.get(Uri.http(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET Veranstaltung erfolgreich");
  } else {
    print(response.statusCode);
  }

  print(response.body);
  return response;
}

Future<http.Response> attemptDeleteVeranstaltung(int veranstaltungsId) async {
  String route = "api/veranstaltungen" + veranstaltungsId.toString();

  final response = await http.delete(Uri.http(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("Veranstaltung erfolgreich gelöscht");
  } else {
    print(response.statusCode);
  }

  return response;
}

//TODO bis muss + 1 tag sein
////Jahr-Monat-Tag // Ein Tag draufrechnen, da dieser nicht von mysql berechtigt wird
//datetime.utc draufrechnen
Future<http.Response> attemptGetAllVeranstaltungen(
    {String bis = "-1",
    String istGenehmigt = "1",
    String limit = "25",
    String page = "1"}) async {
  Map<String, dynamic> qParams = {'istGenehmigt': istGenehmigt, 'limit': limit};

  if (bis != "-1") {
    qParams.putIfAbsent('bis', () => bis);
  }

  String route = "api/veranstaltungen";

  final response = await http.get(Uri.http(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET All Veranstaltungen erfolgreich");
  } else {
    print(response.statusCode);
  }

  print(response.body);
  return response;
}

Future<http.Response> attemptCreateVeranstaltung(
    String titel,
    String beschreibung,
    String kontakt,
    String beginn_ts,
    String ende_ts,
    String ortBeschreibung,
    String latitude,
    String longitude,
    String institutionId,
    String userId,
    String istGenehmigt) async {
  String route = "api/veranstaltungen/";

  Map<String, dynamic> body = {
    'titel': titel,
    'beschreibung': beschreibung,
    'kontakt': kontakt,
    'beginn_ts': beginn_ts,
    'ende_ts': ende_ts,
    'ortBeschreibung': ortBeschreibung,
    'latitude': latitude,
    'longitude': longitude,
    'institutionId': institutionId,
    'userId': userId,
    'istGenehmigt': istGenehmigt
  };

  final response = await http.post(Uri.http(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Neue Veranstaltung angelegt");
  } else {
    print(response.statusCode);
  }

  return response;
}

Future<int> testapi() async {
  final response = await http.get(Uri.http('85.214.166.230', 'api/'));
  if (response.statusCode == 200) {
    print("Verbindung erfolgreich");
  }
  return response.statusCode;
}
