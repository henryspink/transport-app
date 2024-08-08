import 'package:transport_app/ptv/content/content.dart';

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
  Map<int, PatternStop> stops;
  Map<int, Route> routes;
  Map<int, Run> runs;
  Map<int, Direction> directions;
  Status status;
  factory Pattern.fromJson(Map json) => Pattern(
    [for (var disruption in json['disruptions']) Disruption.fromJson(disruption)],
    [for (var departure in json['departures']) PatternDeparture.fromJson(departure)],
    {for (var stop in json['stops'].values) stop['stop_id']: PatternStop.fromJson(stop)},
    {for (var route in json['routes'].values) route['route_id']: Route.fromJson(route)},
    {for (var run in json['runs'].values) run['run_id']: Run.fromJson(run)},
    {for (var direction in json['directions'].values) direction['direction_id']: Direction.fromJson(direction)},
    Status.fromJson(json['status']),
  );
}