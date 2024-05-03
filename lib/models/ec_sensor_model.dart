class ECSensor {
  final double ec;
  final double ecRaw;
  final double ecAvg;
  final double ecMax;
  final double ecMin;
  final int ts;

  ECSensor({
    this.ec = 0.0,
    this.ecRaw = 0.0,
    this.ecAvg = 0.0,
    this.ecMax = 0.0,
    this.ecMin = 0.0,
    this.ts = 0,
  });

  factory ECSensor.fromJson(Map<String, dynamic> data) {
    try {
      return ECSensor(
        ec: data["ec"] is double ? data["ec"] : (data["ec"] as int).toDouble(),
        ecRaw: data["ecRaw"] is double
            ? data["ecRaw"]
            : (data["ecRaw"] as int).toDouble(),
        ecAvg: data["ecAvg"] is double
            ? data["ecAvg"]
            : (data["ecAvg"] as int).toDouble(),
        ecMax: data["ecMax"] is double
            ? data["ecMax"]
            : (data["ecMax"] as int).toDouble(),
        ecMin: data["ecMin"] is double
            ? data["ecMin"]
            : (data["ecMin"] as int).toDouble(),
        // ... similar for other 'double' properties ...
        ts: data["ts"] is int ? data["ts"] : (data["ts"] as double).toInt(),
      );
    } catch (error) {
      print("ECSensor error: ${error.toString()}");
      return ECSensor(); // Return default on error
    }
  }
}
