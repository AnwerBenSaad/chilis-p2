// models/client.dart
class Client {
  final int idClient;
  final String nom;
  final String email;
  final String motDePasse;
  final int pointsCadeaux;
  final String tel;

  Client({
    required this.idClient,
    required this.nom,
    required this.email,
    required this.motDePasse,
    required this.pointsCadeaux,
    required this.tel,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idClient: json['idClient'],
      nom: json['nom'],
      email: json['email'],
      motDePasse: json['motDePasse'],
      pointsCadeaux: json['pointsCadeaux'],
      tel: json['tel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idClient': idClient,
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
      'pointsCadeaux': pointsCadeaux,
      'tel': tel,
    };
  }
}
