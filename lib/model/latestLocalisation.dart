class LatestLocalisation {
    int ? id;
    String ? longitude;
    String ? latitude;

    LatestLocalisation({ this.id, this.longitude, this.latitude });

    LatestLocalisation.fromJson(Map < String, dynamic > json) {
        id = json['id'];
        longitude = json['longitude'];
        latitude = json['latitude'];
    }

    Map < String, dynamic > toJson() {
        final Map < String, dynamic > data = new Map < String, dynamic > ();
        data['id'] = this.id;
        data['longitude'] = this.longitude;
        data['latitude'] = this.latitude;
        return data;
    }
}
