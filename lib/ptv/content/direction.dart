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
    routeDirectionDescription:  json['route_direction_description'],
    directionId:                json['direction_id'],
    directionName:              json['direction_name'],
    routeId:                    json['route_id'],
    routeType:                  json['route_type'],
  );
}
