import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/activity_provider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _descriptionController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Get current location on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    final provider = context.read<ActivityProvider>();

    if (provider.currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for location to be detected')),
      );
      return;
    }

    final success = await provider.createActivity(
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity saved successfully!')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to save activity'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveActivity,
          ),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Location Section
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Column(
                    children: [
                      // Map
                      SizedBox(
                        height: 250,
                        child: provider.currentPosition != null
                            ? GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              provider.currentPosition!.latitude,
                              provider.currentPosition!.longitude,
                            ),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('current'),
                              position: LatLng(
                                provider.currentPosition!.latitude,
                                provider.currentPosition!.longitude,
                              ),
                              infoWindow: const InfoWindow(
                                title: 'Your Location',
                              ),
                            ),
                          },
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        )
                            : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              const Text('Detecting location...'),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  provider.getCurrentLocation();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Location info
                      if (provider.currentPosition != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Lat: ${provider.currentPosition!.latitude.toStringAsFixed(6)}, '
                                      'Lon: ${provider.currentPosition!.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Camera Section
                Text(
                  'Photo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (provider.capturedImage != null)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  provider.capturedImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    provider.clearCapturedImage();
                                  },
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No photo captured',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            provider.captureImage();
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: Text(
                            provider.capturedImage != null
                                ? 'Retake Photo'
                                : 'Capture Photo',
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Section
                Text(
                  'Description (Optional)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add a description for this activity...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),

                // Save Button
                FilledButton.icon(
                  onPressed: _saveActivity,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Activity'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}