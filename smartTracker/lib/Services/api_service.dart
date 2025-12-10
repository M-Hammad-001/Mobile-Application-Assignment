import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ApiService {
  // Replace with your actual API URL
  static const String baseUrl = 'http://YOUR_API_URL:3000/api';

  // For local testing with Android Emulator use: http://10.0.2.2:3000/api
  // For iOS Simulator use: http://localhost:3000/api
  // For physical device use your computer's local IP: http://192.168.x.x:3000/api

  // Create activity
  Future<ActivityModel?> createActivity(ActivityModel activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/activities'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(activity.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ActivityModel.fromJson(data);
      } else {
        print('Error creating activity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error creating activity: $e');
      return null;
    }
  }

  // Get all activities
  Future<List<ActivityModel>> getActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activities'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ActivityModel.fromJson(json)).toList();
      } else {
        print('Error fetching activities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Network error fetching activities: $e');
      return [];
    }
  }

  // Get single activity
  Future<ActivityModel?> getActivity(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activities/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ActivityModel.fromJson(data);
      } else {
        print('Error fetching activity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error fetching activity: $e');
      return null;
    }
  }

  // Update activity
  Future<ActivityModel?> updateActivity(String id, ActivityModel activity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/activities/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(activity.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ActivityModel.fromJson(data);
      } else {
        print('Error updating activity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error updating activity: $e');
      return null;
    }
  }

  // Delete activity
  Future<bool> deleteActivity(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/activities/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Network error deleting activity: $e');
      return false;
    }
  }

  // Search activities
  Future<List<ActivityModel>> searchActivities(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activities/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ActivityModel.fromJson(json)).toList();
      } else {
        print('Error searching activities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Network error searching activities: $e');
      return [];
    }
  }
}