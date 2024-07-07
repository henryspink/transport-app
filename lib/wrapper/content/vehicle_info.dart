class VehiclePosition {
  VehiclePosition(
    this.latitude,
    this.longitude,
    this.easting,
    this.northing,
    this.direction,
    this.bearing,
    this.supplier,
    this.datetimeUtc,
    this.expiryTime,
  );
  int latitude;
  int longitude;
  int easting;
  int northing;
  String direction;
  int bearing;
  String supplier;
  String datetimeUtc;
  String expiryTime;
  factory VehiclePosition.fromJson(json) => VehiclePosition(
      json['latitude'],
      json['longitude'],
      json['easting'],
      json['northing'],
      json['direction'],
      json['bearing'],
      json['supplier'],
      json['datetime_utc'],
      json['expiry_time'],
  );
}

class VehicleDescriptor {
  VehicleDescriptor(
    this.operator,
    this.id,
    this.lowFloor,
    this.airConditioned,
    this.description,
    this.supplier,
    this.length,
  );
  String operator;
  String id;
  bool lowFloor;
  bool airConditioned;
  String description;
  String supplier;
  String length;
  factory VehicleDescriptor.fromJson(json) => VehicleDescriptor(
    json['operator'],
    json['id'],
    json['low_floor'],
    json['air_conditioned'],
    json['description'],
    json['supplier'],
    json['length'],
  );
}