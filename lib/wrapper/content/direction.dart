class Direction {
  Direction({
    required this.routeDirectionDescription,
    required this.directionId,
    required this.directionName,
    required this.routeId,
    required this.routeType,
  });
  String? routeDirectionDescription;
  int directionId;
  String directionName;
  int routeId;
  int routeType;
  factory Direction.fromJson(json) => Direction(
    routeDirectionDescription: json['routeDirectionDescription'],
    directionId: json['directionId'],
    directionName: json['directionName'],
    routeId: json['routeId'],
    routeType: json['routeType'],
  );
}
