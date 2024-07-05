const String baseUrl = "https://timetableapi.ptv.vic.gov.au";
const String version = "/v3";

const String healthCheck = "$version/healthCheck";

class Distruptions {
  static const String all = "$version/disruptions";
  String route(int routeId) => "$version/disruptions/route/$routeId";
  String routeAndStop(int routeId, int stopId) => "$version/disruptions/route/$routeId/stop/$stopId";
  String stop(int stopId) => "$version/disruptions/stop/$stopId";
  String id(int disruptionId) => "$version/disruptions/$disruptionId";
  static const String modes = "$version/disruptions/modes";
}

class Departures {
  String stop(int routeType, int stopId) => "$version/departures/route_type/$routeType/stop/$stopId";
  String route(int routeType, int routeId, int stopId) => "$version/departures/route_type/$routeType/stop/$stopId/route/$routeId";
}

class Directions {
  String route(int routeId) => "$version/directions/route/$routeId";
  String direction(int directionId) => "$version/directions/$directionId";
  String type(int directionId, int routeType) => "$version/directions/$directionId/route_type/$routeType";
}

String route(int minZone, int maxZone) => "$version/fare_estimate/min_zone/$minZone/max_zone/$maxZone";

class Outlets {
  static const String all = "$version/outlets";
  String location(int latitude, int longitude) => "$version/outlets/location/$latitude,$longitude";
}

String patterns(int runRef, int routeType) => "$version/pattern/run/$runRef/route_type/$routeType";

class Routes {
  static const String all = "$version/routes";
  String route(int routeId) => "$version/routes/$routeId";
}

const String routeTypes = "$version/route_types";

class Runs {
  String route(int routeId) => "$version/runs/route/$routeId";
  String id(int routeId, int routeType) => "$version/runs/route/$routeId/route_type/$routeType";
  String run(int runRef) => "$version/runs/$runRef";
  String runAndType(int runRef, int routeType) => "$version/runs/$runRef/route_type/$routeType";
}

String search(String term) => "$version/search/$term";

class Stops {
  String stop(int stopId, int routeType) => "$version/stops/$stopId/route_type/$routeType";
  String route(int routeId, int routeType) => "$version/stops/route/$routeId/route_type/$routeType";
  String location(int latitude, int longitude) => "$version/stops/location/$latitude,$longitude";
}
