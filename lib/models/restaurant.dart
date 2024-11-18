class Restaurant {
  final int id;
  final String localisation;
  final String etat;

  Restaurant({required this.id, required this.localisation, required this.etat});

  // Factory constructor to create a Restaurant object from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['idResto'],
      localisation: json['localisationRestau'],
      etat: json['etatResto'],
    );
  }

  // Convert Restaurant object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idResto': id,
      'localisationRestau': localisation,
      'etatResto': etat,
    };
  }
}
