import 'package:carlock/constants/enums.dart';
import 'package:carlock/model/localisation.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:print_color/print_color.dart';

const locastionBox = 'localisationBox';

class LocalisationSaveAndGetAndDelete {
  Future<void> saveLocalisation(
      {@required String? longitude, @required String? latitude}) async {
    await Hive.openBox(locastionBox);
    var box = Hive.box(locastionBox);
    box.put('longitude', longitude);
    box.put('latitude', latitude);
    Print.yellow('Localisation saved');
  }

  Future<Localisation?> getLocalisation() async {
    await Hive.openBox(locastionBox);
    var box = Hive.box(locastionBox);
    try {
      return Localisation(box.get('longitude'), box.get('latitude'));
    } catch (e) {
      Print.yellow('Failed to get localisation');
      Exception(e.toString());
    }
    return null;
  }

  Future<void> deleteLocalisation() async {
    await Hive.openBox(locastionBox);
    var box = Hive.box(locastionBox);
    box.delete('longitude');
    box.delete('latitude');
  }
}
