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
  ServiceStatus? serviceStatus;
  int routeType;
  int routeId;
  String routeName;
  String routeNumber;
  String routeGTFSid;
  Geopath? geopath;
  factory Route.fromJson(Map json) => Route(
    json["service_status"] != null ? ServiceStatus.fromJson(json["service_status"]) : null,
    json["route_type"],
    json["route_id"],
    json["route_name"],
    json["route_number"],
    json["route_gtfs_id"],
    Geopath.fromJson(json["geopath"]),
  );
}
