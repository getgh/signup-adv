import 'package:flutter/material.dart';

class AvatarSelector extends StatefulWidget {
  final ValueChanged<int> onAvatarSelected;
  final int initialAvatar;

  const AvatarSelector({
    super.key,
    required this.onAvatarSelected,
    this.initialAvatar = 0,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector>
    with SingleTickerProviderStateMixin {
  late int _selectedAvatar;
  late AnimationController _animationController;

  final List<Map<String, String>> avatars = [
    {'emoji': '🦸', 'name': 'Superhero'},
    {'emoji': '🧙', 'name': 'Wizard'},
    {'emoji': '🚀', 'name': 'Astronaut'},
    {'emoji': '🎮', 'name': 'Gamer'},
    {'emoji': '🏴‍☠️', 'name': 'Pirate'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.initialAvatar;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAvatar(int index) {
    setState(() {
      _selectedAvatar = index;
    });
    widget.onAvatarSelected(index);
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Avatar 🎨',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              avatars.length,
              (index) => _buildAvatarOption(index),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(width: 8),
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Text(
                  '${avatars[_selectedAvatar]['emoji']} ${avatars[_selectedAvatar]['name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarOption(int index) {
    final isSelected = index == _selectedAvatar;
    return GestureDetector(
      onTap: () => _selectAvatar(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 70 : 60,
        height: isSelected ? 70 : 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.deepPurple : Colors.grey[200],
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            avatars[index]['emoji']!,
            style: TextStyle(
              fontSize: isSelected ? 32 : 28,
            ),
          ),
        ),
      ),
    );
  }
}
