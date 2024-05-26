class PowerSensor {
  final double volt;
  final double voltRaw;
  final double voltMin;
  final double voltMax;
  final double voltAvg;

  final double amp;
  final double ampRaw;
  final double ampMin;
  final double ampMax;
  final double ampAvg;

  final double watt;
  final double wattRaw;
  final double wattMin;
  final double wattMax;
  final double wattAvg;

  final int ts;

  PowerSensor({
    this.volt = 0.0,
    this.voltRaw = 0.0,
    this.voltMin = 0.0,
    this.voltMax = 0.0,
    this.voltAvg = 0.0,
    this.amp = 0.0,
    this.ampRaw = 0.0,
    this.ampMin = 0.0,
    this.ampMax = 0.0,
    this.ampAvg = 0.0,
    this.watt = 0.0,
    this.wattRaw = 0.0,
    this.wattMin = 0.0,
    this.wattMax = 0.0,
    this.wattAvg = 0.0,
    this.ts = 0,
  });

  factory PowerSensor.fromJson(Map<String, dynamic> data) {
    try {
      return PowerSensor(
        volt: data["volt"] is double
            ? data["volt"]
            : (data["volt"] as int).toDouble(),
        voltRaw: data["voltRaw"] is double
            ? data["voltRaw"]
            : (data["voltRaw"] as int).toDouble(),
        voltMin: data["voltMin"] is double
            ? data["voltMin"]
            : (data["voltMin"] as int).toDouble(),
        voltMax: data["voltMax"] is double
            ? data["voltMax"]
            : (data["voltMax"] as int).toDouble(),
        voltAvg: data["voltAvg"] is double
            ? data["voltAvg"]
            : (data["voltAvg"] as int).toDouble(),

        amp: data["amp"] is double
            ? data["amp"]
            : (data["amp"] as int).toDouble(),
        ampRaw: data["ampRaw"] is double
            ? data["ampRaw"]
            : (data["ampRaw"] as int).toDouble(),
        ampMin: data["ampMin"] is double
            ? data["ampMin"]
            : (data["ampMin"] as int).toDouble(),
        ampMax: data["ampMax"] is double
            ? data["ampMax"]
            : (data["ampMax"] as int).toDouble(),
        ampAvg: data["ampAvg"] is double
            ? data["ampAvg"]
            : (data["ampAvg"] as int).toDouble(),

        watt: data["watt"] is double
            ? data["watt"]
            : (data["watt"] as int).toDouble(),
        wattRaw: data["wattRaw"] is double
            ? data["wattRaw"]
            : (data["wattRaw"] as int).toDouble(),
        wattMin: data["wattMin"] is double
            ? data["wattMin"]
            : (data["wattMin"] as int).toDouble(),
        wattMax: data["wattMax"] is double
            ? data["wattMax"]
            : (data["wattMax"] as int).toDouble(),
        wattAvg: data["wattAvg"] is double
            ? data["wattAvg"]
            : (data["wattAvg"] as int).toDouble(),

        // ... similar for other 'double' properties ...
        ts: data["ts"] is int ? data["ts"] : (data["ts"] as double).toInt(),
      );
    } catch (error) {
      print("PowerSensor error: ${error.toString()}");
      return PowerSensor(); // Return default on error
    }
  }
}
