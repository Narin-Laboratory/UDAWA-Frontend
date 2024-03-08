class DamodarSensors {
  final double ppm;
  final double ppmAvg;
  final double ppmMax;
  final double ppmMin;
  final double cels;
  final double celsAvg;
  final double celsMax;
  final double celsMin;
  final int ts;

  DamodarSensors({
    this.ppm = 0.0,
    this.ppmAvg = 0.0,
    this.ppmMax = 0.0,
    this.ppmMin = 0.0,
    this.cels = 0.0,
    this.celsAvg = 0.0,
    this.celsMax = 0.0,
    this.celsMin = 0.0,
    this.ts = 0,
  });

  factory DamodarSensors.fromJson(Map<String, dynamic> data) {
    try {
      return DamodarSensors(
        ppm: data["ppm"] is double
            ? data["ppm"]
            : (data["ppm"] as int).toDouble(),
        ppmAvg: data["ppmAvg"] is double
            ? data["ppmAvg"]
            : (data["ppmAvg"] as int).toDouble(),
        ppmMax: data["ppmMax"] is double
            ? data["ppmMax"]
            : (data["ppmMax"] as int).toDouble(),
        ppmMin: data["ppmMin"] is double
            ? data["ppmMin"]
            : (data["ppmMin"] as int).toDouble(),

        cels: data["cels"] is double
            ? data["cels"]
            : (data["cels"] as int).toDouble(),
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
      print("DamodarSensor error: ${error.toString()}");
      return DamodarSensors(); // Return default on error
    }
  }
}
