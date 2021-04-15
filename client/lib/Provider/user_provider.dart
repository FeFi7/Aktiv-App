import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  ROLE role;
  bool isLoggedIn = false;
}

enum ROLE { USER, GENEHMIGER, BETREIBER }
