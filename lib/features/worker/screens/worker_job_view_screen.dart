import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WorkerJobViewScreen extends StatefulWidget {
  const WorkerJobViewScreen({super.key});

  @override
  State<WorkerJobViewScreen> createState() => _WorkerJobViewScreenState();
}

class _WorkerJobViewScreenState extends State<WorkerJobViewScreen> {
  GoogleMapController? _mapController;
  int _currentStep = 1;

  LatLng? _workerLocation;
  LatLng? _customerLocation;
  bool _locationLoading = true;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Job Accepted',
      'icon': Icons.check_circle_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'On the Way',
      'icon': Icons.directions_run_rounded,
      'color': Color(0xFF0EA5E9),
    },
    {
      'title': 'In Progress',
      'icon': Icons.build_rounded,
      'color': AppColors.secondary,
    },
    {
      'title': 'Completed',
      'icon': Icons.task_alt_rounded,
      'color': AppColors.success,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        // Use default Colombo location if permission denied
        setState(() {
          _workerLocation = const LatLng(6.9147, 79.9731);
          _customerLocation = const LatLng(6.9271, 79.8612);
          _locationLoading = false;
        });
        return;
      }

      // Get actual position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final workerLatLng = LatLng(position.latitude, position.longitude);

      // Place customer slightly offset from worker (simulating nearby customer)
      final customerLatLng = LatLng(
        position.latitude + 0.015,  // ~1.5 km north
        position.longitude + 0.010, // ~1 km east
      );

      setState(() {
        _workerLocation = workerLatLng;
        _customerLocation = customerLatLng;
        _locationLoading = false;
      });

      // Move camera to fit both markers
      final minLat1 = workerLatLng.latitude < customerLatLng.latitude
    ? workerLatLng.latitude : customerLatLng.latitude;
final maxLat1 = workerLatLng.latitude > customerLatLng.latitude
    ? workerLatLng.latitude : customerLatLng.latitude;
final minLng1 = workerLatLng.longitude < customerLatLng.longitude
    ? workerLatLng.longitude : customerLatLng.longitude;
final maxLng1 = workerLatLng.longitude > customerLatLng.longitude
    ? workerLatLng.longitude : customerLatLng.longitude;

_mapController?.animateCamera(
  CameraUpdate.newLatLngBounds(
    LatLngBounds(
      southwest: LatLng(minLat1, minLng1),
      northeast: LatLng(maxLat1, maxLng1),
    ),
    80,
  ),
);
    } catch (e) {
      setState(() {
        _workerLocation = const LatLng(6.9147, 79.9731);
        _customerLocation = const LatLng(6.9271, 79.8612);
        _locationLoading = false;
      });
    }
  }

  Set<Marker> get _markers {
    if (_workerLocation == null || _customerLocation == null) return {};
    return {
      Marker(
        markerId: const MarkerId('worker'),
        position: _workerLocation!,
        infoWindow: const InfoWindow(title: '📍 You (Worker)'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        position: _customerLocation!,
        infoWindow: const InfoWindow(title: '📍 Customer Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Map
          SizedBox(
            height: 280,
            child: _locationLoading
                ? Container(
                    color: const Color(0xFF1A2332),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              color: AppColors.primary),
                          SizedBox(height: 12),
                          Text(
                            'Getting your location...',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _workerLocation!,
                          zoom: 13,
                        ),
                        markers: _markers,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          // Fit both markers in view
                          Future.delayed(
                              const Duration(milliseconds: 300), () {
                            final minLat2 = _workerLocation!.latitude < _customerLocation!.latitude
    ? _workerLocation!.latitude : _customerLocation!.latitude;
final maxLat2 = _workerLocation!.latitude > _customerLocation!.latitude
    ? _workerLocation!.latitude : _customerLocation!.latitude;
final minLng2 = _workerLocation!.longitude < _customerLocation!.longitude
    ? _workerLocation!.longitude : _customerLocation!.longitude;
final maxLng2 = _workerLocation!.longitude > _customerLocation!.longitude
    ? _workerLocation!.longitude : _customerLocation!.longitude;

_mapController?.animateCamera(
  CameraUpdate.newLatLngBounds(
    LatLngBounds(
      southwest: LatLng(minLat2, minLng2),
      northeast: LatLng(maxLat2, maxLng2),
    ),
    80,
  ),
);
                          });
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                      ),

                      // Legend
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: Colors.blue, size: 14),
                                  SizedBox(width: 4),
                                  Text('You',
                                      style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 11)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: Colors.red, size: 14),
                                  SizedBox(width: 4),
                                  Text('Customer',
                                      style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Rest of the content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressStepper(),
                  const SizedBox(height: 16),
                  _buildJobDetailsCard(args),
                  const SizedBox(height: 16),
                  _buildCustomerCard(args),
                  const SizedBox(height: 16),
                  _buildActionButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Progress',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(_steps.length, (index) {
              final isCompleted = index < _currentStep;
              final isActive = index == _currentStep - 1;
              final isLast = index == _steps.length - 1;
              final color = _steps[index]['color'] as Color;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isCompleted || isActive
                                  ? color.withOpacity(0.2)
                                  : AppColors.surfaceLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCompleted || isActive
                                    ? color
                                    : AppColors.surfaceLight,
                                width: isActive ? 2.5 : 1.5,
                              ),
                            ),
                            child: Icon(
                              _steps[index]['icon'] as IconData,
                              color: isCompleted || isActive
                                  ? color
                                  : AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _steps[index]['title'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isCompleted || isActive
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 9,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 24),
                          color: index < _currentStep - 1
                              ? AppColors.primary
                              : AppColors.surfaceLight,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsCard(Map<String, dynamic> args) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.build_rounded, 'Category',
              args['category'] ?? 'Plumber'),
          _buildDivider(),
          _buildDetailRow(Icons.chat_bubble_outline_rounded,
              'Customer Issue', args['issue'] ?? 'Not specified'),
          _buildDivider(),
          _buildDetailRow(Icons.location_on_rounded, 'Location',
              args['location'] ?? 'Colombo'),
          _buildDivider(),
          _buildDetailRow(Icons.social_distance_rounded, 'Distance',
              args['distance'] ?? '2.4 km'),
          _buildDivider(),
          _buildDetailRow(Icons.access_time_rounded, 'Requested At',
              args['time'] ?? '3:07 PM'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      const Divider(color: AppColors.surfaceLight, height: 1);

  Widget _buildCustomerCard(Map<String, dynamic> args) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args['customer'] ?? 'Kasun Perera',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text('Customer',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call_rounded,
                color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_rounded,
                color: AppColors.primary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final labels = [
      'Start Journey',
      'Mark as In Progress',
      'Complete Job',
      'Job Completed ✅',
    ];
    final colors = [
      const Color(0xFF0EA5E9),
      AppColors.secondary,
      AppColors.success,
      AppColors.success,
    ];

    return Column(
      children: [
        if (_currentStep < 4)
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _currentStep++);
              if (_currentStep == 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        '🎉 Job completed! Customer will be notified.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            icon: Icon(_steps[_currentStep - 1]['icon'] as IconData),
            label: Text(labels[_currentStep - 1]),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors[_currentStep - 1],
            ),
          ),
        if (_currentStep == 4) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: const Column(
              children: [
                Icon(Icons.task_alt_rounded,
                    color: AppColors.success, size: 40),
                SizedBox(height: 8),
                Text(
                  'Job Completed!',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'The customer will now be able to leave a review.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Dashboard'),
          ),
        ],
      ],
    );
  }
}