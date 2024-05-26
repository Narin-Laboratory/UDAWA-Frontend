class TemperatureSensor {
  final double cels;
  final double celsRaw;
  final double celsAvg;
  final double celsMax;
  final double celsMin;
  final int ts;

  TemperatureSensor({
    this.cels = 0.0,
    this.celsRaw = 0.0,
    this.celsAvg = 0.0,
    this.celsMax = 0.0,
    this.celsMin = 0.0,
    this.ts = 0,
  });

  factory TemperatureSensor.fromJson(Map<String, dynamic> data) {
    try {
      return TemperatureSensor(
        cels: data["cels"] is double
            ? data["cels"]
            : (data["cels"] as int).toDouble(),
        celsRaw: data["celsRaw"] is double
            ? data["celsRaw"]
            : (data["celsRaw"] as int).toDouble(),
        celsAvg: data["celsAvg"] is double
            ? data["celsAvg"]
            : (data["celsAvg"] as int).toDouble(),
        celsMax: data["celsMax"] is double
            ? data["celsMax"]
            : (data["celsMax"] as int).toDouble(),
        celsMin: data["celsMin"] is double
            ? data["celsMin"]
            : (data["celsMin"] as int).toDouble(),
        // ... similar for other 'double' properties ...
        ts: data["ts"] is int ? data["ts"] : (data["ts"] as double).toInt(),
      );
    } catch (error) {
      print("TemperatureSensor error: ${error.toString()}");
      return TemperatureSensor(); // Return default on error
    }
  }
}
