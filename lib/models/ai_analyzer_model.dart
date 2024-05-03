class DamodarAIAnalyzer {
  final String response;

  DamodarAIAnalyzer({
    this.response = "",
  });

  factory DamodarAIAnalyzer.fromJson(Map<String, dynamic> data) {
    try {
      return DamodarAIAnalyzer(
        response: data["response"] as String,
      );
    } catch (error, stackTrace) {
      //print("AIAnalyzer error: ${error.toString()}");
      //print("Stack trace: $stackTrace");
      return DamodarAIAnalyzer(); // Return default on error
    }
  }
}
