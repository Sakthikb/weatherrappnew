import 'dart:convert';


import 'package:http/http.dart'as http;
import 'package:weatherappnew/ui/weathermodel.dart';

class WeatherApi{
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";
  final String apiKey = "1c4ac2da2df44cb58ad121310241907";

  Future<ApiResponse> getCurrentWeather(String location) async {
    final String apiUrl = "$baseUrl?key=$apiKey&q=$location&aqi=no";
    try{
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return ApiResponse.fromJson(jsonDecode(response.body));
      }
      else {
        throw Exception("Failed to load weather: ${response.statusCode}");
      }
    }catch(value){
      throw Exception("Failed to load weather");
    }
  }
}