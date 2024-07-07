import 'status.dart';
import 'vehicle_info.dart';

class Geopath { //TODO
  Geopath(
    this.temp
  );
  int temp;
  factory Geopath.fromJson(json) => Geopath(
    json['temp']
  );
}

class Interchange { //TODO
  Interchange(
    this.temp
  );
  int temp;
  factory Interchange.fromJson(json) => Interchange(
    json['temp']
  );
}

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
    this.reqStatus,
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
  VehiclePosition vehiclePosition;
  VehicleDescriptor vehicleDescriptor;
  Geopath geopath;
  Interchange interchange;
  String runNote;
  Status reqStatus;
  factory Run.fromJson(Map json) {
    final runs = json['runs'][0];
    final status = json['req_status'];
    return Run(
      runs['run_id'],
      runs['run_ref'],
      runs['route_id'],
      runs['route_type'],
      runs['final_stop_id'],
      runs['destination_name'],
      runs['status'],
      runs['direction_id'],
      runs['run_sequence'],
      runs['express_stop_count'],
      VehiclePosition.fromJson(runs['vehicle_position']),
      VehicleDescriptor.fromJson(runs['vehicle_descriptor']),
      Geopath.fromJson(runs['geopath']),
      Interchange.fromJson(runs['interchange']),
      runs['run_note'],
      Status.fromJson(status['req_status']),
  );
  }
}