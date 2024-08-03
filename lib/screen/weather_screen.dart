import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late String icon;
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
    //weather = "rain";
    double temp2 = weatherData['main']['temp'];
    temp = temp2.toInt();
    icon = weatherData['weather'][0]['icon'];
    //icon = "09d";

    printLocalTime(time);
    print(city);
    print(weather);
    print(temp);

    Mqtt mqtt = Mqtt();
    if (weather == 'rain') {
      mqtt.connect('rain');
    }
  }

  void printLocalTime(int timezoneOffset) {
    DateTime utcNow = DateTime.now().toUtc();
    DateTime localTime = utcNow.add(Duration(seconds: timezoneOffset));
    formattedLocalTime =
        DateFormat('yyyy-MM-dd  HH시 mm분 ss초').format(localTime);
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(''),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              bool? result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                          child: Text(
                        "현재 위치로 설정하시겠습니까?",
                        style: GoogleFonts.lato(
                            fontSize: 19.0,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    "Ok",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        )
                      ],
                    );
                  });
              if (result == true) {
                getLocation();
              }
            },
            icon: const Icon(
              Icons.location_searching,
            ),
            iconSize: 30.0,
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/image/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 150.0,
                    ),
                    Text(
                      city,
                      style: GoogleFonts.lato(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      formattedLocalTime,
                      style: GoogleFonts.lato(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    Text(
                      '$temp °C',
                      style: GoogleFonts.lato(
                          fontSize: 55.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Row(
                      children: [
                        Image.network(
                            'https://openweathermap.org/img/wn/$icon@2x.png'),
                        Text(
                          weather,
                          style: GoogleFonts.lato(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 30,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            bool? result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        '차수벽을 열겠습니까?',
                                        style: GoogleFonts.lato(
                                            fontSize: 19.0,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 50,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            height: 50,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: const Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                            if (result = true) {
                              Mqtt mqtt = Mqtt();
                              mqtt.connect('open');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 60),
                              backgroundColor: Colors.white),
                          child: Text(
                            'Open',
                            style: GoogleFonts.lato(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool? result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        '차수벽을 닫겠습니까?',
                                        style: GoogleFonts.lato(
                                            fontSize: 19.0,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 50,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            height: 50,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: const Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                            if (result = true) {
                              Mqtt mqtt = Mqtt();
                              mqtt.connect('close');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 60),
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255)),
                          child: Text(
                            'Close',
                            style: GoogleFonts.lato(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
