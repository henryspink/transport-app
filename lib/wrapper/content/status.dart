class Status {
  String version;
  int health;
  Status(this.version, this.health);
  factory Status.fromJson(json) => Status(json['version'], json['health']);
}

class ServiceStatus {
  ServiceStatus(
    this.description,
    this.timestamp
  );
  String description;
  DateTime? timestamp;
  factory ServiceStatus.fromJson(Map json) => ServiceStatus(
    json["description"],
    DateTime.tryParse(json["timestamp"])
    );
}
