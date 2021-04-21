import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

//const SERVER_IP = "85.214.166.230";
const SERVER_IP = "app.lebensqualitaet-burgrieden.de";

// [POST] Login User
Future<http.Response> attemptLogIn(String mail, String passwort) async {
  String route = "api/user/login";
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

  if (mail.isNotEmpty && passwort.isNotEmpty) {
    final response = await http.post(Uri.https(SERVER_IP, route),
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

// [POST] Registriere neuen User
Future<http.Response> attemptSignUp(String mail, String passwort) async {
  String route = "api/user/signup";
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

  if (mail.isNotEmpty && passwort.isNotEmpty) {
    final response = await http.post(Uri.https(SERVER_IP, route),
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

// [POST] Generiere neuen AccessToken mithilfe des RefreshToken
Future<http.Response> attemptNewAccessToken(String refreshToken) async {
  String route = "api/user/token";
  Map<String, dynamic> body = {'token': refreshToken};

  final response = await http.post(Uri.https(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Neuer AccessToken und RefreshToken generiert");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme Daten eines einzelnen User
Future<http.Response> attemptGetUser(String mail) async {
  String route = "api/user";
  Map<String, dynamic> qParams = {'mail': mail};

  final response = await http.get(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET User erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme einzelne Veranstaltung mithilfe von VeranstaltungsId
Future<http.Response> attemptGetVeranstaltungByID(int veranstaltungsId) async {
  String route = "api/veranstaltungen/" + veranstaltungsId.toString();

  final response = await http.get(Uri.https(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET Veranstaltung erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [DELETE] Lösche einzelne Veranstaltung mithilfe von VeranstaltungsId
Future<http.Response> attemptDeleteVeranstaltung(int veranstaltungsId) async {
  String route = "api/veranstaltungen" + veranstaltungsId.toString();

  final response = await http.delete(Uri.https(SERVER_IP, route),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"));

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
//
// [GET] Bekomme alle Veranstaltungen innerhalb eines Zeitraums, Genehmigungsstatus,
// Maximallimit und Page
Future<http.Response> attemptGetAllVeranstaltungen(
    [String bis = "-1",
    String istGenehmigt = "1",
    String limit = "25",
    String page = "1",
    String userId = "-1"]) async {
  Map<String, dynamic> qParams = {
    'istGenehmigt': istGenehmigt,
    'limit': limit,
    'page': page
  };

  if (bis != "-1") {
    qParams.putIfAbsent('bis', () => bis);
  }
  if (userId != "-1") {
    qParams.putIfAbsent('userId', () => userId);
  }

  String route = "api/veranstaltungen";

  final response = await http.get(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET All Veranstaltungen erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

Future<http.Response> attemptCreateVeranstaltung(
    String titel,
    String beschreibung,
    String kontakt,
    String beginnts,
    String endets,
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
    'beginn_ts': beginnts,
    'ende_ts': endets,
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

// [POST] File Upload für Bilder- und PDF-Dateien des Users
Future<http.Response> attemptFileUpload(String filename, File file) async {
  final uri = Uri.parse('https://' + SERVER_IP + '/api/fileupload');
  final request = http.MultipartRequest('POST', uri);

  final mimetype = lookupMimeType(file.path);
  if ((mimetype != "image/jpeg") &&
      (mimetype != 'image/png') &&
      (mimetype != 'application/pdf')) {
    return http.Response("File types allowed .jpeg, .jpg .png and .pdf!", 500);
  }

  var _file = await http.MultipartFile.fromPath(
    'file',
    file.path,
    contentType: MediaType.parse(mimetype),
  );

  request.files.add(_file);
  http.Response response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    print("FileUpload erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Profilbild für User hinterlegen
Future<http.Response> attemptNewProfilImage(
    String filename, File file, String userId) async {
  String route = '/api/user/' + userId + '/profilbild';
  var uri = Uri.parse('https://' + SERVER_IP + route);
  final request = http.MultipartRequest('POST', uri);

  final mimetype = lookupMimeType(file.path);
  if ((mimetype != "image/jpeg") && (mimetype != 'image/png')) {
    return http.Response("File types allowed .jpeg, .jpg and png!", 500);
  }

  var _file = await http.MultipartFile.fromPath(
    'file',
    file.path,
    contentType: MediaType.parse(mimetype),
  );

  request.files.add(_file);
  http.Response response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    print("Neues Profilbild erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme User Info mit AccessToken
Future<http.Response> attemptGetUserInfo(
    String userId, String accessToken) async {
  String route = "api/user/" + userId;
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.get(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("Userinfo erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [PUT] User Informationen werden erweitert/erneuert
Future<http.Response> attemptUpdateUserInfo(
    String mail,
    String vorname,
    String nachname,
    String plz,
    String tel,
    String userId,
    String accessToken) async {
  String route = "api/user/" + userId + "/";
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {
    'mail': mail,
    'vorname': vorname,
    'nachname': nachname,
    'plz': plz,
    'tel': tel
  };

  final response = await http.put(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Datensatz erfolgreich geändert");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] User favorisiert Veranstaltung (Beachte TOGGLE Funktion!!)
Future<http.Response> attemptFavor(
    String userId, String veranstaltungId, String accessToken) async {
  String route = "api/user/" + userId + "/favorit/";
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {
    'veranstaltungId': veranstaltungId,
  };

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Favorisierung erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [PUT] Update User Einstellungen
Future<http.Response> attemptUpdateSettings(
    String userId, String accessToken, String umkreis, String bald) async {
  String route = "api/user/" + userId + "/einstellungen";
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {
    'umkreisEinstellung': umkreis,
    'baldEinstellung': bald
  };

  final response = await http.put(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Usereinstellungen erfolgreich ");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [PUT] Update User Rolle
Future<http.Response> attemptUpdateRole(
    String userId, String rolleId, String accessToken) async {
  String route = "api/user/" + userId + "/rolle";
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {'rolleId': rolleId};

  final response = await http.put(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Userrolle erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Verknüpfung User mit Institution als Verwalter
Future<http.Response> attemptSetVerwalter(
    String userId, String institutionsId, String accessToken) async {
  String route = "api/user/" + userId + "/institutionen/" + institutionsId;
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Verknüpfung Verwalter - Institution erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme einzelne Institution
Future<http.Response> attemptGetInstitutionById(String institutionsId) async {}

// [PUT] Update eine Institution
Future<http.Response> attemptUpdateInstitution() async {}

// [DELETE] Lösche eine Institution
Future<http.Response> attemptDeleteInstitution() async {}

// [GET] Bekomme alle Institutionen
Future<http.Response> attemptGetAllInstitutionen() async {}

// [POST] Erstelle eine Institution
Future<http.Response> attemptCreateInstitution() async {}

// [GET] TEST API
Future<http.Response> testapi() async {
  final response = await http.get(
    Uri.https('85.214.166.230', 'api/'),
    headers: <String, String>{
      'Content-Type': "application/x-www-form-urlencoded"
    },
  );

  if (response.statusCode == 200) {
    print("Verbindung erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}
