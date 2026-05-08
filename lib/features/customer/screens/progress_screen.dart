import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';
import 'package:fixmate_app/data/mock_data.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // 0: Pending, 1: Accepted, 2: On the Way, 3: In Progress, 4: Completed
  int _currentStep = 1;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Request Sent',
      'subtitle': 'Waiting for worker to accept',
      'icon': Icons.send_rounded,
      'time': '3:07 PM',
    },
    {
      'title': 'Job Accepted',
      'subtitle': 'Worker has accepted your request',
      'icon': Icons.check_circle_rounded,
      'time': '3:09 PM',
    },
    {
      'title': 'On the Way',
      'subtitle': 'Worker is heading to your location',
      'icon': Icons.directions_run_rounded,
      'time': '3:15 PM',
    },
    {
      'title': 'In Progress',
      'subtitle': 'Worker is working on your issue',
      'icon': Icons.build_rounded,
      'time': '--:--',
    },
    {
      'title': 'Completed',
      'subtitle': 'Job has been completed',
      'icon': Icons.task_alt_rounded,
      'time': '--:--',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final worker =
        ModalRoute.of(context)!.settings.arguments as MockWorker;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Progress'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker status card
            _buildWorkerStatusCard(worker),
            const SizedBox(height: 20),

            // Progress timeline
            _buildSectionTitle('Job Timeline'),
            const SizedBox(height: 16),
            _buildTimeline(),
            const SizedBox(height: 20),

            // Job details card
            _buildSectionTitle('Job Details'),
            const SizedBox(height: 12),
            _buildJobDetailsCard(worker),
            const SizedBox(height: 20),

            // Action buttons
            _buildActionButtons(context, worker),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── WORKER STATUS CARD ──
  Widget _buildWorkerStatusCard(MockWorker worker) {
    final statusText = [
      'Waiting for response...',
      'Job Accepted ✅',
      'On the Way 🏃',
      'In Progress 🔧',
      'Completed 🎉',
    ][_currentStep];

    final statusColor = [
      const Color(0xFFF59E0B),
      AppColors.primary,
      const Color(0xFF0EA5E9),
      AppColors.secondary,
      AppColors.success,
    ][_currentStep];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.2),
            statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Worker info row
          Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(worker.avatarColor),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: statusColor.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    worker.initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.build_rounded,
                            color: AppColors.textSecondary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          worker.category,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.location_on_rounded,
                            color: AppColors.textSecondary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${worker.distanceKm} km away',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Online indicator
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: worker.isOnline
                          ? AppColors.success
                          : AppColors.textSecondary,
                      shape: BoxShape.circle,
                      boxShadow: worker.isOnline
                          ? [
                              BoxShadow(
                                color: AppColors.success.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    worker.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: worker.isOnline
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Demo step buttons
          const Text(
            'Demo: Simulate progress',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _currentStep > 0
                      ? () => setState(() => _currentStep--)
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.surfaceLight),
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('← Back',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentStep < _steps.length - 1
                      ? () => setState(() => _currentStep++)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Next →',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── TIMELINE ──
  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final isCompleted = index <= _currentStep;
          final isActive = index == _currentStep;
          final isLast = index == _steps.length - 1;

          final Color nodeColor = isCompleted
              ? AppColors.primary
              : AppColors.surfaceLight;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline node + line
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: nodeColor,
                        width: isActive ? 2.5 : 1.5,
                      ),
                    ),
                    child: Icon(
                      _steps[index]['icon'] as IconData,
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                  if (!isLast)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 2,
                      height: 36,
                      color: index < _currentStep
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Step content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _steps[index]['title'] as String,
                            style: TextStyle(
                              color: isCompleted
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _steps[index]['subtitle'] as String,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _steps[index]['time'] as String,
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── JOB DETAILS ──
  Widget _buildJobDetailsCard(MockWorker worker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        children: [
          _buildDetailRow(
              Icons.build_rounded, 'Service', worker.category),
          _buildDivider(),
          _buildDetailRow(Icons.location_on_rounded, 'Location',
              'No. 45, Galle Road, Colombo 03'),
          _buildDivider(),
          _buildDetailRow(Icons.access_time_rounded, 'Requested At',
              '3:07 PM, Today'),
          _buildDivider(),
          _buildDetailRow(Icons.timer_outlined, 'Est. Duration',
              worker.avgTime),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: AppColors.surfaceLight, height: 1);
  }

  // ── ACTION BUTTONS ──
  Widget _buildActionButtons(BuildContext context, MockWorker worker) {
    return Column(
      children: [
        // Show review button only when completed
        if (_currentStep == 4)
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              '/review',
              arguments: worker,
            ),
            icon: const Icon(Icons.rate_review_rounded),
            label: const Text('Leave a Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
          ),

        if (_currentStep < 4) ...[
          OutlinedButton.icon(
            onPressed: () => _showCancelDialog(context),
            icon: const Icon(Icons.cancel_outlined,
                color: AppColors.error),
            label: const Text(
              'Cancel Job',
              style: TextStyle(color: AppColors.error),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Cancel Job?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to cancel this job request?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}