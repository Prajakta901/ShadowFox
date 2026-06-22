class Weather {
  final String city; final double temp;
  final String mainCondit;

  Weather({required this.city, required this.temp, required this.mainCondit});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      mainCondit: json['weather'][0]['main'],
    );
  }
}

class DailyForecast {
  final DateTime date; final double maxTemp;
  final double minTemp; final String condition;

  DailyForecast({
    required this.date, required this.maxTemp,
    required this.minTemp, required this.condition,
  });

  factory DailyForecast.fromOpenMeteoJson(
    Map<String, dynamic> daily,
    int index,
  ) {
    return DailyForecast(
      date: DateTime.parse(daily['time'][index]),
      maxTemp: (daily['temperature_2m_max'][index] as num).toDouble(),
            minTemp: (daily['temperature_2m_min'][index] as num).toDouble(),
      condition: _conditionFromWeatherCode(daily['weather_code'][index] as int),
    );
  }
}

String _conditionFromWeatherCode(int code) {
  if (code == 0) return 'Clear';
  if ([1, 2, 3].contains(code)) return 'Clouds';

            if ([45, 48].contains(code)) return 'Mist';


        if ([51, 53, 55, 56, 57].contains(code)) return 'Drizzle';
           if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return 'Rain';
  if ([71, 73, 75, 77, 85, 86].contains(code)) return 'Snow';

        if ([95, 96, 99].contains(code)) return 'Thunderstorm';

  return 'Clouds';
}
