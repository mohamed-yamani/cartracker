import 'package:carlock/model/user.dart';

class UtilisateursModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  UtilisateursModel({this.count, this.next, this.previous, this.results});

  UtilisateursModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? ip;
  String? longitude;
  String? latitude;
  bool? ipUp;
  String? lastIpUp;
  String? lastDetectionM;
  String? timestampLastDetectionM;
  String? picture;
  String? streamingUrl;
  String? codeVpn;

  Results(
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
      this.streamingUrl,
      this.codeVpn});

  Results.fromJson(Map<String, dynamic> json) {
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
    codeVpn = json['code_vpn'];
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
    data['code_vpn'] = this.codeVpn;
    return data;
  }
}
