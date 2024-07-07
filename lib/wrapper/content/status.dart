class Status {
  String version;
  int health;
  Status(this.version, this.health);
  factory Status.fromJson(json) => Status(json['version'], json['health']);
}