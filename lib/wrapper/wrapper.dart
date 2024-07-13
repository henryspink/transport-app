library ptv;

import 'dart:developer';

import 'content/content.dart' as content;
import 'util/request.dart'as req;
import 'util/urls.dart' as urls;

export 'content/content.dart';
export 'util/datetime.dart';

class GetNextDeparture {
  static Future<content.Departure> trainFromStation(String station) async {
    final stopId = content.stopsFromStationName()[station.toLowerCase()];
    if (stopId == null) {
      throw Exception("Station not Valid");
    }
    log("requesting");
    final json = await req.request(urls.Departures.stop(0, stopId), "max_results=1");
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

class ServiceFromDeparture {
  static Future<content.Pattern> getTrain(content.Departure departure) async {
    final json = await req.request(urls.patterns(departure.runRef, 0), "expand=All&include_skipped_stops=true&include_advertised_interchange=true&include_geopath=true");
    return content.Pattern.fromJson(json);
  }
}