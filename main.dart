import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RainController(),
    );
  }
}

class RainController extends StatefulWidget {
  @override
  _RainControllerState createState() => _RainControllerState();
}

class _RainControllerState extends State<RainController> {
  bool isRaining = false;

  Future<void> checkWeather() async {
    // Replace with your actual weather API URL
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=4f660edbcfa9b379ea2c2f61303b8132'));


    if (response.statusCode == 200) {
      // Simple example to check if the response contains "rain"
      setState(() {
        isRaining = response.body.contains('rain');
      });
      if (isRaining) {
        await sendCommandToESP32('rain_detected');
      }
    }
  }

  Future<void> sendCommandToESP32(String command) async {
    final url = 'http://192.168.137.150/$command'; // Replace with your ESP32 IP
    await http.get(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rain Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isRaining ? 'It\'s raining!' : 'No rain detected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkWeather,
              child: Text('Check Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
