import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'additional_info_item.dart';
import 'api_key.dart';
import 'humidity_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    var cityName = "London";

    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey",
        ),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw "Error getting weather data";
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: getCurrentWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data;
          final list = data!['list'];

          final double temp =
              double.parse(list[0]["main"]["temp"].toString()) - 273.15;
          final currentSky = list[0]["weather"][0]["main"];
          final icon = currentSky == "Clouds" || currentSky == "Rain"
              ? Icons.cloud
              : Icons.sunny;

          final humidity = list[0]["main"]["humidity"];
          final windSpeed = list[0]["wind"]["speed"];
          final visibility = list[0]["visibility"];

          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "${temp.toStringAsFixed(0)}° C",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(icon, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                "$currentSky",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 7),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 38; i++)
                //         HourlyForecastItem(
                //           icon:
                //               list[i]["weather"][0]["main"] == "Clear" ||
                //                   list[i]["weather"][0]["main"] == "Cloud"
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           time: "10:30",
                //           value: "320.18",
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 20,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      final double temp =
                          double.parse(list[i + 1]["main"]["temp"].toString()) -
                          273.15;
                      IconData icon =
                          list[i + 1]["weather"][0]["main"] == "Clear" ||
                              list[i + 1]["weather"][0]["main"] == "Cloud"
                          ? Icons.cloud
                          : Icons.sunny;

                      final time = DateTime.parse(list[i + 1]["dt_txt"]);
                      return HourlyForecastItem(
                        icon: icon,
                        time: '${time.hour}:${time.minute}',
                        value: "${temp.toStringAsFixed(0)}° C",
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: humidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Visibility",
                      value: visibility.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
