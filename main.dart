import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RainController(),
    );
  }
}

class RainController extends StatefulWidget {
  @override
  _RainControllerState createState() => _RainControllerState();
}

class _RainControllerState extends State<RainController> with SingleTickerProviderStateMixin {
  bool isRaining = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  Future<void> checkWeather() async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=4f660edbcfa9b379ea2c2f61303b8132'));


    if (response.statusCode == 200) {
      setState(() {
        isRaining = response.body.contains('rain');
      });
      if (isRaining) {
        await sendCommandToESP32('rain_detected');
        _animationController.forward(from: 0.0);
      } else {
        _animationController.reverse();
      }
    }
  }

  Future<void> sendCommandToESP32(String command) async {
    final url = 'http://192.168.137.150/$command';
    await http.get(Uri.parse(url));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animationController.value * 1.2 + 1.0,
                  child: isRaining
                      ? Image.asset('assets/rain.png', height: 100)
                      : Image.asset('assets/sun.png', height: 100),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              isRaining ? 'It\'s raining!' : 'No rain detected.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: checkWeather,
              icon: Icon(Icons.cloud),
              label: Text('Check Weather'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
