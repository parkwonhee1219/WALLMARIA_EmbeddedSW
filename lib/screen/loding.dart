import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app_2/data/network.dart';
import 'package:weather_app_2/screen/weather_screen.dart';

const apikey = 'b8511b4cbb1055510eb89f4a762dcc89';
//위치 초기 설정 - 서울
double latitude3 = 37.5594793;
double longitude3 = 126.9435838;


class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    askAPI();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => askAPI());
  }

  void askAPI() async {
    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$apikey&units=metric');

    var weatherData = await network.getJsonData();
    print(weatherData);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen(
        parseWeatherData: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Loding...',
                style: const TextStyle(fontSize: 30.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
