import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final restaurants = await _restaurantService.fetchRestaurants();
      setState(() {
        _restaurants = restaurants;
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addRestaurant() async {
    final localisationController = TextEditingController();
    final etatController = TextEditingController();
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Restaurant'),
              content: Column(
                children: [
                  TextField(
                    controller: localisationController,
                    decoration: InputDecoration(labelText: 'Localisation'),
                  ),
                  TextField(
                    controller: etatController,
                    decoration: InputDecoration(labelText: 'Etat'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);
                    final newRestaurant = Restaurant(
                      id: 0,
                      localisation: localisationController.text,
                      etat: etatController.text,
                    );
                    await _restaurantService.addRestaurant(newRestaurant);
                    setState(() => isLoading = false);
                    Navigator.pop(context);
                    _fetchRestaurants();
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editRestaurant(Restaurant restaurant) async {
    final localisationController = TextEditingController(text: restaurant.localisation);
    final etatController = TextEditingController(text: restaurant.etat);
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Restaurant'),
              content: Column(
                children: [
                  TextField(
                    controller: localisationController,
                    decoration: InputDecoration(labelText: 'Localisation'),
                  ),
                  TextField(
                    controller: etatController,
                    decoration: InputDecoration(labelText: 'Etat'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);
                    final updatedRestaurant = Restaurant(
                      id: restaurant.id,
                      localisation: localisationController.text,
                      etat: etatController.text,
                    );
                    await _restaurantService.updateRestaurant(updatedRestaurant);
                    setState(() => isLoading = false);
                    Navigator.pop(context);
                    _fetchRestaurants();
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteRestaurant(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Restaurant'),
          content: Text('Are you sure you want to delete this restaurant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _restaurantService.deleteRestaurant(id);
      _fetchRestaurants();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _restaurants.isEmpty
          ? Center(child: Text('No restaurants available'))
          : ListView.builder(
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(restaurant.localisation),
              subtitle: Text(restaurant.etat),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editRestaurant(restaurant),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteRestaurant(restaurant.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRestaurant,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
