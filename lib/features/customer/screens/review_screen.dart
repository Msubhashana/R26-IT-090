import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';
import 'package:fixmate_app/data/mock_data.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _selectedStars = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitted = false;
  String _detectedSentiment = '';

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Simulate NLP sentiment detection
  void _analyzeSentiment(String text) {
    final positiveWords = [
      'good', 'great', 'excellent', 'honda', 'bohoma', 'happy',
      'satisfied', 'perfect', 'nice', 'fast', 'quick', 'professional',
      'thank', 'best', 'fix', 'worked', 'clean', 'friendly'
    ];
    final negativeWords = [
      'bad', 'poor', 'slow', 'late', 'worst', 'unhappy', 'wrong',
      'broken', 'issue', 'problem', 'not', 'never', 'waste', 'dirty'
    ];

    final lowerText = text.toLowerCase();
    int positiveCount = positiveWords
        .where((w) => lowerText.contains(w))
        .length;
    int negativeCount = negativeWords
        .where((w) => lowerText.contains(w))
        .length;

    if (text.isEmpty) {
      setState(() => _detectedSentiment = '');
    } else if (positiveCount >= negativeCount) {
      setState(() => _detectedSentiment = 'Positive');
    } else {
      setState(() => _detectedSentiment = 'Negative');
    }
  }

  void _submitReview() {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a review'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _isSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final worker =
        ModalRoute.of(context)!.settings.arguments as MockWorker;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave a Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isSubmitted
          ? _buildSuccessScreen(context, worker)
          : _buildReviewForm(context, worker),
    );
  }

  // ── REVIEW FORM ──
  Widget _buildReviewForm(BuildContext context, MockWorker worker) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verified job badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.success.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_rounded,
                    color: AppColors.success, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified Job Completion',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'This review is unlocked only because the job was completed. No fake reviews allowed.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Worker info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(worker.avatarColor),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      worker.initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      worker.category,
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
          const SizedBox(height: 24),

          // Star rating
          const Text(
            'Star Rating',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedStars = index + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      index < _selectedStars
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: index < _selectedStars
                          ? const Color(0xFFF59E0B)
                          : AppColors.surfaceLight,
                      size: 44,
                    ),
                  ),
                );
              }),
            ),
          ),
          if (_selectedStars > 0)
            Center(
              child: Text(
                [
                  '',
                  'Poor 😞',
                  'Fair 😐',
                  'Good 🙂',
                  'Very Good 😊',
                  'Excellent 🤩'
                ][_selectedStars],
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Text review
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Written Review',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Live sentiment badge
              if (_detectedSentiment.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _detectedSentiment == 'Positive'
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _detectedSentiment == 'Positive'
                          ? AppColors.success.withOpacity(0.4)
                          : AppColors.error.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _detectedSentiment == 'Positive'
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_down_rounded,
                        color: _detectedSentiment == 'Positive'
                            ? AppColors.success
                            : AppColors.error,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'NLP: $_detectedSentiment',
                        style: TextStyle(
                          color: _detectedSentiment == 'Positive'
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
          const SizedBox(height: 8),

          // Singlish hint
          const Text(
            '💬 Write in Singlish or English — both are fine!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),

          // Text area
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceLight),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 5,
              minLines: 4,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.6,
              ),
              onChanged: _analyzeSentiment,
              decoration: const InputDecoration(
                hintText:
                    'e.g. "Bohoma honda service. Watura bata fix una binduma. Very professional!"',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // NLP explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Our NLP model analyzes your text sentiment and fuses it with your star rating to generate the worker\'s Intelligent Trust Score.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          ElevatedButton.icon(
            onPressed: _submitReview,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Submit Review'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── SUCCESS SCREEN ──
  Widget _buildSuccessScreen(BuildContext context, MockWorker worker) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.success.withOpacity(0.4), width: 2),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Review Submitted!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you! Our NLP model has analyzed your review and updated the worker\'s Trust Score.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Score update card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceLight),
              ),
              child: Column(
                children: [
                  const Text(
                    'Trust Score Updated',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${worker.trustScore.toInt()}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: AppColors.success, size: 20),
                      Text(
                        '${(worker.trustScore + 1).toInt()}',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _detectedSentiment == 'Positive'
                              ? AppColors.success.withOpacity(0.15)
                              : AppColors.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NLP Sentiment: $_detectedSentiment',
                          style: TextStyle(
                            color: _detectedSentiment == 'Positive'
                                ? AppColors.success
                                : AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}