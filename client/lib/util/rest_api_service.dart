import 'package:http/http.dart' as http;
import 'dart:convert';

const SERVER_IP = "85.214.166.230";

Future<String> attemptLogIn(String mail, String passwort) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

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

  return response.body;
}

Future<String> attemptSignUpWithPLZ(
    String mail, String passwort, String plz) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort, 'plz': plz};

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

  print(response.body);

  return response.body;
}

Future<String> attemptSignUp(String mail, String passwort) async {
  Map<String, dynamic> body = {'mail': mail, 'passwort': passwort};

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

  print(response.body);

  return response.body;
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

Future<int> attemptFileUpload() async {}

Future<String> attemptCreateVeranstaltung() async {}

Future<String> attemptGetAllVeranstaltungen() async {}

Future<int> testapi() async {
  final response = await http.get(Uri.http('85.214.166.230', 'api/'));
  if (response.statusCode == 200) {
    print("Verbindung erfolgreich");
  }
  return response.statusCode;
}
