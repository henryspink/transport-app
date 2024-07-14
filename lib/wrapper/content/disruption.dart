import 'dart:js_interop';

import 'package:transport_app/wrapper/wrapper.dart';

class Disruption {
  Disruption(
    this.disruptionId,
    this.title,
    this.url,
    this.description,
    this.disruptionStatus,
    this.disruptionType,
    this.publishedOn,
    this.lastUpdated,
    this.from,
    this.to,
    this.routes,
    this.stops,
    this.colour,
    this.displayOnBoard,
    this.displayStatus,
  );

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
  JSArray routes;
  JSArray stops;
  String colour;
  bool displayOnBoard;
  bool displayStatus;

  factory Disruption.fromJson(Map json) => Disruption(
        json['disruptionId'],
        json['title'],
        json['url'],
        json['description'],
        json['disruptionStatus'],
        json['disruptionType'],
        ptvTimeFormat.tryParse(json['published_on']),
        ptvTimeFormat.tryParse(json['last_updated']),
        ptvTimeFormat.tryParse(json['from']),
        ptvTimeFormat.tryParse(json['to']),
        json['routes'],
        json['stops'],
        json['colour'],
        json['displayOnBoard'],
        json['displayStatus'],
      );
}