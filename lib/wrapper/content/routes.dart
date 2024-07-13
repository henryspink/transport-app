import 'status.dart';
import 'runs.dart';

class Route {
  Route(
    this.serviceStatus,
    this.routeType,
    this.routeId,
    this.routeName,
    this.routeNumber,
    this.routeGTFSid,
    this.geopath,
  );
  ServiceStatus serviceStatus;
  int routeType;
  int routeId;
  String routeName;
  String routeNumber;
  String routeGTFSid;
  Geopath geopath;
  factory Route.fromJson(Map json) => Route(
    ServiceStatus.fromJson(json["serviceStatus"]),
    json["routeType"],
    json["routeId"],
    json["routeName"],
    json["routeNumber"],
    json["routeGTFSid"],
    Geopath.fromJson(json["geopath"]),
  );
}

class Routes {
  Routes(this.routes);
  List<Route> routes;
  factory Routes.fromJson(Map json) => Routes(List<Route>.generate(json['routes'].length, (i) => Route.fromJson(json['routes'][i])));
}