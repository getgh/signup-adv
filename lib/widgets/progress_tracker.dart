import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ProgressTracker extends StatefulWidget {
  final int completedFields;
  final int totalFields;
  final Function(int) onMilestone;

  const ProgressTracker({
    super.key,
    required this.completedFields,
    required this.totalFields,
    required this.onMilestone,
  });

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousMilestone = 0;
  String _milestoneMessage = '';
  bool _showMilestoneMessage = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(ProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completedFields != widget.completedFields) {
      final newProgress = (widget.completedFields / widget.totalFields) * 100;
      
      _animation = Tween<double>(
        begin: _animation.value,
        end: newProgress / 100,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);

      // Check for milestones
      _checkMilestones(newProgress);
    }
  }

  void _checkMilestones(double progress) {
    int currentMilestone = 0;

    if (progress >= 100) {
      currentMilestone = 100;
    } else if (progress >= 75) {
      currentMilestone = 75;
    } else if (progress >= 50) {
      currentMilestone = 50;
    } else if (progress >= 25) {
      currentMilestone = 25;
    }

    if (currentMilestone > _previousMilestone && currentMilestone > 0) {
      _showMilestoneAchievement(currentMilestone);
      _previousMilestone = currentMilestone;
      widget.onMilestone(currentMilestone);
    }
  }

  void _showMilestoneAchievement(int milestone) {
    final messages = {
      25: '🚀 Great start!',
      50: '⚡ Halfway there!',
      75: '🎯 Almost done!',
      100: '🎉 Ready for adventure!',
    };

    setState(() {
      _milestoneMessage = messages[milestone] ?? '';
      _showMilestoneMessage = true;
    });

    // Haptic feedback
    Vibration.vibrate(duration: 200);

    // Hide message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showMilestoneMessage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.completedFields / widget.totalFields;
    final percentage = (progress * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Adventure Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Animated Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LinearProgressIndicator(
                minHeight: 12,
                value: _animation.value,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(_animation.value),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Milestone Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMilestoneIndicator(0, 25, progress),
            _buildMilestoneIndicator(25, 50, progress),
            _buildMilestoneIndicator(50, 75, progress),
            _buildMilestoneIndicator(75, 100, progress),
          ],
        ),

        // Milestone Message
        if (_showMilestoneMessage)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple[300]!, Colors.deepPurple[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _milestoneMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMilestoneIndicator(int from, int to, double progress) {
    final percentage = (progress * 100);
    final isReached = percentage >= to;
    final isActive = percentage >= from && percentage < to;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached ? Colors.green : (isActive ? Colors.amber : Colors.grey[300]),
            border: Border.all(
              color: isActive ? Colors.amber : Colors.grey[400]!,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '${to ~/ 25}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isReached ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$to%',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.25) return Colors.red;
    if (value < 0.5) return Colors.orange;
    if (value < 0.75) return Colors.amber;
    return Colors.green;
  }
}
