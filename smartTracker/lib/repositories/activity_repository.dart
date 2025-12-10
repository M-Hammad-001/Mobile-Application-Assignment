import '../models/activity_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ActivityRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  ActivityRepository({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // Create activity (sync to API and save offline)
  Future<ActivityModel?> createActivity(ActivityModel activity) async {
    try {
      // Try to sync to API first
      final createdActivity = await _apiService.createActivity(activity);

      if (createdActivity != null) {
        // Save to local storage
        await _storageService.saveActivity(createdActivity);
        return createdActivity;
      } else {
        // If API fails, save locally with pending sync flag
        await _storageService.saveActivity(activity);
        return activity;
      }
    } catch (e) {
      print('Error in createActivity: $e');
      // Save locally as fallback
      await _storageService.saveActivity(activity);
      return activity;
    }
  }

  // Get all activities (from API, fallback to offline)
  Future<List<ActivityModel>> getActivities() async {
    try {
      final activities = await _apiService.getActivities();

      if (activities.isNotEmpty) {
        return activities;
      } else {
        // Fallback to offline data
        return _storageService.getOfflineActivities();
      }
    } catch (e) {
      print('Error fetching activities: $e');
      // Return offline activities
      return _storageService.getOfflineActivities();
    }
  }

  // Get offline activities
  List<ActivityModel> getOfflineActivities() {
    return _storageService.getOfflineActivities();
  }

  // Delete activity (from API and local)
  Future<bool> deleteActivity(String id, int? localIndex) async {
    try {
      // Try to delete from API
      final success = await _apiService.deleteActivity(id);

      // Delete from local storage if index is provided
      if (localIndex != null) {
        await _storageService.deleteActivity(localIndex);
      }

      return success;
    } catch (e) {
      print('Error deleting activity: $e');
      // Still delete locally
      if (localIndex != null) {
        await _storageService.deleteActivity(localIndex);
      }
      return false;
    }
  }

  // Search activities
  Future<List<ActivityModel>> searchActivities(String query) async {
    try {
      return await _apiService.searchActivities(query);
    } catch (e) {
      print('Error searching activities: $e');
      // Search in offline data
      final offlineActivities = _storageService.getOfflineActivities();
      return offlineActivities.where((activity) {
        return activity.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
  }

  // Clear all local data
  Future<void> clearOfflineData() async {
    await _storageService.clearAll();
  }

  // Get offline count
  int getOfflineCount() {
    return _storageService.getCount();
  }
}