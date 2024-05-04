class GreenHouseParameters {
  final String cultivationTechnology;
  final int plantTransplantingTS;
  final String plantType;
  final double rawWaterEC;
  final String waterSource;

  GreenHouseParameters({
    this.cultivationTechnology = "",
    this.plantTransplantingTS = 0,
    this.plantType = "",
    this.rawWaterEC = 0.0,
    this.waterSource = "",
  });

  factory GreenHouseParameters.fromJson(Map<String, dynamic> data) {
    try {
      return GreenHouseParameters(
        cultivationTechnology: data["cultivationTechnology"] as String,
        plantTransplantingTS: int.parse(data["plantTransplantingTS"] ?? '0'),
        plantType: data["plantType"] as String,
        rawWaterEC: double.parse(data["rawWaterEC"] ?? '0'),
        waterSource: data["waterSource"] as String,
      );
    } catch (error, stackTrace) {
      //print("GreenHouseParameters error: ${error.toString()}");
      //print("Stack trace: $stackTrace");
      return GreenHouseParameters(); // Return default on error
    }
  }
}
