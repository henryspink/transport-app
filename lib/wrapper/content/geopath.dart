
class Geopath {
  Geopath(
    this.temp
  );
  String temp;
  factory Geopath.fromJson(json) => Geopath(
    "temp"
  );
}