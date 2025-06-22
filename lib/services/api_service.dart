import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  static Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> restaurants = data['restaurants'];
      return restaurants.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}
  