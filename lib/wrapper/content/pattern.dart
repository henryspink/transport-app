import 'package:transport_app/wrapper/content/content.dart';
class Pattern {
  Pattern(
    this.disruptions,
    this.departures,
    this.stops,
    this.routes,
    this.runs,
    this.directions,
    this.status,
  );
  List<Disruption> disruptions;
  List<PatternDeparture> departures;
  Map<String, PatternStop> stops;
  Map<String, Route> routes;
  Map<String, Run> runs;
  Map<String, Direction> directions;
  Status status;
  factory Pattern.fromJson(Map json) => Pattern(
    json['disruptions'].map<Disruption>((disruption) => Disruption.fromJson(disruption)).toList(),
    json['departures'].map<PatternDeparture>((departure) => PatternDeparture.fromJson(departure)).toList(),
    json['stops'].map<PatternStop>((stop) => PatternStop.fromJson(stop)).toList(),
    json['routes'].map<Route>((route) => Route.fromJson(route)).toList(),
    json['runs'].map<Run>((run) => Run.fromJson(run)).toList(),
    json['directions'].map<Direction>((direction) => Direction.fromJson(direction)).toList(),
    Status.fromJson(json['status']),
  );
}