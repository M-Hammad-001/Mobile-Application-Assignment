import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final Position? currentPosition;
  final List<Position>? locationHistory;
  final bool showMyLocation;
  final bool showLocationButton;
  final double? height;
  final VoidCallback? onLocationButtonPressed;
  final Function(GoogleMapController)? onMapCreated;
  final Set<Marker>? customMarkers;
  final Set<Polyline>? polylines;
  final double initialZoom;
  final MapType mapType;

  const MapWidget({
    Key? key,
    this.currentPosition,
    this.locationHistory,
    this.showMyLocation = true,
    this.showLocationButton = true,
    this.height,
    this.onLocationButtonPressed,
    this.onMapCreated,
    this.customMarkers,
    this.polylines,
    this.initialZoom = 15.0,
    this.mapType = MapType.normal,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    _updatePolylines();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPosition != widget.currentPosition ||
        oldWidget.locationHistory != widget.locationHistory ||
        oldWidget.customMarkers != widget.customMarkers) {
      _updateMarkers();
      _updatePolylines();

      // Animate to current position if changed
      if (widget.currentPosition != null &&
          oldWidget.currentPosition != widget.currentPosition) {
        _animateToPosition(widget.currentPosition!);
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();

      // Add custom markers if provided
      if (widget.customMarkers != null) {
        _markers.addAll(widget.customMarkers!);
      } else {
        // Add current position marker
        if (widget.currentPosition != null) {
          _markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(
                widget.currentPosition!.latitude,
                widget.currentPosition!.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
              infoWindow: InfoWindow(
                title: 'Your Location',
                snippet:
                'Lat: ${widget.currentPosition!.latitude.toStringAsFixed(4)}, '
                    'Lon: ${widget.currentPosition!.longitude.toStringAsFixed(4)}',
              ),
            ),
          );
        }

        // Add location history markers
        if (widget.locationHistory != null) {
          for (int i = 0; i < widget.locationHistory!.length; i++) {
            final position = widget.locationHistory![i];
            _markers.add(
              Marker(
                markerId: MarkerId('history_$i'),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
                infoWindow: InfoWindow(
                  title: 'Location ${i + 1}',
                  snippet: 'Lat: ${position.latitude.toStringAsFixed(4)}, '
                      'Lon: ${position.longitude.toStringAsFixed(4)}',
                ),
                alpha: 0.7,
              ),
            );
          }
        }
      }
    });
  }

  void _updatePolylines() {
    setState(() {
      _polylines.clear();

      // Add custom polylines if provided
      if (widget.polylines != null) {
        _polylines.addAll(widget.polylines!);
      } else {
        // Draw path from location history
        if (widget.locationHistory != null &&
            widget.locationHistory!.length > 1) {
          final points = widget.locationHistory!
              .map((pos) => LatLng(pos.latitude, pos.longitude))
              .toList();

          _polylines.add(
            Polyline(
              polylineId: const PolylineId('location_path'),
              points: points,
              color: Colors.blue,
              width: 4,
              patterns: [PatternItem.dash(20), PatternItem.gap(10)],
            ),
          );
        }
      }
    });
  }

  void _animateToPosition(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        widget.initialZoom,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }

    // Animate to current position after map is created
    if (widget.currentPosition != null) {
      _animateToPosition(widget.currentPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default position (Rawalpindi, Pakistan) if no position available
    final defaultPosition = widget.currentPosition ??
        Position(
          latitude: 33.6844,
          longitude: 73.0479,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  defaultPosition.latitude,
                  defaultPosition.longitude,
                ),
                zoom: widget.initialZoom,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: _onMapCreated,
              myLocationEnabled: widget.showMyLocation,
              myLocationButtonEnabled: false, // We'll use custom button
              mapType: widget.mapType,
              compassEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              padding: const EdgeInsets.only(bottom: 60, right: 10),
            ),

            // Loading indicator
            if (!_isMapReady)
              Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // Custom location button
            if (widget.showLocationButton)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: widget.onLocationButtonPressed ??
                          () {
                        if (widget.currentPosition != null) {
                          _animateToPosition(widget.currentPosition!);
                        }
                      },
                  child: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

            // Map type selector
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: PopupMenuButton<MapType>(
                  icon: const Icon(Icons.layers, size: 20),
                  onSelected: (MapType type) {
                    // This would need to be handled by parent widget
                    // or make MapWidget stateful with mapType as state
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: MapType.normal,
                      child: Row(
                        children: [
                          Icon(Icons.map),
                          SizedBox(width: 8),
                          Text('Normal'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: MapType.satellite,
                      child: Row(
                        children: [
                          Icon(Icons.satellite),
                          SizedBox(width: 8),
                          Text('Satellite'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: MapType.hybrid,
                      child: Row(
                        children: [
                          Icon(Icons.layers),
                          SizedBox(width: 8),
                          Text('Hybrid'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: MapType.terrain,
                      child: Row(
                        children: [
                          Icon(Icons.terrain),
                          SizedBox(width: 8),
                          Text('Terrain'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Coordinates display (optional)
            if (widget.currentPosition != null)
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lat: ${widget.currentPosition!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'Lon: ${widget.currentPosition!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Example usage widget
class MapWidgetExample extends StatelessWidget {
  const MapWidgetExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPosition = Position(
      latitude: 33.6844,
      longitude: 73.0479,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 500,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Map Widget Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MapWidget(
          currentPosition: currentPosition,
          height: 400,
          showMyLocation: true,
          showLocationButton: true,
          onLocationButtonPressed: () {
            print('Location button pressed');
          },
          onMapCreated: (controller) {
            print('Map created');
          },
        ),
      ),
    );
  }
}