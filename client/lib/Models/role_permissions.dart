import 'package:flutter/material.dart';

enum ROLE { NOT_REGISTERED, USER, GENEHMIGER, BETREIBER }
//weighting:0,              1,    2,          3;

extension Permissions on ROLE {

  int getPermissionWeighting() {
    return this.index;
  }
  
  bool get allowedToFavEvents {
    return getPermissionWeighting() > 0;
  }
}