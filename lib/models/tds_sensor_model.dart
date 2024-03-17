class TDSSensor {
  final double ppm;
  final double ppmRaw;
  final double ppmAvg;
  final double ppmMax;
  final double ppmMin;
  final int ts;

  TDSSensor({
    this.ppm = 0.0,
    this.ppmRaw = 0.0,
    this.ppmAvg = 0.0,
    this.ppmMax = 0.0,
    this.ppmMin = 0.0,
    this.ts = 0,
  });

  factory TDSSensor.fromJson(Map<String, dynamic> data) {
    try {
      return TDSSensor(
        ppm: data["ppm"] is double
            ? data["ppm"]
            : (data["ppm"] as int).toDouble(),
        ppmRaw: data["ppmRaw"] is double
            ? data["ppmRaw"]
            : (data["ppmRaw"] as int).toDouble(),
        ppmAvg: data["ppmAvg"] is double
            ? data["ppmAvg"]
            : (data["ppmAvg"] as int).toDouble(),
        ppmMax: data["ppmMax"] is double
            ? data["ppmMax"]
            : (data["ppmMax"] as int).toDouble(),
        ppmMin: data["ppmMin"] is double
            ? data["ppmMin"]
            : (data["ppmMin"] as int).toDouble(),
        // ... similar for other 'double' properties ...
        ts: data["ts"] is int ? data["ts"] : (data["ts"] as double).toInt(),
      );
    } catch (error) {
      print("TDSSensor error: ${error.toString()}");
      return TDSSensor(); // Return default on error
    }
  }
}
