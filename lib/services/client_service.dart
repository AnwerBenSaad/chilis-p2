// services/client_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/client.dart';

class ClientService {
  final String baseUrl = 'http://10.0.2.2:9092/api/clients';

  Future<List<Client>> getClients() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:9092/api/clients'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<void> deleteClient(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 204) {
      // Deletion was successful, no content returned
      print('Client with ID $id successfully deleted.');
    } else if (response.statusCode == 404) {
      // Handle the case where client is not found
      throw Exception('Client not found');
    } else {
      // Handle other cases (e.g., server errors)
      throw Exception('Failed to delete client');
    }
  }

}
