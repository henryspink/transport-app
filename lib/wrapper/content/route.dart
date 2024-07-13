import 'status.dart';
import 'geopath.dart';

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
