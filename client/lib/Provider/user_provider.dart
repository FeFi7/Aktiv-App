import 'dart:convert';
import 'dart:io';

import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:aktiv_app_flutter/util/secure_storage_service.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  static ROLE _role = ROLE
      .NOT_REGISTERED; // Brauchte eine Standard Rolle, sorry wens dir was zerschießt, lg Niko
  final SecureStorage storage = SecureStorage();

  static int userId = -1;
  int plz, hausnummer, bald, naehe;
  String mail,
      vorname,
      nachname,
      tel,
      strasse,
      ort,
      accessToken,
      refreshToken,
      institutionen,
      rolle,
      profilBild;
  static bool istEingeloggt = false, datenVollstaendig = false;

  // TODO: Evtl die Rolle über den

  //  userRole => _role;
  static ROLE getUserRole() {
    return _role;
  }

  void setUserRole(ROLE role) {
    _role = role;
  }

  login<Response>(String mail, password) async {
    var jwt = await attemptLogIn(mail, password);

    if (jwt.statusCode == 200) {
      var parsedJson = json.decode(jwt.body);
      istEingeloggt = true;

      var userId = parsedJson['id'];
      var accessToken = parsedJson['accessToken'];
      var refreshToken = parsedJson['refreshToken'];

      if (jwt != null) {
        storage.deleteAll();
        storage.write("userId", userId.toString());
        storage.write("accessToken", accessToken);
        storage.write("refreshToken", refreshToken);
        storage.write("accessTokenTs", DateTime.now().toString());
      }
      collectUserInfo(parsedJson['id'], accessToken);
    }

    return jwt;
  }

  collectUserInfo(var id, var accessToken) async {
    var detailedUserInfo = await attemptGetUserInfo(id.toString(), accessToken);
    print("detailed User Info: " + detailedUserInfo.body);

    var parsedUser = json.decode(detailedUserInfo.body);

    userId = parsedUser['id'];
    if (parsedUser['plz'] != null && parsedUser['plz'] != "null") {
      plz = int.parse(parsedUser['plz']);
    }
    //hausnummer = parsedUser['hausnummer'];
    tel = parsedUser['tel'];
    bald = parsedUser['baldEinstellung'];
    naehe = parsedUser['umkreisEinstellung'];

    mail = parsedUser['mail'];
    vorname = parsedUser['vorname'];
    nachname = parsedUser['nachname'];
    //strasse = parsedUser['strasse'];
    ort = parsedUser['ort'];
    //institutionen = parsedUser['institutionen'];
    rolle = parsedUser['rolle'];
    profilBild = parsedUser['profilbild'];
    datenVollstaendig = checkDataCompletion();
  }

  getAccessToken() async {
    var _accessToken = await storage.read('accessToken');
    if (_accessToken != null) {
      DateTime accessTokenTs =
          DateTime.parse(await storage.read('accessTokenTs'));
      if (DateTime.now().difference(accessTokenTs).inMinutes >= 30) {
        var jwt =
            await attemptNewAccessToken(await storage.read('refreshToken'));
        var parsedToken = json.decode(jwt.body);
        accessToken = parsedToken['accessToken'];
        refreshToken = parsedToken['refreshToken'];

        storage.write("accessToken", accessToken);
        storage.write("refreshToken", refreshToken);
        storage.write("accessTokenTs", DateTime.now().toString());

        return accessToken;
      }
    }
    return await storage.read('accessToken');
  }

  getUserIdFromStorage() async {
    var _userId = await storage.read('userId');
    if (_userId != null) {
      getAccessToken();
      return _userId;
    }
    return null;
  }

  signInWithToken() async {
    var userId = await storage.read("userId");
    var accessToken = await getAccessToken();

    await collectUserInfo(int.parse(userId), accessToken);
  }

  signOff() async {
    istEingeloggt = false;
    await storage.deleteAll();
  }

  updateUserInfo<Response>(
      String vorname, String nachname, String plz, String tel) async {
    var jwt = await attemptUpdateUserInfo(
        mail.toString(),
        vorname.toString(),
        nachname.toString(),
        plz.toString(),
        tel.toString(),
        userId.toString(),
        await getAccessToken());
    var accessToken = await storage.read('accessToken');
    await collectUserInfo(userId, accessToken);

    notifyListeners();
    return jwt;
  }

  updateUserSettings(String naehe, String bald) async {
    var jwt = await attemptUpdateSettings(
        userId.toString(), await getAccessToken(), naehe, bald);
    collectUserInfo(userId.toString(), await getAccessToken());
    notifyListeners();
    return jwt;
  }

  changeProfileImage(File file) async {
    var jwt = await attemptNewProfilImage(file.path, file, userId.toString());
    var parsedProfilBild = json.decode(jwt.body);
    profilBild = parsedProfilBild['pfad'];
    notifyListeners();
    return jwt;
  }

  loadProfileImage() async {
    var jwt = await attemptGetFile(profilBild);
    notifyListeners();
    return jwt;
  }

  setRole(String mail, String rolle) async {
    switch (rolle) {
      case "user":
        rolle = "1";
        break;
      case "genehmiger":
        rolle = "2";
        break;
      case "betreiber":
        rolle = "3";
        break;
      default:
        rolle = "1";
    }
    var user = await attemptGetUser(mail);
    var parsedUser = json.decode(user.body);
    var _map = parsedUser.values.toList();
    if (_map[0] != false) {
      var _verwalterId = _map[1]['id'].toString();

      var jwt =
          await attemptUpdateRole(_verwalterId, rolle, await getAccessToken());
      notifyListeners();
      return jwt;
    }
    return null;
  }

  setVerwalter(String mail, String institutionsId) async {
    var verwalter = await attemptGetUser(mail);
    var parsedVerwalter = json.decode(verwalter.body);
    var _map = parsedVerwalter.values.toList();
    if (_map[0] != false) {
      var _userId = _map[1]['id'].toString();

      //## derzeit keine Institutionen vorhanden ##//
      //TODO
      // var jwt = await attemptSetVerwalter(
      //     _userId, institutionsId, await getAccessToken());
      // return jwt;
      //###########################################//
    }
    return null;
  }

  checkDataCompletion() {
    if (vorname != null &&
        nachname != null &&
        tel != null &&
        strasse != null &&
        hausnummer != null &&
        plz != null &&
        ort != null)
      datenVollstaendig = true;
    else
      datenVollstaendig = false;
  }
}
