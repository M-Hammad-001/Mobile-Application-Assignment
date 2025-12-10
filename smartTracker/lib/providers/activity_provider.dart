import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository _repository;
  final LocationService _locationService;
  final CameraService _cameraService;

  ActivityProvider({
    required ActivityRepository repository,
    required LocationService locationService,
    required CameraService cameraService,
  })  : _repository = repository,
        _locationService = locationService,
        _cameraService = cameraService;

  List<ActivityModel> _activities = [];
  List<ActivityModel> _offlineActivities = [];
  Position? _currentPosition;
  File? _capturedImage;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ActivityModel> get activities => _activities;
  List<ActivityModel> get offlineActivities => _offlineActivities;
  Position? get currentPosition => _currentPosition;
  File? get capturedImage => _capturedImage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      _setLoading(true);
      _setError(null);

      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition == null) {
        _setError('Failed to get location. Please enable location services.');
      }

      _setLoading(false);
    } catch (e) {
      _setError('Error getting location: $e');
      _setLoading(false);
    }
  }

  // Capture image
  Future<void> captureImage() async {
    try {
      _setLoading(true);
      _setError(null);

      _capturedImage = await _cameraService.captureImage();

      if (_capturedImage == null) {
        _setError('Failed to capture image');
      }

      _setLoading(false);
    } catch (e) {
      _setError('Error capturing image: $e');
      _setLoading(false);
    }
  }

  // Clear captured image
  void clearCapturedImage() {
    _capturedImage = null;
    notifyListeners();
  }

  // Create new activity
  Future<bool> createActivity(String? description) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentPosition == null) {
        _setError('Location not available');
        _setLoading(false);
        return false;
      }

      // Convert image to base64 if available
      String? imageBase64;
      if (_capturedImage != null) {
        imageBase64 = await _cameraService.imageToBase64(_capturedImage!);
      }

      // Create activity model
      final activity = ActivityModel(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        imageBase64: imageBase64,
        imagePath: _capturedImage?.path,
        timestamp: DateTime.now(),
        description: description,
      );

      // Save activity
      final createdActivity = await _repository.createActivity(activity);

      if (createdActivity != null) {
        // Refresh activities
        await fetchActivities();
        loadOfflineActivities();

        // Clear captured image
        _capturedImage = null;

        _setLoading(false);
        return true;
      } else {
        _setError('Failed to create activity');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error creating activity: $e');
      _setLoading(false);
      return false;
    }
  }

  // Fetch activities from API
  Future<void> fetchActivities() async {
    try {
      _setLoading(true);
      _setError(null);

      _activities = await _repository.getActivities();

      _setLoading(false);
    } catch (e) {
      _setError('Error fetching activities: $e');
      _setLoading(false);
    }
  }

  // Load offline activities
  void loadOfflineActivities() {
    _offlineActivities = _repository.getOfflineActivities();
    notifyListeners();
  }

  // Delete activity
  Future<bool> deleteActivity(String id, int? localIndex) async {
    try {
      _setLoading(true);
      _setError(null);

      final success = await _repository.deleteActivity(id, localIndex);

      if (success) {
        // Refresh activities
        await fetchActivities();
        loadOfflineActivities();
      }

      _setLoading(false);
      return success;
    } catch (e) {
      _setError('Error deleting activity: $e');
      _setLoading(false);
      return false;
    }
  }

  // Search activities
  Future<void> searchActivities(String query) async {
    try {
      _setLoading(true);
      _setError(null);

      if (query.isEmpty) {
        await fetchActivities();
      } else {
        _activities = await _repository.searchActivities(query);
      }

      _setLoading(false);
    } catch (e) {
      _setError('Error searching activities: $e');
      _setLoading(false);
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}