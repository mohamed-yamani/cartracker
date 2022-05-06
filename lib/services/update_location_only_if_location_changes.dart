import 'package:carlock/model/localisation.dart';
import 'package:carlock/repository/update_location.dart';

class UpdateLocationOnlyIfLocationChanges {
  UpdateLocationOnlyIfLocationChanges();

  UpdateLocation updateLocation = UpdateLocation();

  Future<bool> handleLocationUpdate(Localisation newLocalisation) {
    return updateLocation.updateLocation(newLocalisation);
  }
}
