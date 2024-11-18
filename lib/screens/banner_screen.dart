import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/banner.dart';
import '../services/banner_service.dart';

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final BannerService bannerService = BannerService();
  late Future<List<AppBanner>> banners;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    banners = bannerService.fetchBanners();
  }

  // Sélectionner une image depuis la galerie
  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Créer une nouvelle bannière
  Future<void> _createBanner() async {
    if (_selectedImage != null) {
      try {
        final newBanner = await bannerService.createBanner(_selectedImage!, isActive);
        setState(() {
          banners = bannerService.fetchBanners();  // Mettre à jour la liste des bannières
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bannière créée avec succès!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la création: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez sélectionner une image')));
    }
  }

  // Supprimer une bannière
  Future<void> _deleteBanner(int id) async {
    try {
      await bannerService.deleteBanner(id);
      setState(() {
        banners = bannerService.fetchBanners();  // Mettre à jour la liste après suppression
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bannière supprimée avec succès!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Bannières'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<AppBanner>>(
        future: banners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune bannière disponible.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final banner = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(banner.image),
                    title: Text('Bannière ${banner.id}'),
                    subtitle: Text(banner.etat ? 'Actif' : 'Inactif'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteBanner(banner.id),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectImage,
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _createBanner,
          child: Text("Créer la Bannière"),
        ),
      ),
    );
  }
}
