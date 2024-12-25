import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://official-joke-api.appspot.com";

  static Future<List<String>> getJokeTypes() async {
    final response = await http.get(Uri.parse("$baseUrl/types"));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load joke types");
    }
  }

  static Future<List<Map<String, dynamic>>> getJokesByType(String type) async {
    final response = await http.get(Uri.parse("$baseUrl/jokes/$type/ten"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load jokes");
    }
  }

  static Future<Map<String, dynamic>> getRandomJoke() async {
    final response = await http.get(Uri.parse("$baseUrl/random_joke"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load random joke");
    }
  }
}
