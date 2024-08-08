// import 'dart:js_interop';

class TicketInfo {
  TicketInfo({
    required this.ticketType,
    required this.zone,
    required this.freeFareZone,
    required this.ticketMachine,
    required this.ticketChecks,
    required this.vLineReservation,
    required this.ticketZones,
  });
  String ticketType;
  String zone;
  bool freeFareZone;
  bool ticketMachine;
  bool ticketChecks;
  bool vLineReservation;
  List ticketZones;
  factory TicketInfo.fromJson(Map json) => TicketInfo(
    ticketType:       json["ticket_type"],
    zone:             json["zone"],
    freeFareZone:     json["is_free_fare_zone"],
    ticketMachine:    json["ticket_machine"],
    ticketChecks:     json["ticket_checks"],
    vLineReservation: json["vline_reservation"],
    ticketZones:      json["ticket_zones"],
  );
}