import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';
import 'package:fixmate_app/features/auth/screens/onboarding_screen.dart';
import 'package:fixmate_app/features/auth/screens/login_screen.dart';
import 'package:fixmate_app/features/customer/screens/home_screen.dart';
import 'package:fixmate_app/features/customer/screens/worker_list_screen.dart';
import 'package:fixmate_app/features/customer/screens/worker_profile_screen.dart';
import 'package:fixmate_app/features/customer/screens/progress_screen.dart';
import 'package:fixmate_app/features/customer/screens/review_screen.dart';
import 'package:fixmate_app/features/customer/screens/history_screen.dart';
import 'package:fixmate_app/features/customer/screens/profile_screen.dart';
import 'package:fixmate_app/features/worker/screens/worker_register_screen.dart';
import 'package:fixmate_app/features/worker/screens/worker_dashboard_screen.dart';
import 'package:fixmate_app/features/worker/screens/worker_job_view_screen.dart';
import 'package:fixmate_app/features/worker/screens/worker_ratings_screen.dart';

void main() {
  runApp(const FixMateApp());
}

class FixMateApp extends StatelessWidget {
  const FixMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixMate LK',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/workers': (context) => const WorkerListScreen(),
        '/worker-profile': (context) => const WorkerProfileScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/review': (context) => const ReviewScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/worker-register': (context) => const WorkerRegisterScreen(),
        '/worker-dashboard': (context) => const WorkerDashboardScreen(),
        '/worker-job-view': (context) => const WorkerJobViewScreen(),
        '/worker-ratings': (context) => const WorkerRatingsScreen(),
      },
    );
  }
}