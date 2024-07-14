
class Feeder {
  Feeder(
    this.runRef,
    this.routeId,
    this.stopId,
    this.advertised
  );
  String runRef;
  int routeId;
  int stopId;
  bool advertised;
  factory Feeder.fromJson(json) => Feeder(
    json['run_ref'],
    json['route_id'],
    json['stop_id'],
    json['advertised']
  );
}

class Distributor {
  Distributor(
    this.runRef,
    this.routeId,
    this.stopId,
    this.advertised
  );
  String runRef;
  int routeId;
  int stopId;
  bool advertised;
  factory Distributor.fromJson(json) => Distributor(
    json['run_ref'],
    json['route_id'],
    json['stop_id'],
    json['advertised']
  );
}

class Interchange {
  Interchange(
    this.feeder,
    this.distributor
  );
  Feeder? feeder;
  Distributor? distributor;
  factory Interchange.fromJson(json) => Interchange(
    json['feeder'] != null ? Feeder.fromJson(json['feeder']) : null,
    json['distributor'] != null ? Distributor.fromJson(json['distributor']) : null
  );
}
