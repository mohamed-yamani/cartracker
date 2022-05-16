class MatchesModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  MatchesModel({this.count, this.next, this.previous, this.results});

  MatchesModel.fromJson(Map<String, dynamic> json) {
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
  String? matriculeStr;
  int? user;
  String? longitude;
  String? latitude;
  String? picture;
  String? createdAt;
  String? userFirstName;
  String? userLastName;
  String? userPicture;

  Results(
      {this.id,
      this.matriculeStr,
      this.user,
      this.longitude,
      this.latitude,
      this.picture,
      this.createdAt,
      this.userFirstName,
      this.userLastName,
      this.userPicture});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matriculeStr = json['matricule_str'];
    user = json['user'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    picture = json['picture'];
    createdAt = json['created_at'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userPicture = json['user_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matricule_str'] = this.matriculeStr;
    data['user'] = this.user;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['picture'] = this.picture;
    data['created_at'] = this.createdAt;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_picture'] = this.userPicture;
    return data;
  }
}
