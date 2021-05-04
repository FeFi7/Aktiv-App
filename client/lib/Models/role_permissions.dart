import 'package:aktiv_app_flutter/Provider/user_provider.dart';

enum ROLE { NOT_REGISTERED, USER, GENEHMIGER, BETREIBER }
//weighting:0,              1,    2,          3;

extension Permissions on ROLE {

  int getPermissionWeighting() {
    return this.index;
  }
  
  bool get allowedToFavEvents {
    // return getPermissionWeighting() >= ROLE.USER.getPermissionWeighting();
    return UserProvider.istEingeloggt;
  }
}