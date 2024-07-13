import 'dart:js_interop';

import 'package:transport_app/wrapper/content/content.dart';

class Pattern {
  Pattern(
    this.temp
  );
  List<Disruption> disruptions;
  List<PatternDeparture> departures;
  Map<int, PatternStop> stops;
  Map<int, PatternRoute> routes;
  Map<int, PatternRun> runs;
  Map<int, PatternDirection> directions;
  Status status;
  factory Pattern.fromJson(Map json) => Pattern(
    json["disruptions"]
  );
}