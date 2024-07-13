library ptv;

import 'dart:developer';

import 'content/content.dart' as content;
import 'util/request.dart'as req;
import 'util/urls.dart' as urls;

export 'content/content.dart';

class GetNextDeparture {
  static Future<content.Departure> trainFromStation(String station) async {
  final stopId = content.stopsFromStationName()[station.toLowerCase()];
  if (stopId == null) {
    throw Exception("Station not Valid");
  }
  log("requesting");
  final json = await req.request(urls.Departures.stop(0, stopId), "max_results=1");
  // log("hi " + json.toString());
  // log(json["departures"][0]["distruption_ids"].toString());
  log("requested");
  return content.Departure.fromJson(json["departures"][0]);
  }

  static Future<content.Departure> trainFromStationOnRoute(String station, int routeId) async {
  final stopId = content.stopsFromStationName()[station.toLowerCase()];
  if (stopId == null) {
    throw Exception("Station not Valid");
  }
  return content.Departure.fromJson(await req.request(urls.Departures.route(0, routeId, stopId), "max"));
  }
}