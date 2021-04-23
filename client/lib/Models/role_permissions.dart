import 'package:flutter/material.dart';

enum ROLE { USER, GENEHMIGER, BETREIBER }


extension RolePermissions on ROLE {

  bool get allowedToLoadNotApprovedEvents {
    switch (this) {
      case ROLE.USER:
        return false;
      case ROLE.GENEHMIGER:
        return false;
      case ROLE.BETREIBER:
        return true;
      default:
        return false;
    }
  }
  
  // void talk() {
  //   print('meow');
  // }
}