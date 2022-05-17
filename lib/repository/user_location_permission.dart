import 'package:carlock/repository/api_permission_repo.dart';
import 'package:print_color/print_color.dart';

class UserPermissionsRepository {
  Future<bool> canSyncLocation() async {
    bool canSyncLocation = false;
    List<dynamic> permissionList;
    try {
      permissionList = await PermisionRepository().getPermissionRepo();
    } catch (e) {
      throw '$e';
    }
    Print.yellow(permissionList.toString());
    permissionList.forEach((element) {
      Print.yellow(element.toString());
      if (element['code'] == 'can_sync_location') {
        canSyncLocation = true;
      }
    });
    return canSyncLocation;
  }

  Future<bool> canViewAllUsers() async {
    bool canViewAllUsers = false;
    List<dynamic> permissionList;
    try {
      permissionList = await PermisionRepository().getPermissionRepo();
    } catch (e) {
      throw '$e';
    }
    Print.yellow(permissionList.toString());
    permissionList.forEach((element) {
      Print.yellow(element.toString());
      if (element['code'] == 'can_view_all_user') {
        canViewAllUsers = true;
      }
    });
    return canViewAllUsers;
  }
}
