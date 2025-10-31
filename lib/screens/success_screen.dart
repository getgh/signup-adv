import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import '../widgets/achievement_badges.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final int selectedAvatar;
  final bool hasStrongPassword;
  final bool isEarlyBird;

  const SuccessScreen({
    super.key,
    required this.userName,
    required this.selectedAvatar,
    required this.hasStrongPassword,
    required this.isEarlyBird,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confettiController;

  final List<String> avatarEmojis = ['🦸', '🧙', '🚀', '🎮', '🏴‍☠️'];
  final List<String> avatarNames = ['Superhero', 'Wizard', 'Astronaut', 'Gamer', 'Pirate'];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.deepPurple,
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.orange,
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome, ${widget.userName}! 🎉',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple[300]!, Colors.deepPurple[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Your Avatar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          avatarEmojis[widget.selectedAvatar],
                          style: const TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          avatarNames[widget.selectedAvatar],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  AchievementBadges(
                    hasStrongPassword: widget.hasStrongPassword,
                    isEarlyBird: widget.isEarlyBird,
                    hasCompletedProfile: true,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Your adventure begins now!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _confettiController.play();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'More Celebration!',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.celebration, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
