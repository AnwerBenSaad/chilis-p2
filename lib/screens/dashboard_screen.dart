import 'package:flutter/material.dart';
import 'package:frontend/screens/PromoCodeScreen.dart';
import 'package:frontend/screens/banner_screen.dart';
import 'package:frontend/screens/categories_screen.dart';
import 'package:frontend/screens/clients_screen.dart';
import 'package:frontend/screens/menu_items_screen.dart';
import 'package:frontend/screens/restaurant_screen.dart';
import '../widgets/sidebar.dart';
import 'package:frontend/screens/screens.dart';


class DashboardScreen extends StatefulWidget {
  final Function(Screens) onSelectScreen;

  DashboardScreen({required this.onSelectScreen});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(widget.onSelectScreen),
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(context, 'Banners', Icons.image, Colors.purple, BannerScreen()),
            _buildDashboardCard(context, 'Menu Items', Icons.menu, Colors.blue, MenuItemsScreen()),
            _buildDashboardCard(context, 'Categories', Icons.category, Colors.green, CategoriesScreen()),
            _buildDashboardCard(context, 'Clients', Icons.people, Colors.orange, ClientsScreen()),
            _buildDashboardCard(context, 'Restaurants', Icons.restaurant, Colors.redAccent, RestaurantScreen()),
            _buildDashboardCard(context, 'Promo Codes', Icons.card_giftcard, Colors.teal, PromoCodeScreen()),

          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget targetScreen) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
