import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatefulWidget {
  final String password;
  final ValueChanged<int>? onStrengthChanged;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.onStrengthChanged,
  });

  @override
  State<PasswordStrengthMeter> createState() => _PasswordStrengthMeterState();
}

class _PasswordStrengthMeterState extends State<PasswordStrengthMeter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(PasswordStrengthMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.password != widget.password) {
      final newStrength = _calculateStrength(widget.password);
      widget.onStrengthChanged?.call(newStrength);
      
      _animation = Tween<double>(
        begin: _animation.value,
        end: (newStrength / 100).clamp(0.0, 1.0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
    }
  }

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length scoring
    if (password.length >= 6) strength += 20;
    if (password.length >= 8) strength += 10;
    if (password.length >= 12) strength += 10;

    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) strength += 15;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 15;
    if (password.contains(RegExp(r'[0-9]'))) strength += 15;
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:,.<>?]'))) strength += 15;

    return strength.clamp(0, 100);
  }

  Color _getColorForStrength(int strength) {
    if (strength < 25) return Colors.red;
    if (strength < 50) return Colors.orange;
    if (strength < 75) return Colors.amber;
    return Colors.green;
  }

  String _getStrengthLabel(int strength) {
    if (strength < 25) return 'Weak';
    if (strength < 50) return 'Fair';
    if (strength < 75) return 'Good';
    return 'Strong 💪';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int strength = _calculateStrength(widget.password);
    Color strengthColor = _getColorForStrength(strength);
    String label = _getStrengthLabel(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password Strength:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: strengthColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: (strength / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          ),
        ),
        if (strength > 0 && strength < 75)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _getStrengthHint(strength),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  String _getStrengthHint(int strength) {
    if (strength < 25) {
      return 'Add more characters and mix uppercase, numbers, and symbols';
    } else if (strength < 50) {
      return 'Add uppercase letters, numbers, or special characters';
    } else if (strength < 75) {
      return 'Almost there! Consider adding special characters';
    }
    return '';
  }
}
