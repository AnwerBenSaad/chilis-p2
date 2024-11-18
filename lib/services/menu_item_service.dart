import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuItemService {
  final String apiUrl = 'http://10.0.2.2:9092/api/menu';

  // Fetch menu items
  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  // Add a new menu item (without validation)
  Future<void> addMenuItem(MenuItem item) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?categoryId=${item.categoryId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Menu item added successfully');
      } else {
        print('Failed to add menu item: ${response.body}');
      }
    } catch (error) {
      print("Error adding menu item: $error");
    }
  }

  // Update a menu item
  Future<void> updateMenuItem(MenuItem item) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${item.idItem}?categoryId=${item.categoryId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        print('Menu item updated successfully');
      } else {
        print('Failed to update menu item: ${response.body}');
      }
    } catch (error) {
      print("Error updating menu item: $error");
    }
  }

  // Delete a menu item
  Future<void> deleteMenuItem(int idItem) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$idItem'));
      if (response.statusCode == 200) {
        print('Menu item deleted successfully');
      } else {
        print('Failed to delete menu item: ${response.body}');
      }
    } catch (error) {
      print("Error deleting menu item: $error");
    }
  }
}
