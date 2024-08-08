// import 'status.dart';
import 'vehicle_info.dart';
import 'geopath.dart';
import 'interchange.dart';

class Run {
  Run(
    this.runId,
    this.runRef,
    this.routeId,
    this.routeType,
    this.finalStopId,
    this.destinationName,
    this.status,
    this.directionId,
    this.runSequence,
    this.expressStopCount,
    this.vehiclePosition,
    this.vehicleDescriptor,
    this.geopath,
    this.interchange,
    this.runNote,
  );
  int runId;
  String runRef;
  int routeId;
  int routeType;
  int finalStopId;
  String destinationName;
  String status;
  int directionId;
  int runSequence;
  int expressStopCount;
  VehiclePosition? vehiclePosition;
  VehicleDescriptor? vehicleDescriptor;
  Geopath geopath;
  Interchange? interchange;
  String runNote;
  factory Run.fromJson(Map json) => Run(
      json['run_id'],
      json['run_ref'],
      json['route_id'],
      json['route_type'],
      json['final_stop_id'],
      json['destination_name'],
      json['status'],
      json['direction_id'],
      json['run_sequence'],
      json['express_stop_count'],
      json['vehicle_position'] != null ? VehiclePosition.fromJson(json['vehicle_position']) : null,
      json['vehicle_descriptor'] != null ? VehicleDescriptor.fromJson(json['vehicle_descriptor']) : null,
      Geopath.fromJson(json['geopath']),
      json['interchange'] != null ? Interchange.fromJson(json['interchange']) : null,
      json['run_note'],
  );
}
