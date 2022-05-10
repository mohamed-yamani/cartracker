import 'package:carlock/model/localisation.dart';
import 'package:carlock/repository/save_get_localisation.dart';
import 'package:print_color/print_color.dart';

class UpdateLocation {
  LocalisationSaveAndGetAndDelete saveAndGetAndDelete =
      LocalisationSaveAndGetAndDelete();

  Future<bool> updateLocation(Localisation newLocalisation) async {
    Localisation? localisation = await saveAndGetAndDelete.getLocalisation();
    if (localisation != null &&
        double.parse(localisation.latitude).toStringAsFixed(5) ==
            double.parse(newLocalisation.latitude).toStringAsFixed(5) &&
        double.parse(localisation.longitude).toStringAsFixed(5) ==
            double.parse(newLocalisation.longitude).toStringAsFixed(5)) {
      Print.red('You are already at this location');
      return false;
    } else {
      await saveAndGetAndDelete.saveLocalisation(
          longitude: newLocalisation.longitude.toString(),
          latitude: newLocalisation.latitude.toString());
      Print.green('Current location Saved with success');
      return true;
    }
  }
}
