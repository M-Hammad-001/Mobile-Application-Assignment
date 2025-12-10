import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0)
class ActivityModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  String? imageBase64;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  String? description;

  ActivityModel({
    this.id,
    required this.latitude,
    required this.longitude,
    this.imagePath,
    this.imageBase64,
    required this.timestamp,
    this.description,
  });

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'imageBase64': imageBase64,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  // Create from JSON response
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id']?.toString(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      imageBase64: json['imageBase64'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      description: json['description'],
    );
  }

  ActivityModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? imagePath,
    String? imageBase64,
    DateTime? timestamp,
    String? description,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      imageBase64: imageBase64 ?? this.imageBase64,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
    );
  }
}