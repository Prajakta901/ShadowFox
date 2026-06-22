import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'model/service.dart';
import 'model/weather_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherPg(),
    );
  }
}

class WeatherPg extends StatefulWidget {
  const WeatherPg({super.key});

  @override
  State<WeatherPg> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPg> {
  final _weatherService = WeatherService('YOUR API KEY');
  Weather? _weather;
  List<DailyForecast> _weeklyForecast = [];
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await _weatherService.getCurrentLocation();
      final results = await Future.wait<Object>([
        _weatherService.getWeatherByLocation(
          location.latitude,
          location.longitude,
        ),
        _weatherService.getWeeklyForecast(
          location.latitude,
          location.longitude,
        ),
      ]);

      if (!mounted) return;
      setState(() {
        _weather = results[0] as Weather;
        _weeklyForecast = results[1] as List<DailyForecast>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load weather forecast';
        _isLoading = false;
      });
      debugPrint('Weather load failed: $e');
    }
  }

  String getWeatherAnimation(
    String? mainCondition, {
    bool matchCurrentTime = false,
  }) {
    if (mainCondition == null) {
      return 'lib/assets/sunny.json';
    }

    final hour = DateTime.now().hour;
    final isNight = matchCurrentTime && (hour >= 18 || hour < 6);

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return isNight ? 'lib/assets/Weather-cloudy(night).json'
            : 'lib/assets/sunny.json';

      case 'clouds':
      case 'snow':
        return 'lib/assets/Weather-cloudy(night).json';

      case 'rain':
      case 'drizzle':
          return 'lib/assets/Weather-thunder.json';

      case 'thunderstorm':
        return 'lib/assets/Weather-storm.json';

      case 'mist':
      case 'fog':
      case 'haze':
             return 'lib/assets/Weather-mist.json';

      default:
        return 'lib/assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7FF),
      appBar: AppBar(
        toolbarHeight: 96,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0B255D),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x3322476F),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC857),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                color: Color(0xFF0B255D),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weather Forecast',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _appBarSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFD7E8FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  String get _appBarSubtitle {
    if (_isLoading) return 'Updating your forecast';
    if (_errorMessage != null) return 'Forecast unavailable';

    final city = _weather?.city;
    final condition = _weather?.mainCondit;
    final temp = _weather?.temp.round();

    if (city != null && city.isNotEmpty && condition != null) {
      return '$city - $condition - ${temp ?? '--'}°C';
    }

    if (city != null && city.isNotEmpty) return city;
    return 'Current location';
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56, color: Color(0xFF24476F)),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Color(0xFF173654),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          _weather?.city ?? 'Current location',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 22),
        Lottie.asset(
          getWeatherAnimation(_weather?.mainCondit, matchCurrentTime: true),
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 24),
        Text(
          '${_weather?.temp.round() ?? '--'}°C',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          _weather?.mainCondit ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Color(0xFF24476F)),
        ),
        const SizedBox(height: 34),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Weekly Weather Forecast',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0B255D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: _fetchWeather,
              icon: const Icon(Icons.refresh),
              color: const Color(0xFF0B255D),
              tooltip: 'Refresh forecast',
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weeklyForecast.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ForecastCard(
                forecast: _weeklyForecast[index],
                animationPath: getWeatherAnimation(
                  _weeklyForecast[index].condition,
                ),
                dayLabel: _formatForecastDay(_weeklyForecast[index].date),
                dateLabel: _formatForecastDate(_weeklyForecast[index].date),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatForecastDay(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) return 'Today';
    return _weekdayNames[date.weekday - 1];
  }

  String _formatForecastDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}';
  }
}

class _ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final String animationPath; final String dayLabel;
  final String dateLabel;

  const _ForecastCard({
    required this.forecast, required this.animationPath,
    required this.dayLabel,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F224C7A),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text( dayLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(dateLabel,
            style: const TextStyle(fontSize: 12, color: Color(0xFF5D7389)),
          ),
          const SizedBox(height: 8),
          Lottie.asset(animationPath, width: 58, height: 58),
          const SizedBox(height: 8),
          Text(forecast.condition,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF24476F)),
          ),
          const SizedBox(height: 8),
          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TemperatureLabel(label: 'H', value: forecast.maxTemp),
              _TemperatureLabel(label: 'L', value: forecast.minTemp),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemperatureLabel extends StatelessWidget {
  final String label;
  final double value;

  const _TemperatureLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label ${value.round()}°',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

const _weekdayNames = [
  'Monday', 'Tuesday',
  'Wednesday','Thursday', 'Friday',
  'Saturday', 'Sunday',
];

const _monthNames = [
  'Jan', 'Feb',
  'Mar',  'Apr','May',
  'Jun',  'Jul', 'Aug',  'Sep',
  'Oct','Nov','Dec',
];
