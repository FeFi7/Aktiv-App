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

/* Future<int> attemptSignUp(String email, String password) async {
  var res = await http.post(Uri.http(SERVER_IP, '/signup'),
      body: {"email": email, "password": password});
  return res.statusCode;
} */

Future<int> testapi() async {
  final response = await http.get(Uri.http('85.214.166.230', 'api/'));
  if (response.statusCode == 200) {
    print("Verbindung erfolgreich");
  }
  return response.statusCode;
}
