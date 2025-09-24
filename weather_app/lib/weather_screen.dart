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

          final temp = data?['list'][0]['main']["temp"];
          final currentSky = data?['list'][0]['weather'][0]['main'];

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
                                "$temp K",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Icon(Icons.cloud, size: 64),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const HourlyForecastItem(
                        icon: Icons.cloud,
                        time: "10:30",
                        value: "320.18",
                      ),
                      const HourlyForecastItem(
                        icon: Icons.sunny,
                        time: "11:30",
                        value: "213.89",
                      ),
                      const HourlyForecastItem(
                        icon: Icons.thunderstorm,
                        time: "12:30",
                        value: "289.87",
                      ),
                      const HourlyForecastItem(
                        icon: Icons.sunny,
                        time: "01:30",
                        value: "203.19",
                      ),
                    ],
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
                    const AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "95",
                    ),
                    const AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "80",
                    ),
                    const AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Visibility",
                      value: "90",
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
