import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_2/data/mqtt.dart';
import 'package:weather_app_2/data/my_location.dart';
import 'package:weather_app_2/screen/loding.dart';

const apikey = 'b8511b4cbb1055510eb89f4a762dcc89';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({this.parseWeatherData});
  final parseWeatherData;
  //const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late int time;
  late String city;
  late String weather;
  late int temp;
  late String formattedLocalTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.parseWeatherData);
  }

  void updateData(dynamic weatherData) {
    time = weatherData['timezone'];
    city = weatherData['name'];
    weather = weatherData['weather'][0]['main'];
    double temp2 = weatherData['main']['temp'];
    temp = temp2.toInt();

    printLocalTime(time);
    print(city);
    print(weather);
    print(temp);

    Mqtt mqtt = Mqtt();
    if (weather == 'Rain') {
      mqtt.connect();
    }
  }

  void printLocalTime(int timezoneOffset) {
    DateTime utcNow = DateTime.now().toUtc();
    DateTime localTime = utcNow.add(Duration(seconds: timezoneOffset));
    formattedLocalTime = DateFormat('yyyy-MM-dd HH시mm분ss초').format(localTime);
    print('Local Time: $formattedLocalTime');
  }

  void getLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude3 = myLocation.latitude2;
    longitude3 = myLocation.longitude2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  getLocation();
                },
                child: const Text(
                  'get my location',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text(
                '경도 : $latitude3, ',
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(
                '위도 : $longitude3',
                style: const TextStyle(fontSize: 30.0),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Text(
                '$formattedLocalTime',
                style: const TextStyle(fontSize: 30.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '$city',
                style: const TextStyle(fontSize: 30.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '$weather',
                style: const TextStyle(fontSize: 30.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '$temp °C',
                style: const TextStyle(fontSize: 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
