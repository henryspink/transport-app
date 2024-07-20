library ptv;

import 'dart:developer';

import 'content/content.dart' as content;
import 'util/request.dart'as req;
import 'util/urls.dart' as urls;
import 'exceptions/exceptions.dart';

export 'exceptions/exceptions.dart';
export 'content/content.dart';
export 'util/datetime.dart';
export 'util/urls.dart';
export 'util/request.dart';

class GetNextDeparture {

  /// Get the next train from a station
  /// 
  /// Takes in a station name as a string (case insensitive)
  /// Returns a Departure object of the next train from that station
  static Future<content.Departure?> trainFromStation(String station) async {
    final stopId = content.stopsFromStationName()[station.toLowerCase()];
    if (stopId == null) {
      throw InvalidStationName("$station not is not a valid station");
    }
    log("requesting");
    final json = await req.request(urls.Departures.stop(0, stopId), "max_results=1");
    log("requested");
    if (json['error'] != null) {
      // there is a error
      return null;
    }
    return content.Departure.fromJson(json["departures"][0]);
  }

  /// Get the next train from a station on a route
  /// 
  /// Takes in a station name as a string (case insensitive) and a route id as an int
  /// Returns a Departure object of the next train from that station on that route
  static Future<content.Departure> trainFromStationOnRoute(String station, int routeId) async {
    final stopId = content.stopsFromStationName()[station.toLowerCase()];
    if (stopId == null) {
      throw InvalidStationName("$station not is not a valid station");
    }
    final json = await req.request(urls.Departures.route(0, routeId, stopId), "max_results=1");
    return content.Departure.fromJson(json["departures"][0]);
  }
}

class ServiceFromDeparture {
  static Future<content.Pattern> getTrain(content.Departure departure) async {
    final json = await req.request(urls.patterns(departure.runRef, 0), "expand=All&include_skipped_stops=true&include_advertised_interchange=true&include_geopath=true");
    return content.Pattern.fromJson(json);
  }
}