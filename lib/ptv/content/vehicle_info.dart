import 'package:transport_app/ptv/util/datetime.dart';

class VehiclePosition {
  VehiclePosition(
    this.latitude,
    this.longitude,
    this.easting,
    this.northing,
    this.direction,
    this.bearing,
    this.supplier,
    this.time,
    this.expiry,
  );
  double latitude;
  double longitude;
  double easting;
  double northing;
  String direction;
  double bearing;
  String supplier;
  DateTime? time;
  DateTime? expiry;
  factory VehiclePosition.fromJson(json) => VehiclePosition(
    json['latitude'],
    json['longitude'],
    json['easting'],
    json['northing'],
    json['direction'],
    json['bearing'],
    json['supplier'],
    parseTime(json['datetime_utc']),
    parseTime(json['expiry_time']),
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
  bool? lowFloor;
  bool? airConditioned;
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