import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AnimatedInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final ValueChanged<bool>? onValidationChanged;
  final bool isPassword;
  final bool passwordVisible;
  final VoidCallback? onPasswordToggle;
  final TextInputType keyboardType;

  const AnimatedInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.onValidationChanged,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onPasswordToggle,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isValid = false;
  bool _showCheckmark = false;
  String? _errorMessage;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.02, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    widget.controller.addListener(_validateInput);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus && widget.controller.text.isNotEmpty) {
      _validateInput();
    }
  }

  void _validateInput() {
    final error = widget.validator(widget.controller.text);
    final isValid = error == null;

    if (isValid && !_isValid && widget.controller.text.isNotEmpty) {
      // Validation just passed
      _animationController.forward(from: 0);
      Vibration.vibrate(duration: 100);
      setState(() {
        _showCheckmark = true;
      });

      // Hide checkmark after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCheckmark = false;
          });
        }
      });
    } else if (!isValid && _isValid) {
      // Validation just failed - shake animation
      _showInvalidShake();
      Vibration.vibrate(duration: 200);
    }

    setState(() {
      _isValid = isValid;
      _errorMessage = error;
    });

    // Call the callback in the next frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onValidationChanged?.call(isValid);
    });
  }

  void _showInvalidShake() {
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_validateInput);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.isPassword && !widget.passwordVisible,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  labelText: widget.label,
                  prefixIcon: Icon(widget.icon, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: _isFocused
                      ? Colors.deepPurple[50]
                      : Colors.grey[50],
                  suffixIcon: _buildSuffixIcon(),
                ),
                validator: widget.validator,
              ),
            ),
          ),
        ),
        if (_showCheckmark && _isValid)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.elasticOut,
                    ),
                  ),
                  child: const Text(
                    '✅ Great!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_errorMessage != null && _isFocused)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  const Text(
                    '⚠️ ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          widget.passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
          color: Colors.deepPurple,
        ),
        onPressed: widget.onPasswordToggle,
      );
    }
    if (_showCheckmark && _isValid) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('✅', style: TextStyle(fontSize: 18)),
        ),
      );
    }
    return null;
  }
}
