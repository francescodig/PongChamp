
class MarkerData {
  final String id;
  final double latitude;
  final double longitude;
  final String nome;
  final String descrizione;
  final String orario;

  MarkerData({
    required this.id, 
    required this.latitude, 
    required this.longitude,
    required this.nome,
    required this.descrizione,
    required this.orario,
    });

  factory MarkerData.fromJson(Map<String, dynamic> json) {
    return MarkerData(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(), 
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      orario: json['orario'] as String,
    );
  }
}
