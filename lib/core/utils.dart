abstract class Utils {
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String getUnitSymbol(String unit) {
    if (unit == "imperial") {
      return "°F";
    } else if (unit == "metric") {
      return "°C";
    }
    return "°K";
  }

  static String getWindSpeedUnit(String unit) {
    if (unit == "imperial") {
      return "mph";
    } else if (unit == "metric") {
      return "m/s";
    }
    return "m/s";
  }
}
