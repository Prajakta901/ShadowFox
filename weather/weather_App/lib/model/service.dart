import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const _weatherHost = 'api.openweathermap.org';
  static const _forecastHost = 'api.open-meteo.com';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String city) async {
    final uri = Uri.https(_weatherHost, '/data/2.5/weather', {
      'q': city,
      'appid': apikey,
      'units': 'metric',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.https(_weatherHost, '/data/2.5/weather', {
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'appid': apikey,
      'units': 'metric',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<DailyForecast>> getWeeklyForecast(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.https(_forecastHost, '/v1/forecast', {
      'latitude': latitude.toString(),
         'longitude': longitude.toString(),
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
                      'timezone': 'auto',
      'forecast_days': '7',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load weekly forecast');
    }

           final body = json.decode(response.body) as Map<String, dynamic>;
    final daily = body['daily'] as Map<String, dynamic>;
            final dates = daily['time'] as List<dynamic>;

    return List.generate(
      dates.length,
      (index) => DailyForecast.fromOpenMeteoJson(daily, index),
    );
  }

  Future<CurrentLocation> getCurrentLocation() async {
            LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required to show weather');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
             position.longitude,
    );
    final city = placemarks.isNotEmpty ? placemarks.first.locality : null;

    return CurrentLocation(
      city: city ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<String> getCurrentCity() async {
    final location = await getCurrentLocation();
    return location.city;
  }
}

class CurrentLocation {
  final String city; final double latitude;
  final double longitude;

  CurrentLocation({
    required this.city, required this.latitude,
    required this.longitude,
  });
}
