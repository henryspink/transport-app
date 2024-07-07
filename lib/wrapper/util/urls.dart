const String baseUrl = "https://timetableapi.ptv.vic.gov.au";
const String version = "/v3";

const String healthCheck = "$version/healthCheck";

class Distruptions {
  static const String all = "$version/disruptions";
  static String route(int routeId) => "$version/disruptions/route/$routeId";
  static String routeAndStop(int routeId, int stopId) => "$version/disruptions/route/$routeId/stop/$stopId";
  static String stop(int stopId) => "$version/disruptions/stop/$stopId";
  static id(int disruptionId) => "$version/disruptions/$disruptionId";
  static const String modes = "$version/disruptions/modes";
}

class Departures {
  static stop(int routeType, int stopId) => "$version/departures/route_type/$routeType/stop/$stopId";
  static route(int routeType, int routeId, int stopId) => "$version/departures/route_type/$routeType/stop/$stopId/route/$routeId";
}

class Directions {
  static route(int routeId) => "$version/directions/route/$routeId";
  static direction(int directionId) => "$version/directions/$directionId";
  static type(int directionId, int routeType) => "$version/directions/$directionId/route_type/$routeType";
}

String route(int minZone, int maxZone) => "$version/fare_estimate/min_zone/$minZone/max_zone/$maxZone";

class Outlets {
  static const String all = "$version/outlets";
  static location(int latitude, int longitude) => "$version/outlets/location/$latitude,$longitude";
}

String patterns(String runRef, int routeType) => "$version/pattern/run/$runRef/route_type/$routeType";

class Routes {
  static const String all = "$version/routes";
  static route(int routeId) => "$version/routes/$routeId";
}

const String routeTypes = "$version/route_types";

class Runs {
  static route(int routeId) => "$version/runs/route/$routeId";
  static id(int routeId, int routeType) => "$version/runs/route/$routeId/route_type/$routeType";
  static run(String runRef) => "$version/runs/$runRef";
  static runAndType(String runRef, int routeType) => "$version/runs/$runRef/route_type/$routeType";
}

String search(String term) => "$version/search/$term";

class Stops {
  static stop(int stopId, int routeType) => "$version/stops/$stopId/route_type/$routeType";
  static route(int routeId, int routeType) => "$version/stops/route/$routeId/route_type/$routeType";
  static location(int latitude, int longitude) => "$version/stops/location/$latitude,$longitude";
}
