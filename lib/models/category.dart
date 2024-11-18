class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  // Factory constructor to create a Category object from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategorie'], // Match the key from the API response
      name: json['nomCategorie'], // Match the key from the API response
    );
  }

  // Convert Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idCategorie': id,
      'nomCategorie': name,
    };
  }
}
