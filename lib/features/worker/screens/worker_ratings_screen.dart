import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';

class WorkerRatingsScreen extends StatelessWidget {
  const WorkerRatingsScreen({super.key});

  final List<Map<String, dynamic>> _categoryRatings = const [
    {
      'category': 'Plumber',
      'icon': '🔧',
      'trustScore': 92.0,
      'starRating': 4.8,
      'totalJobs': 47,
      'positiveReviews': 43,
      'totalReviews': 47,
      'textApproval': 91.0,
    },
    {
      'category': 'Electrician',
      'icon': '⚡',
      'trustScore': 78.0,
      'starRating': 4.2,
      'totalJobs': 18,
      'positiveReviews': 14,
      'totalReviews': 18,
      'textApproval': 77.0,
    },
  ];

  final List<Map<String, dynamic>> _recentReviews = const [
    {
      'customer': 'Amara K.',
      'category': 'Plumber',
      'text': 'Bohoma honda service. Very professional and quick.',
      'sentiment': 'Positive',
      'stars': 5,
      'date': '2 days ago',
    },
    {
      'customer': 'Rajan P.',
      'category': 'Plumber',
      'text': 'Watura bata fix una. Happy with the work done.',
      'sentiment': 'Positive',
      'stars': 4,
      'date': '5 days ago',
    },
    {
      'customer': 'Dilini S.',
      'category': 'Electrician',
      'text': 'Came late but fixed the issue properly.',
      'sentiment': 'Positive',
      'stars': 3,
      'date': '1 week ago',
    },
    {
      'customer': 'Nuwan R.',
      'category': 'Plumber',
      'text': 'Not satisfied. Took too long to arrive.',
      'sentiment': 'Negative',
      'stars': 2,
      'date': '2 weeks ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ratings'),
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
            // Overall summary card
            _buildOverallSummary(),
            const SizedBox(height: 20),

            // Category breakdown
            _buildSectionTitle('Rating by Category'),
            const SizedBox(height: 12),
            ..._categoryRatings
                .map((cat) => _buildCategoryCard(cat))
                .toList(),
            const SizedBox(height: 20),

            // Recent reviews
            _buildSectionTitle('Recent Reviews'),
            const SizedBox(height: 12),
            ..._recentReviews
                .map((review) => _buildReviewCard(review))
                .toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── OVERALL SUMMARY ──
  Widget _buildOverallSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Overall Performance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('92', 'Best\nTrust Score', '⭐'),
              _buildSummaryDivider(),
              _buildSummaryItem('65', 'Total\nJobs Done', '💼'),
              _buildSummaryDivider(),
              _buildSummaryItem('4.6', 'Overall\nRating', '🏆'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white24,
    );
  }

  // ── CATEGORY CARD ──
  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    final trustScore = cat['trustScore'] as double;
    final textApproval = cat['textApproval'] as double;
    final starRating = cat['starRating'] as double;
    final positiveReviews = cat['positiveReviews'] as int;
    final totalReviews = cat['totalReviews'] as int;

    final Color scoreColor = trustScore >= 85
        ? AppColors.success
        : trustScore >= 70
            ? const Color(0xFFF59E0B)
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              Text(
                cat['icon'] as String,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 10),
              Text(
                cat['category'] as String,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Trust score badge
              Container(
                width: 56,
                height: 56,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: trustScore / 100,
                      strokeWidth: 5,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation(scoreColor),
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        '${trustScore.toInt()}',
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Metrics
          _buildMetricRow(
            'Star Rating',
            '${starRating} ⭐',
            starRating / 5,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 10),
          _buildMetricRow(
            'Text Approval (NLP)',
            '${textApproval.toInt()}%',
            textApproval / 100,
            AppColors.primary,
          ),
          const SizedBox(height: 14),

          // Review count row
          Row(
            children: [
              _buildReviewCountChip(
                '✅ $positiveReviews Positive',
                AppColors.success,
              ),
              const SizedBox(width: 8),
              _buildReviewCountChip(
                '❌ ${totalReviews - positiveReviews} Negative',
                AppColors.error,
              ),
              const Spacer(),
              Text(
                '$totalReviews total reviews',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
      String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCountChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── REVIEW CARD ──
  Widget _buildReviewCard(Map<String, dynamic> review) {
    final isPositive = review['sentiment'] == 'Positive';
    final stars = review['stars'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              Row(
                children: [
                  Text(
                    review['customer'] as String,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      review['category'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                review['date'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Star rating
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                color: const Color(0xFFF59E0B),
                size: 14,
              ),
            ),
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
          const SizedBox(height: 8),

          // NLP Sentiment badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isPositive
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_down_rounded,
                  color:
                      isPositive ? AppColors.success : AppColors.error,
                  size: 11,
                ),
                const SizedBox(width: 4),
                Text(
                  'NLP: ${review['sentiment']}',
                  style: TextStyle(
                    color: isPositive
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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