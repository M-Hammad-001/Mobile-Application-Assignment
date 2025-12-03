import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';

class StorageService {
  static const String _boxName = 'activities';
  static const int _maxOfflineActivities = 5;

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ActivityModelAdapter());
    await Hive.openBox<ActivityModel>(_boxName);
  }

  // Get the box
  Box<ActivityModel> _getBox() {
    return Hive.box<ActivityModel>(_boxName);
  }

  // Save activity locally (keep only last 5)
  Future<void> saveActivity(ActivityModel activity) async {
    final box = _getBox();

    // Add the new activity
    await box.add(activity);

    // Keep only the most recent 5 activities
    if (box.length > _maxOfflineActivities) {
      final keysToDelete = box.keys.take(box.length - _maxOfflineActivities);
      await box.deleteAll(keysToDelete);
    }
  }

  // Get all offline activities
  List<ActivityModel> getOfflineActivities() {
    final box = _getBox();
    return box.values.toList().reversed.toList(); // Most recent first
  }

  // Get activity by index
  ActivityModel? getActivity(int index) {
    final box = _getBox();
    return box.getAt(index);
  }

  // Delete activity
  Future<void> deleteActivity(int index) async {
    final box = _getBox();
    await box.deleteAt(index);
  }

  // Clear all activities
  Future<void> clearAll() async {
    final box = _getBox();
    await box.clear();
  }

  // Update activity
  Future<void> updateActivity(int index, ActivityModel activity) async {
    final box = _getBox();
    await box.putAt(index, activity);
  }

  // Get count
  int getCount() {
    return _getBox().length;
  }
}