// lib/services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final String apiUrl = 'http://10.0.2.2:9092/api/categories';

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:9092/api/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }




  // Add a new category
  Future<Category> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 201) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add category');
    }
  }

  // Update an existing category
  Future<Category> updateCategory(Category category) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${category.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update category');
    }
  }

  // Delete a category by ID
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
