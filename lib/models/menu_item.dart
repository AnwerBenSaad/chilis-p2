class MenuItem {
  final int idItem;
  final String nom;
  final String description;
  final double prix;
  String image;
  final int categoryId;
  final String categoryName;

  MenuItem({
    required this.idItem,
    required this.nom,
    required this.description,
    required this.prix,
    required this.image,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  String toString() {
    return 'MenuItem(name: $nom, description: $description, price: $prix, image: $image, category: $categoryName)';
  }

// other methods like fromJson, toJson, etc.


  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      idItem: json['idItem'] as int? ?? 0,
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String? ?? '',
      prix: (json['prix'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      categoryId: json['category']?['idCategorie'] as int? ?? 0,
      categoryName: json['category']?['nomCategorie'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'idItem': idItem,
    'nom': nom,
    'description': description,
    'prix': prix,
    'image': image,
    'categoryId': categoryId,
  };
}