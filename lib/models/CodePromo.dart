class CodePromo {
  final int id;
  final String code;
  final double reduction;
  final DateTime dateExpiration;

  CodePromo({
    required this.id,
    required this.code,
    required this.reduction,
    required this.dateExpiration,
  });

  factory CodePromo.fromJson(Map<String, dynamic> json) {
    return CodePromo(
      id: json['idCode'],
      code: json['code'],
      reduction: json['reduction'],
      dateExpiration: DateTime.parse(json['dateExpiration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCode': id,
      'code': code,
      'reduction': reduction,
      'dateExpiration': dateExpiration.toIso8601String(),
    };
  }
}
