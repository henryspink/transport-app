import 'dart:js_interop';

import 'ticket.dart';
import  'interchange.dart';

class Stop {
  Stop(
    this.disruptionIds,
    this.stopSuburb,
    this.routeType,
    this.stopLatitude,
    this.stopLongitude,
    this.stopSequence,
    this.stopTicket,
    this.interchange,
    this.stopId,
    this.stopName,
    this.stopLandmark,
  );
  JSArray disruptionIds;
  String stopSuburb;
  int routeType;
  double stopLatitude;
  double stopLongitude;
  int stopSequence;
  TicketInfo stopTicket;
  Interchange interchange;
  int stopId;
  String stopName;
  String stopLandmark;
  factory Stop.fromJson(Map json) => Stop(
    json['disruptionIds'],
    json['stopSuburb'],
    json['routeType'],
    json['stopLatitude'],
    json['stopLongitude'],
    json['stopSequence'],
    TicketInfo.fromJson(json['stopTicket']),
    Interchange.fromJson(json['interchange']),
    json['stopId'],
    json['stopName'],
    json['stopLandmark'],
  );
}

class PatternStop {
  PatternStop(
    this.stopTicket,
    this.stopDistance,
    this.stopSuburb,
    this.stopName,
    this.stopId,
    this.routeType,
    this.stopLatitude,
    this.stopLongitude,
    this.stopLandmark,
    this.stopSequence
    );
  TicketInfo stopTicket;
  int stopDistance;
  String stopSuburb;
  String stopName;
  int stopId;
  int routeType;
  double stopLatitude;
  double stopLongitude;
  String stopLandmark;
  int stopSequence;
  factory PatternStop.fromJson(Map json) => PatternStop(
    TicketInfo.fromJson(json["stop_ticket"]),
    json["stop_distance"],
    json["stop_suburb"],
    json["stop_name"],
    json["stop_id"],
    json["route_type"],
    json["stop_latitude"],
    json["stop_longitude"],
    json["stop_landmark"],
    json["stop_sequence"],
  );
}

Map<String, int> stopsFromStationName() {
  Map<String, int> stops = {};
  stops["laburnum"] = 1111;
  return stops;
}