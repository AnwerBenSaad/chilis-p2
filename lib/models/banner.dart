class AppBanner {
  final int id;
  final String image;
  final bool etat;

  AppBanner({
    required this.id,
    required this.image,
    required this.etat,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['id'],
      image: json['image'],
      etat: json['etat'] == 1,  // Assuming 1 for true, 0 for false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'etat': etat ? 1 : 0,  // Convert bool to 1 or 0 for the backend
    };
  }
}
