
class Feeder {

}

class Distributor {

}

class Interchange {
  Interchange(
    this.temp
  );
  String temp;
  factory Interchange.fromJson(json) => Interchange(
    "temp"
  );
}
