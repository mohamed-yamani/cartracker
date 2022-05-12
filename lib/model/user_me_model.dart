import 'package:hive/hive.dart';

part 'user_me_model.g.dart';

@HiveType(typeId: 5)
class UserMeModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? firstName;
  @HiveField(3)
  String? lastName;
  @HiveField(4)
  String? ip;
  @HiveField(5)
  String? longitude;
  @HiveField(6)
  String? latitude;
  @HiveField(7)
  bool? ipUp;
  @HiveField(8)
  String? lastIpUp;
  @HiveField(9)
  String? lastDetectionM;
  @HiveField(10)
  String? timestampLastDetectionM;
  @HiveField(11)
  String? picture;
  @HiveField(12)
  String? streamingUrl;

  UserMeModel(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.ip,
      this.longitude,
      this.latitude,
      this.ipUp,
      this.lastIpUp,
      this.lastDetectionM,
      this.timestampLastDetectionM,
      this.picture,
      this.streamingUrl});

  UserMeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    ip = json['ip'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    ipUp = json['ip_up'];
    lastIpUp = json['last_ip_up'];
    lastDetectionM = json['last_detection_m'];
    timestampLastDetectionM = json['timestamp_last_detection_m'];
    picture = json['picture'];
    streamingUrl = json['streaming_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['ip'] = this.ip;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['ip_up'] = this.ipUp;
    data['last_ip_up'] = this.lastIpUp;
    data['last_detection_m'] = this.lastDetectionM;
    data['timestamp_last_detection_m'] = this.timestampLastDetectionM;
    data['picture'] = this.picture;
    data['streaming_url'] = this.streamingUrl;
    return data;
  }
}
