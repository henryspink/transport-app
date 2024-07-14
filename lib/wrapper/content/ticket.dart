import 'dart:js_interop';

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
  int ticketType;
  String zone;
  bool freeFareZone;
  bool ticketMachine;
  bool ticketChecks;
  bool vLineReservation;
  JSArray ticketZones;
  factory TicketInfo.fromJson(Map json) => TicketInfo(
    ticketType: json["ticketId"],
    zone: json["ticketName"],
    freeFareZone: json["ticketDescription"],
    ticketMachine: json["ticketPrice"],
    ticketChecks: json["ticketSuburb"],
    vLineReservation: json["ticketZone"],
    ticketZones: json["ticketSequence"],
  );
}