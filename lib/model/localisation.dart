import 'package:hive/hive.dart';

part 'localisation.g.dart';

@HiveType(typeId: 4)
class Localisation extends HiveObject {
  @HiveField(0)
  final String longitude;
  @HiveField(1)
  final String latitude;

  Localisation(this.longitude, this.latitude);
}
