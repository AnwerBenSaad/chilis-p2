import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/menu_item_service.dart';
import 'image_upload_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuItemsScreen extends StatefulWidget {
  @override
  _MenuItemsScreenState createState() => _MenuItemsScreenState();
}

class _MenuItemsScreenState extends State<MenuItemsScreen> {
  final MenuItemService _menuItemService = MenuItemService();
  List<MenuItem> _menuItems = [];
  List<Map<String, dynamic>> _categories = [];
  String _selectedCategory = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
    _fetchCategories();
  }

  Future<void> _fetchMenuItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _menuItemService.fetchMenuItems();
      setState(() {
        _menuItems = items;
      });
    } catch (e) {
      print('Error fetching items: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9092/api/categories'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _categories = jsonResponse.map((category) => category as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addOrEditMenuItem({MenuItem? menuItem}) async {
    final nameController = TextEditingController(text: menuItem?.nom ?? '');
    final descriptionController = TextEditingController(text: menuItem?.description ?? '');
    final priceController = TextEditingController(text: menuItem?.prix.toString() ?? '0.0');
    _selectedCategory = menuItem?.categoryName ?? '';

    final category = _categories.firstWhere(
          (category) => category['nomCategorie'] == _selectedCategory,
      orElse: () => {'idCategorie': 0},
    );

    final MenuItem newItem = MenuItem(
      idItem: menuItem?.idItem ?? 0,
      nom: nameController.text,
      description: descriptionController.text,
      prix: double.tryParse(priceController.text) ?? 0.0,
      image: '',
      categoryId: category['idCategorie'],
      categoryName: _selectedCategory,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(menuItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
                  TextField(controller: priceController, decoration: InputDecoration(labelText: 'Price')),
                  DropdownButton<String>(
                    value: _selectedCategory.isEmpty ? null : _selectedCategory,
                    hint: Text('Select Category'),
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['nomCategorie'],
                        child: Text(category['nomCategorie']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue ?? '';
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final imageUrl = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageUploadScreen(
                            onImageUploaded: (url) {
                              setState(() {
                                newItem.image = url;
                              });
                            },
                          ),
                        ),
                      );
                      if (imageUrl != null) {
                        setState(() {
                          newItem.image = imageUrl;
                        });
                      }
                    },
                    child: Text('Upload Image'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                TextButton(
                  onPressed: () async {
                    if (menuItem == null) {
                      await _menuItemService.addMenuItem(newItem);
                    } else {
                      await _menuItemService.updateMenuItem(newItem);
                    }
                    Navigator.pop(context);
                    _fetchMenuItems();
                  },
                  child: Text(menuItem == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteMenuItem(int idItem) async {
    await _menuItemService.deleteMenuItem(idItem);
    _fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Menu Items'),
        backgroundColor: Colors.red, // Set red color for AppBar
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = _menuItems[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: menuItem.image.isNotEmpty
                  ? Image.network(menuItem.image, width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 50),
              title: Text(menuItem.nom),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menuItem.description),
                  SizedBox(height: 4),
                  Text('Price: \$${menuItem.prix}'),
                  Text('Category: ${menuItem.categoryName}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit), onPressed: () => _addOrEditMenuItem(menuItem: menuItem)),
                  IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteMenuItem(menuItem.idItem)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditMenuItem(),
        child: Icon(Icons.add),
        backgroundColor: Colors.red, // Set red color for the floating button
      ),
    );
  }
}
