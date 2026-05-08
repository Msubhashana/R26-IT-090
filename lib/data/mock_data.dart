class MockWorker {
  final String id;
  final String name;
  final String category;
  final double trustScore;
  final double starRating;
  final double distanceKm;
  final int completedJobs;
  final int nvqLevel;
  final String avgTime;
  final bool isOnline;
  final String initial;
  final int avatarColor;

  MockWorker({
    required this.id,
    required this.name,
    required this.category,
    required this.trustScore,
    required this.starRating,
    required this.distanceKm,
    required this.completedJobs,
    required this.nvqLevel,
    required this.avgTime,
    required this.isOnline,
    required this.initial,
    required this.avatarColor,
  });
}

class MockData {
  static List<MockWorker> getWorkers(String category) {
    return [
      MockWorker(
        id: '1',
        name: 'Nimal Silva',
        category: category,
        trustScore: 92,
        starRating: 4.8,
        distanceKm: 2.4,
        completedJobs: 47,
        nvqLevel: 5,
        avgTime: '1.2h',
        isOnline: true,
        initial: 'N',
        avatarColor: 0xFF1E3A5F,
      ),
      MockWorker(
        id: '2',
        name: 'Sunil Rathnayake',
        category: category,
        trustScore: 85,
        starRating: 4.5,
        distanceKm: 3.8,
        completedJobs: 33,
        nvqLevel: 4,
        avgTime: '1.5h',
        isOnline: true,
        initial: 'S',
        avatarColor: 0xFF1A3D2B,
      ),
      MockWorker(
        id: '3',
        name: 'Kamal Perera',
        category: category,
        trustScore: 78,
        starRating: 4.2,
        distanceKm: 5.1,
        completedJobs: 28,
        nvqLevel: 4,
        avgTime: '1.8h',
        isOnline: true,
        initial: 'K',
        avatarColor: 0xFF3B1F6E,
      ),
      MockWorker(
        id: '4',
        name: 'Ruwan Fernando',
        category: category,
        trustScore: 74,
        starRating: 4.0,
        distanceKm: 6.3,
        completedJobs: 21,
        nvqLevel: 3,
        avgTime: '2.0h',
        isOnline: true,
        initial: 'R',
        avatarColor: 0xFF3D1A1A,
      ),
      MockWorker(
        id: '5',
        name: 'Chamara Wijesinghe',
        category: category,
        trustScore: 69,
        starRating: 3.9,
        distanceKm: 7.0,
        completedJobs: 15,
        nvqLevel: 3,
        avgTime: '2.2h',
        isOnline: false,
        initial: 'C',
        avatarColor: 0xFF1A3D3D,
      ),
      MockWorker(
        id: '6',
        name: 'Pradeep Jayasekara',
        category: category,
        trustScore: 65,
        starRating: 3.7,
        distanceKm: 8.5,
        completedJobs: 12,
        nvqLevel: 2,
        avgTime: '2.5h',
        isOnline: true,
        initial: 'P',
        avatarColor: 0xFF2D3D1A,
      ),
    ];
  }
}