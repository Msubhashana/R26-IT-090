import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';
import 'package:fixmate_app/data/mock_data.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final worker =
        ModalRoute.of(context)!.settings.arguments as MockWorker;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeroHeader(context, worker),
          SliverToBoxAdapter(child: _buildBody(context, worker)),
        ],
      ),
      bottomNavigationBar: _buildBookButton(context, worker),
    );
  }

  // ── HERO HEADER ──
  Widget _buildHeroHeader(BuildContext context, MockWorker worker) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0EA5E9), AppColors.primary],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(worker.avatarColor),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      worker.initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  worker.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.build_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      worker.category,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${worker.distanceKm} km away',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── BODY ──
  Widget _buildBody(BuildContext context, MockWorker worker) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trust Score Card
          _buildTrustScoreCard(worker),
          const SizedBox(height: 16),

          // Stats row
          _buildStatsRow(worker),
          const SizedBox(height: 20),

          // NVQ Qualification
          _buildSectionTitle('NVQ Qualification'),
          const SizedBox(height: 12),
          _buildNvqCard(worker),
          const SizedBox(height: 20),

          // Availability
          _buildSectionTitle('Availability'),
          const SizedBox(height: 12),
          _buildAvailabilityCard(worker),
          const SizedBox(height: 20),

          // Recent Reviews
          _buildSectionTitle('Recent Reviews'),
          const SizedBox(height: 12),
          _buildReviews(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── TRUST SCORE CARD ──
  Widget _buildTrustScoreCard(MockWorker worker) {
    final score = worker.trustScore;
    final Color scoreColor = score >= 85
        ? AppColors.success
        : score >= 70
            ? const Color(0xFFF59E0B)
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          // Ring
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation(scoreColor),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${score.toInt()}',
                    style: TextStyle(
                      color: scoreColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intelligent Trust Score',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'For ${worker.category} category only',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildScoreChip('⭐ ${worker.starRating} Stars'),
                    const SizedBox(width: 6),
                    _buildScoreChip('✅ Verified Reviews'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
        ),
      ),
    );
  }

  // ── STATS ROW ──
  Widget _buildStatsRow(MockWorker worker) {
    return Row(
      children: [
        _buildStatBox('${worker.completedJobs}', 'Jobs Done',
            Icons.work_rounded),
        const SizedBox(width: 10),
        _buildStatBox(
            worker.avgTime, 'Avg Time', Icons.timer_outlined),
        const SizedBox(width: 10),
        _buildStatBox('${worker.starRating}⭐', 'Avg Rating',
            Icons.star_rounded),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
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

  // ── NVQ CARD ──
  Widget _buildNvqCard(MockWorker worker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1D4ED8).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school_rounded,
                color: Color(0xFF60A5FA), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NVQ Level ${worker.nvqLevel} — ${worker.category}',
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nationally certified by TVEC Sri Lanka',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'L${worker.nvqLevel}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AVAILABILITY CARD ──
  Widget _buildAvailabilityCard(MockWorker worker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
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
          const SizedBox(width: 10),
          Text(
            worker.isOnline
                ? 'Currently Online — Available for jobs'
                : 'Currently Offline',
            style: TextStyle(
              color: worker.isOnline
                  ? AppColors.success
                  : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── REVIEWS ──
  Widget _buildReviews() {
    final reviews = [
      {
        'name': 'Amara K.',
        'text': 'Bohoma honda service. Very professional and quick.',
        'sentiment': 'Positive',
        'stars': 5,
      },
      {
        'name': 'Rajan P.',
        'text': 'Watura bata fix una. Happy with the work done.',
        'sentiment': 'Positive',
        'stars': 4,
      },
      {
        'name': 'Dilini S.',
        'text': 'Came on time. Fixed the issue properly.',
        'sentiment': 'Positive',
        'stars': 5,
      },
    ];

    return Column(
      children: reviews
          .map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review['name'] as String,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              // Sentiment badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.thumb_up_rounded,
                                        color: AppColors.success, size: 10),
                                    const SizedBox(width: 4),
                                    Text(
                                      review['sentiment'] as String,
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${'⭐' * (review['stars'] as int)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        review['text'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
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

  // ── BOOK BUTTON ──
  Widget _buildBookButton(BuildContext context, MockWorker worker) {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceLight)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/progress',
          arguments: worker,
        ),
        child: const Text('Book This Worker'),
      ),
    ),
  );
}
}