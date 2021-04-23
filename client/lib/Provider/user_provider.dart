import 'package:aktiv_app_flutter/Models/role_permissions.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  
  static ROLE _role;

  // TODO: Evtl die Rolle über den 

  //  userRole => _role;
  static ROLE getUserRole() {
    return _role;
  }

  void setUserRole(ROLE role) {
    _role = role;
  }

  bool isLoggedIn = false;



}




