import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {
  final Function(double latitude, double longitude) onLocationSelected;

  const LocationPicker({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    // Set an initial location for the marker
    _pickedLocation = LatLng(51.5, -0.09); // Initial location (e.g., London)
  }

  // Update the marker position when the map is tapped
  void _onMapTap(LatLng location) {
    setState(() {
      _pickedLocation = location; // Update picked location to tapped position
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Pass the selected location back
              widget.onLocationSelected(
                  _pickedLocation.latitude, _pickedLocation.longitude);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              _pickedLocation, // Center the map over the initial location
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            _onMapTap(point); // Move the marker when the map is tapped
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          // The marker layer
          MarkerLayer(
            markers: [
              Marker(
                point: _pickedLocation, // Marker at the picked location
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    // Handle marker-specific taps here if needed
                    print("Marker tapped!");
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
