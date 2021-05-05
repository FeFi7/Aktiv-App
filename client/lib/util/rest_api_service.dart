import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'compress_service.dart';
import '../util/geo_service.dart';

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
Future<http.Response> attemptSignUp(String mail, String passwort,
    [String rolle = "1"]) async {
  String route = "api/user/signup";
  Map<String, dynamic> body = {
    'mail': mail,
    'passwort': passwort,
    'rolle': rolle
  };

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

DateTime lastGps;
String latitude, longitude;

// [GET] Bekomme alle Veranstaltungen innerhalb eines Zeitraums, Genehmigungsstatus,
// Maximallimit und Page
Future<http.Response> attemptGetAllVeranstaltungen(
    [String bis = "-1",
    String istGenehmigt = "1",
    String limit = "25",
    String page = "1",
    String userId = "-1",
    String vollText = "-1",
    String entfernung = "-1",
    String sorting = "-1",
    String datum = "-1",
    String plz = "-1"]) async {
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

  if (vollText != "-1") {
    qParams.putIfAbsent('vollText', () => vollText);
  }

  if (entfernung != "-1") {
    qParams.putIfAbsent('entfernung', () => entfernung);
  }

  if (sorting != "-1") {
    qParams.putIfAbsent('sorting', () => sorting);
  }

  if (datum != "-1") {
    qParams.putIfAbsent('datum', () => datum);
  }

  if (plz != "-1") {
    qParams.putIfAbsent('plz', () => plz);
  }

  try {
    if (lastGps == null || lastGps.difference(DateTime.now()).inMinutes >= 5) {
      // Frage Standortzugriff User ab und hole Breiten- und Laengengrad fuer Entfernungsberechnung
      List<String> coordinates = await getActualCoordinates();
      if (coordinates != null) {
        latitude = coordinates.first;
        longitude = coordinates.last;
        print('new lat: ' +
            coordinates.first +
            ", longitude: " +
            coordinates.last);
      }

      lastGps = DateTime.now();
    }
    qParams.putIfAbsent('latitude', () => latitude);
    qParams.putIfAbsent('longitude', () => longitude);
  } catch (e) {
    print(e.toString());
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

// Prüfe ob PLZ valide ist
Future<bool> attemptProovePlz(String plz) async {
  print('RestAPI Service : ' + plz);
  var ret = await getCoordinatesFromAddress(plz);
  if (ret == null) {
    return false;
  }
  return true;
}

// [POST] Erstelle neue Veranstaltung
Future<http.Response> attemptCreateVeranstaltung(
    String titel,
    String beschreibung,
    String kontakt,
    String beginnts,
    String endets,
    String ortBeschreibung,
    String plz,
    String userId,
    String istGenehmigt,
    [String institutionId = "-1",
    List<String> fileids = const ["-1"],
    List<String> tags = const ["-1"]]) async {
  String route = "api/veranstaltungen/";

  Map<String, dynamic> body = {
    'titel': titel,
    'beschreibung': beschreibung,
    'kontakt': kontakt,
    'beginn_ts': beginnts,
    'ende_ts': endets,
    'ortBeschreibung': ortBeschreibung,
    'plz': plz,
    'userId': userId,
    'istGenehmigt': istGenehmigt
  };

  // Hole User Koordinaten
  var coordinateList = await getCoordinatesFromAddress(plz);

  if (coordinateList == null) {
    return http.Response("PLZ nicht gefunden", 400);
  }

  var latitude = coordinateList.first;
  var longitude = coordinateList.last;

  body.putIfAbsent('latitude', () => latitude);
  body.putIfAbsent('longitude', () => longitude);

  if (institutionId != "-1") {
    body.putIfAbsent('institutionId', () => institutionId);
  }

  if (fileids.toString() != "[-1]") {
    body.putIfAbsent('fileIds', () => jsonEncode(fileids));
  }

  if (tags.toString() != "[-1]") {
    body.putIfAbsent('tags', () => jsonEncode(tags));
  }

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
  if ((mimetype != 'image/jpeg') &&
      (mimetype != 'image/png') &&
      (mimetype != 'application/pdf')) {
    return http.Response("File types allowed .jpeg, .jpg .png and .pdf!", 500);
  }

  // Komprimiere Bild oder PDF Datei
  var compressedFile;

  if (mimetype == 'application/pdf') {
    compressedFile = await compressPDF(file);
  } else {
    compressedFile = await compressImage(file);
  }

  var _file = await http.MultipartFile.fromPath(
    'file',
    compressedFile.path,
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

  // Komprimiere Bild
  var compressedFile = await compressImage(file);

  var _file = await http.MultipartFile.fromPath(
    'file',
    compressedFile.path,
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
    String strasse,
    String hausnummer,
    String userId,
    String accessToken) async {
  String route = "api/user/" + userId + "/";
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {
    'mail': mail,
    'vorname': vorname,
    'nachname': nachname,
    'plz': plz,
    'tel': tel,
    'strasse': strasse,
    'hausnummer': hausnummer
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

// [POST] User favorisiert Veranstaltung (Beachte TOGGLE Funktion!!)
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

// [GET] Bekomme einzelnes File
Future<http.Response> attemptGetFile(String fileName) async {
  final response = await http.get(Uri.https(SERVER_IP, fileName));

  if (response.statusCode == 200) {
    print("File erfolgreich geholt");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme einzelne Institution
Future<http.Response> attemptGetInstitutionById(String institutionsId) async {
  String route = "api/institutionen/" + institutionsId;

  final response = await http.get(Uri.https(SERVER_IP, route));

  if (response.statusCode == 200) {
    print("Bekomme einzelne Institution erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Hinterlege Profilbild für Institution
Future<http.Response> attemptNewImageForInstitution(
    File file, String institutionId, String accessToken) async {
  String route = "/api/institutionen/" +
      institutionId +
      "/profilbild?secret_token=" +
      accessToken;
  var uri = Uri.parse('https://' + SERVER_IP + route);

  final request = http.MultipartRequest('POST', uri);

  final mimetype = lookupMimeType(file.path);
  if ((mimetype != "image/jpeg") && (mimetype != 'image/png')) {
    return http.Response("File types allowed .jpeg, .jpg and png!", 500);
  }

  // Komprimiere Bild
  var compressedFile = await compressImage(file);

  var _file = await http.MultipartFile.fromPath(
    'file',
    compressedFile.path,
    contentType: MediaType.parse(mimetype),
  );

  request.files.add(_file);
  http.Response response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    print("Hinterlege Profilbild für Institution erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Genehmige einzelne Institution
Future<http.Response> attemptApproveInstitution(
    String institutionId, String accessToken) async {
  String route = "api/institutionen/" + institutionId + "/genehmigen";
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Institution erfolgreich genehmigt");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Erstelle einzelne Institution
Future<http.Response> attemptCreateInstitution(
    String name, String beschreibung, String accessToken) async {
  String route = "api/institutionen";
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  Map<String, dynamic> body = {'name': name, 'beschreibung': beschreibung};

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Institution erfolgreich erstellt");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [PUT] Update einzelne Institution
Future<http.Response> attemptUpdateInstitution(String institutionId,
    String name, String beschreibung, String accessToken) async {
  String route = "api/institutionen/" + institutionId;
  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {'name': name, 'beschreibung': beschreibung};

  final response = await http.put(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Institution erfolgreich geupdatet");
  } else {
    print(response.statusCode);
    print(response.body);
  }

  return response;
}

// [DELETE] Lösche einzelne Institution
Future<http.Response> attemptDeleteInstitution(
    String institutionId, String accessToken) async {
  String route = "api/institutionen/" + institutionId;
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.delete(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Institution erfolgreich gelöscht");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme alle verwalteten Institutionen von User
Future<http.Response> attemptGetVerwalteteInstitutionen(
    String userId, String accessToken) async {
  String route = "api/user/" + userId + "/institutionen";
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.get(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("Verwaltene Institutionen erfolgreich bekommen");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Genehmige einzelne Veranstaltung
Future<http.Response> attemptApproveVeranstaltung(
    String veranstaltungId, String accessToken) async {
  String route = "api/veranstaltungen/" + veranstaltungId + "/genehmigen";
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Veranstaltung erfolgreich genehmigt");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [DELETE] Lösche einzelne Veranstaltung
Future<http.Response> attemptDeleteVeranstaltung(
    String veranstaltungId, String accessToken) async {
  String route = "api/veranstaltungen/" + veranstaltungId;
  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.delete(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Veranstaltung erfolgreich gelöscht");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme tags (optional gefiltert)
Future<http.Response> attemptGetTags([String tag = "[-1]"]) async {
  String route = "api/veranstaltungen/tags";
  Map<String, dynamic> qParams;

  if (tag != "[-1]") {
    qParams.putIfAbsent('tag', () => tag);
  }

  final response = await http.get(Uri.https(SERVER_IP, route, qParams));

  if (response.statusCode == 200) {
    print("Bekomme tags erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [DELETE] Lösche Verknüpfung von User mit Institution als Verwalter
Future<http.Response> attemptDeleteVerwalter(
    String userId, String institutionId, String accessToken) async {
  String route = "api/user/" + userId + "/institutionen/" + institutionId;

  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.delete(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print(
        "Verbindung zwischen User als Verwalter und Institution erfolgreich gelöscht");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [DELETE] Lösche User (nur als Betreiber möglich)
Future<http.Response> attemptDeleteUser(
    String userId, String accessToken) async {
  String route = "api/user/" + userId;

  Map<String, dynamic> qParams = {'secret_token': accessToken};

  final response = await http.delete(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: {},
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("User erfolgreich gelöscht");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [POST] Generiere Verbindung von Genehmiger zu PLZs
Future<http.Response> attemptSetGenehmiger(
    String userId, List<String> plz, String accessToken) async {
  String route = "api/user/" + userId + "/genehmigung";

  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {};

  body.putIfAbsent('plz', () => plz.toString());

  final response = await http.post(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Genehmiger erfolgreich gesetzt für " + body.toString());
  } else {
    print(response.statusCode);
  }

  return response;
}

// [DELETE] Generiere Verbindung von Genehmiger zu PLZs
Future<http.Response> attemptRemoveGenehmiger(
    String userId, List<String> plz, String accessToken) async {
  String route = "api/user/" + userId + "/genehmigung";

  Map<String, dynamic> qParams = {'secret_token': accessToken};
  Map<String, dynamic> body = {};

  body.putIfAbsent('plz', () => plz.toString());

  final response = await http.delete(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    print("Genehmiger erfolgreich entfernt " + body.toString());
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme verwaltene PLZs von Genehmiger
Future<http.Response> attemptGetPLZs(String userId) async {
  String route = "api/user/" + userId + "/genehmigung";

  final response = await http.get(Uri.https(SERVER_IP, route));

  if (response.statusCode == 200) {
    print("Bekomme verwaltene PLZs erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme alle favorisierten Veranstaltungen
Future<http.Response> attemptGetFavorite(
    String userId, String accessToken, String limit, String page) async {
  String route = "api/user/" + userId + "/favorit";
  Map<String, dynamic> qParams = {
    'secret_token': accessToken,
    'limit': limit,
    'page': page
  };

  final response = await http.get(Uri.https(SERVER_IP, route, qParams));

  if (response.statusCode == 200) {
    print("Verbindung erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

// [GET] Bekomme alle ungenehmigten Institutionen
Future<http.Response> attemptGetUngenehmigteInstitutionen(
    String accessToken) async {
  Map<String, dynamic> qParams = {
    'secret_token': accessToken,
  };
  String route = "api/institutionen/ungenehmigt";

  final response = await http.get(Uri.https(SERVER_IP, route, qParams),
      headers: <String, String>{
        'Content-Type': "application/x-www-form-urlencoded"
      });

  if (response.statusCode == 200) {
    print("GET All Institutionen erfolgreich");
  } else {
    print(response.statusCode);
  }

  return response;
}

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
