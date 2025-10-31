import 'package:flutter/material.dart';

class AchievementBadges extends StatefulWidget {
  final bool hasStrongPassword;
  final bool isEarlyBird;
  final bool hasCompletedProfile;

  const AchievementBadges({
    super.key,
    required this.hasStrongPassword,
    required this.isEarlyBird,
    required this.hasCompletedProfile,
  });

  @override
  State<AchievementBadges> createState() => _AchievementBadgesState();
}

class _AchievementBadgesState extends State<AchievementBadges>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(AchievementBadges oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newBadgesEarned = (widget.hasStrongPassword || widget.isEarlyBird || widget.hasCompletedProfile) &&
        (!oldWidget.hasStrongPassword || !oldWidget.isEarlyBird || !oldWidget.hasCompletedProfile);

    if (newBadgesEarned) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badges = [
      {
        'earned': widget.hasStrongPassword,
        'icon': '💪',
        'title': 'Strong Password Master',
        'description': 'Created a strong password',
      },
      {
        'earned': widget.isEarlyBird,
        'icon': '🌅',
        'title': 'Early Bird Special',
        'description': 'Signed up before 12 PM',
      },
      {
        'earned': widget.hasCompletedProfile,
        'icon': '✅',
        'title': 'Profile Completer',
        'description': 'Filled all fields',
      },
    ];

    final earnedBadges = badges.where((b) => b['earned'] as bool).toList();

    if (earnedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements Unlocked! 🏆',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            earnedBadges.length,
            (index) => _buildBadge(
              earnedBadges[index],
              index,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(Map<String, dynamic> badge, int index) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0),
            ((index + 1) * 0.15).clamp(0.0, 1.0),
            curve: Curves.elasticOut,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[400]!, Colors.orange[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              badge['icon'] as String,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  badge['title'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  badge['description'] as String,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
