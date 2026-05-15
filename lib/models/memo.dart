class Memo {
  final int id;
  final String placeName;
  final String locationName;
  final String distance;
  final String imageUrl;
  final String memory;

  Memo({
    required this.id,
    required this.placeName,
    required this.locationName,
    required this.distance,
    required this.imageUrl,
    required this.memory,
  });

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] ?? 0,
      placeName: json['title'] ?? '',
      locationName: json['locationName'] ?? '',
      distance: json['distance'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      memory: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': placeName,
      'locationName': locationName,
      'distance': distance,
      'imageUrl': imageUrl,
      'body': memory,
      'userId': 1,
    };
  }
}