
class MarkerData {
  final String id;
  final double latitude;
  final double longitude;

  MarkerData({
    required this.id, 
    required this.latitude, 
    required this.longitude,
    });

  factory MarkerData.fromJson(Map<String, dynamic> json) {
    return MarkerData(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(), 
    );
  }
}
