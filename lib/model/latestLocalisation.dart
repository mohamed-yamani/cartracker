import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class LatestLocalisation {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? longitude;
  @HiveField(2)
  String? latitude;

  LatestLocalisation({this.id, this.longitude, this.latitude});

  LatestLocalisation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
