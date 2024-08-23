import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automatic Rain Sensing',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
      routes: {
        '/weather': (context) => const WeatherForecastPage(),
        '/sensor': (context) => const SensorControllerPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatic Rain Sensing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/welcome.png', width: 300, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
              child: const Text('Weather Forecast'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sensor');
              },
              child: const Text('Sensor Controller'),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorControllerPage extends StatefulWidget {
  const SensorControllerPage({super.key});

  @override
  _SensorControllerPageState createState() => _SensorControllerPageState();
}

class _SensorControllerPageState extends State<SensorControllerPage> {
  bool isOpenButtonDisabled = false;
  String sensorStatus = "Closed";

  void _sendCommand(String command) async {
    const esp32Ip = 'http://192.168.1.100/'; // Replace with your ESP32's IP address

    try {
      final response = await http.get(Uri.parse('$esp32Ip$command'));
      if (response.statusCode == 200) {
        setState(() {
          sensorStatus = command == 'open' ? 'Open' : 'Closed';
        });
      } else {
        print('Failed to send command');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleOpenButtonPress() {
    setState(() {
      isOpenButtonDisabled = true;
    });
    _sendCommand('open');
  }

  void _handleCloseButtonPress() {
    setState(() {
      isOpenButtonDisabled = false;
    });
    _sendCommand('close');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sensor is currently $sensorStatus',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isOpenButtonDisabled ? null : _handleOpenButtonPress,
              icon: const Icon(Icons.lock_open),
              label: const Text('Open'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _handleCloseButtonPress,
              icon: const Icon(Icons.lock),
              label: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherForecastPage extends StatefulWidget {
  const WeatherForecastPage({super.key});

  @override
  _WeatherForecastPageState createState() => _WeatherForecastPageState();
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  String temperature = "";
  String location = "";
  String weatherStatus = "";
  String weatherIcon = 'assets/images/sun.png'; // Default icon
  String humidity = "";
  String windSpeed = "";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    const apiKey = '4f660edbcfa9b379ea2c2f61303b8132'; // Replace with your actual API key
    const city = 'Bengaluru';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        final temp = weatherData['main']['temp'];
        final weatherCondition = weatherData['weather'][0]['main'];
        final humidityValue = weatherData['main']['humidity'];
        final windSpeedValue = weatherData['wind']['speed'];

        setState(() {
          temperature = "$temp°C";
          location = city;
          humidity = "Humidity: $humidityValue%";
          windSpeed = "Wind Speed: $windSpeedValue m/s";

          switch (weatherCondition) {
            case 'Rain':
              weatherStatus = "It's raining";
              weatherIcon = 'assets/images/rain.png';
              break;
            case 'Clear':
              weatherStatus = "It's sunny";
              weatherIcon = 'assets/images/sun.png';
              break;
            case 'Clouds':
              weatherStatus = "It's cloudy";
              weatherIcon = 'assets/images/cloudy.png';
              break;
            case 'Snow':
              weatherStatus = "It's snowing";
              weatherIcon = 'assets/images/snow.png';
              break;
            case 'Thunderstorm':
              weatherStatus = "Thunderstorm";
              weatherIcon = 'assets/images/thunderstrom.png';
              break;
            case 'Drizzle':
              weatherStatus = "Light rain (drizzle)";
              weatherIcon = 'assets/images/drizzle.png';
              break;
            case 'Fog':
            case 'Mist':
            case 'Haze':
              weatherStatus = "Foggy/Misty";
              weatherIcon = 'assets/images/fog.png';
              break;
            default:
              weatherStatus = "Weather unknown";
              weatherIcon = 'assets/images/default.png';
          }
        });
      } else {
        print('Failed to fetch weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(weatherIcon, width: 100, height: 100),
              const SizedBox(height: 20),
              Text(weatherStatus, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text(temperature, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(location, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(humidity, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text(windSpeed, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
