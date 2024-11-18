import 'package:flutter/material.dart';
import '../screens/screens.dart'; // Ensure Screens enum is correctly imported

class Sidebar extends StatelessWidget {
  final Function(Screens) onSelectScreen;

  Sidebar(this.onSelectScreen);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColorDark,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(context, Screens.dashboard, 'Dashboard', Icons.dashboard),
                  _buildListTile(context, Screens.menuItems, 'Menu Items', Icons.menu),
                  _buildListTile(context, Screens.categories, 'Categories', Icons.category),
                  _buildListTile(context, Screens.clients, 'Clients', Icons.people),
                  Divider(color: Colors.white54),
                  _buildListTile(context, Screens.logout, 'Logout', Icons.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Inside Sidebar widget
  Widget _buildListTile(BuildContext context, Screens screen, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        onSelectScreen(screen);  // Make sure this triggers the correct screen change
        Navigator.of(context).pop();  // Close the drawer
      },
    );
  }

}
