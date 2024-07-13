import 'dart:js_interop';

import 'disruption.dart';
import '../util/datetime.dart';

class Departure {
  Departure(
    this.stopId,
    this.routeId,
    this.runId,
    this.runRef,
    this.directionId,
    this.disruptionIds,
    this.scheduledDeparture,
    this.estimatedDeparture,
    this.atPlatform,
    this.platformNumber,
    this.flags,
    this.departureSequence,
    this.departureNote,
  );
  int stopId;
  int routeId;
  int runId;
  String runRef;
  int directionId;
  JSArray disruptionIds;
  DateTime scheduledDeparture;
  DateTime estimatedDeparture;
  bool atPlatform;
  int platformNumber;
  String flags;
  int departureSequence;
  String departureNote;
  factory Departure.fromJson(Map json) => Departure(
    json['stop_id'],
    json['route_id'],
    json['run_id'],
    json['run_ref'],
    json['direction_id'],
    json['disruption_ids'],
    ptvTimeFormat.parse(json['scheduled_departure_utc'], true).toLocal(),
    ptvTimeFormat.parse(json['estimated_departure_utc'], true).toLocal(),
    json['at_platform'] == "true",
    int.parse(json['platform_number']),
    json['flags'],
    json['departure_sequence'],
    json['departure_note'],
  );
}

class PatternDeparture {
  PatternDeparture(
    this.skippedStops,
    this.stopId,
    this.routeId,
    this.runId,
    this.runRef,
    this.directionId,
    this.disruptionIds,
    this.scheduledDeparture,
    this.estimatedDeparture,
    this.atPlatform,
    this.platformNumber,
    this.flags,
    this.departureSequence,
    this.departureNote,
  );
  JSArray skippedStops;
  int stopId;
  int routeId;
  int runId;
  String runRef;
  int directionId;
  List<Disruption> disruptionIds;
  DateTime scheduledDeparture;
  DateTime estimatedDeparture;
  bool atPlatform;
  int platformNumber;
  String flags;
  int departureSequence;
  String departureNote;
  factory PatternDeparture.fromJson(Map json) => PatternDeparture(
    json['skipped_stops'],
    json['stop_id'],
    json['route_id'],
    json['run_id'],
    json['run_ref'],
    json['direction_id'],
    json['disruption_ids'],
    ptvTimeFormat.parse(json['scheduled_departure_utc'], true).toLocal(),
    ptvTimeFormat.parse(json['estimated_departure_utc'], true).toLocal(),
    json['at_platform'] == "true",
    int.parse(json['platform_number']),
    json['flags'],
    json['departure_sequence'],
    json['departure_note'],
  );
}
