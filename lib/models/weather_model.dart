import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherModel with _$WeatherModel {
  const WeatherModel._();

  const factory WeatherModel({
    required Coord coord,
    required List<Weather> weather,
    required String base,
    required Main main,
    required int visibility,
    required Wind wind,
    required Clouds clouds,
    required int dt,
    required Sys sys,
    required int timezone,
    required int id,
    required String name,
    required int cod,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);

  String get cityName => name;
  String get weatherIcon => weather.isNotEmpty ? weather[0].icon : "Unknown";
  String get description => weather.isNotEmpty ? weather[0].description : "Unknown";
  double get temperature => main.temp;
  double get tempMin => main.tempMin;
  double get tempMax => main.tempMax;
  double get feelsLike => main.feelsLike;
  double get windSpeed => wind.speed;
  double get latitude => coord.lat;
  double get longitude => coord.lon;
  int get seaLevel => main.seaLevel ?? 0;
  int get groundLevel => main.groundLevel ?? 0;
  int get pressure => main.pressure;
  int get humidity => main.humidity;
  int get sunrise => sys.sunrise;
  int get sunset => sys.sunset;
  int get cloudiness => clouds.all;
}

@freezed
class Coord with _$Coord {
  const factory Coord({required double lon, required double lat}) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@freezed
class Main with _$Main {
  const factory Main({
    required double temp,
    required int pressure,
    required int humidity,
    @JsonKey(name: 'feels_like') required double feelsLike,
    @JsonKey(name: 'temp_min') required double tempMin,
    @JsonKey(name: 'temp_max') required double tempMax,
    @JsonKey(name: 'sea_level') int? seaLevel,
    @JsonKey(name: 'grnd_level') int? groundLevel,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@freezed
class Wind with _$Wind {
  const factory Wind({required double speed, required int deg, double? gust}) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@freezed
class Clouds with _$Clouds {
  const factory Clouds({required int all}) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
class Weather with _$Weather {
  const factory Weather({required int id, required String main, required String description, required String icon}) =
      _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}

@freezed
class Sys with _$Sys {
  const factory Sys({int? type, int? id, required String country, required int sunrise, required int sunset}) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}
