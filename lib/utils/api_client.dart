// lib/utils/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'https://api.mocklets.com/p6764/test_mint'; // Replace with your actual API endpoint

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
