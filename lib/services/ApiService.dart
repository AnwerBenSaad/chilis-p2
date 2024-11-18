import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // GET request
  Future<List<T>> get<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data from $endpoint');
    }
  }

  // POST request
  Future<T> post<T>(String endpoint, dynamic body, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post data to $endpoint');
    }
  }

  // PUT request
  Future<T> put<T>(String endpoint, dynamic body, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update data on $endpoint');
    }
  }

  // DELETE request
  Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete data from $endpoint');
    }
  }
}
