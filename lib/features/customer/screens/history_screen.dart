import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allJobs = [
    {
      'id': 'J001',
      'worker': 'Nimal Silva',
      'category': 'Plumber',
      'icon': '🔧',
      'issue': 'Pipe burst in kitchen',
      'date': 'Today, 3:07 PM',
      'status': 'Completed',
      'amount': 'LKR 2,500',
      'rating': 5,
      'initial': 'N',
      'avatarColor': 0xFF1E3A5F,
    },
    {
      'id': 'J002',
      'worker': 'Sunil Rathnayake',
      'category': 'Electrician',
      'icon': '⚡',
      'issue': 'Power outage in living room',
      'date': 'Yesterday, 11:30 AM',
      'status': 'Completed',
      'amount': 'LKR 1,800',
      'rating': 4,
      'initial': 'S',
      'avatarColor': 0xFF1A3D2B,
    },
    {
      'id': 'J003',
      'worker': 'Kamal Perera',
      'category': 'Carpenter',
      'icon': '🪵',
      'issue': 'Door hinge broken',
      'date': '3 days ago, 2:00 PM',
      'status': 'Cancelled',
      'amount': 'LKR 0',
      'rating': 0,
      'initial': 'K',
      'avatarColor': 0xFF3B1F6E,
    },
    {
      'id': 'J004',
      'worker': 'Ruwan Fernando',
      'category': 'Plumber',
      'icon': '🔧',
      'issue': 'Bathroom tap leaking',
      'date': '1 week ago, 9:00 AM',
      'status': 'Completed',
      'amount': 'LKR 1,200',
      'rating': 5,
      'initial': 'R',
      'avatarColor': 0xFF3D1A1A,
    },
    {
      'id': 'J005',
      'worker': 'Chamara Wijesinghe',
      'category': 'AC Repair',
      'icon': '❄️',
      'issue': 'AC not cooling properly',
      'date': '2 weeks ago, 4:30 PM',
      'status': 'Completed',
      'amount': 'LKR 3,500',
      'rating': 3,
      'initial': 'C',
      'avatarColor': 0xFF1A3D3D,
    },
    {
      'id': 'J006',
      'worker': 'Pradeep Jayasekara',
      'category': 'Painter',
      'icon': '🎨',
      'issue': 'Bedroom wall painting',
      'date': '1 month ago',
      'status': 'Cancelled',
      'amount': 'LKR 0',
      'rating': 0,
      'initial': 'P',
      'avatarColor': 0xFF2D3D1A,
    },
  ];

  List<Map<String, dynamic>> get _completedJobs =>
      _allJobs.where((j) => j['status'] == 'Completed').toList();

  List<Map<String, dynamic>> get _cancelledJobs =>
      _allJobs.where((j) => j['status'] == 'Cancelled').toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Job History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Summary cards
          _buildSummaryRow(),

          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              tabs: [
                Tab(text: 'All (${_allJobs.length})'),
                Tab(text: 'Done (${_completedJobs.length})'),
                Tab(text: 'Cancelled (${_cancelledJobs.length})'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJobList(_allJobs),
                _buildJobList(_completedJobs),
                _buildJobList(_cancelledJobs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SUMMARY ROW ──
  Widget _buildSummaryRow() {
    final completed = _completedJobs.length;
    final cancelled = _cancelledJobs.length;
    final totalSpent = _allJobs
        .where((j) => j['status'] == 'Completed')
        .fold<int>(0, (sum, j) {
      final amount = (j['amount'] as String)
          .replaceAll('LKR ', '')
          .replaceAll(',', '');
      return sum + int.parse(amount);
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildSummaryCard(
            '$completed',
            'Completed',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
          const SizedBox(width: 10),
          _buildSummaryCard(
            '$cancelled',
            'Cancelled',
            Icons.cancel_rounded,
            AppColors.error,
          ),
          const SizedBox(width: 10),
          _buildSummaryCard(
            'LKR ${totalSpent.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
            'Total Spent',
            Icons.payments_rounded,
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── JOB LIST ──
  Widget _buildJobList(List<Map<String, dynamic>> jobs) {
    if (jobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded,
                color: AppColors.textSecondary, size: 64),
            SizedBox(height: 12),
            Text(
              'No jobs here yet',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildJobCard(jobs[index]),
    );
  }

  // ── JOB CARD ──
  Widget _buildJobCard(Map<String, dynamic> job) {
    final isCompleted = job['status'] == 'Completed';
    final statusColor =
        isCompleted ? AppColors.success : AppColors.error;
    final rating = job['rating'] as int;

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
          // Header
          Row(
            children: [
              // Worker avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Color(job['avatarColor'] as int),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    job['initial'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['worker'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          job['icon'] as String,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          job['category'] as String,
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
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  isCompleted ? '✅ Done' : '❌ Cancelled',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceLight, height: 1),
          const SizedBox(height: 12),

          // Issue
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.build_rounded,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  job['issue'] as String,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Date and amount
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text(
                job['date'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                job['amount'] as String,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Star rating (only for completed jobs)
          if (isCompleted && rating > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Your rating: ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}