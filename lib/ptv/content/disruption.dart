// import 'dart:js_interop';
// import 'dart:developer';

import 'package:transport_app/ptv/wrapper.dart';

class Disruption {
  Disruption({
    required this.disruptionId,
    required this.title,
    required this.url,
    required this.description,
    required this.disruptionStatus,
    required this.disruptionType,
    required this.publishedOn,
    required this.lastUpdated,
    required this.from,
    required this.to,
    required this.routes,
    required this.stops,
    required this.colour,
    required this.displayOnBoard,
    required this.displayStatus,
  });
  int disruptionId;
  String title;
  String url;
  String description;
  String disruptionStatus;
  String disruptionType;
  DateTime? publishedOn;
  DateTime? lastUpdated;
  DateTime? from;
  DateTime? to;
  List routes;
  List stops;
  String colour;
  bool displayOnBoard;
  bool displayStatus;
  factory Disruption.fromJson(Map json) => Disruption(
    disruptionId:     json['disruption_id'],
    title:            json['title'],
    url:              json['url'],
    description:      json['description'],
    disruptionStatus: json['disruption_status'],
    disruptionType:   json['disruption_type'],
    publishedOn:      parseTime(json['published_on']),
    lastUpdated:      parseTime(json['last_updated']),
    from:             parseTime(json['from']),
    to:               parseTime(json['to']),
    routes:           json['routes'],
    stops:            json['stops'],
    colour:           json['colour'],
    displayOnBoard:   json['display_on_board'],
    displayStatus:    json['display_status'],
  );
}