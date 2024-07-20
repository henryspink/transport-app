library exceptions;

class InvalidStationName implements Exception {
  InvalidStationName(this.message);
  final String message;
}