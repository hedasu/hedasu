import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PetCharacter extends StatefulWidget {
  final PetType type;
  final double size;
  final bool isHappy;

  const PetCharacter({
    super.key,
    required this.type,
    this.size = 140,
    this.isHappy = false,
  });

  @override
  State<PetCharacter> createState() => _PetCharacterState();
}

class _PetCharacterState extends State<PetCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: child,
        );
      },
      child: _PetGraphicContainer(
        type: widget.type,
        size: widget.size,
        isHappy: widget.isHappy,
      ),
    );
  }
}

class _PetGraphicContainer extends StatelessWidget {
  final PetType type;
  final double size;
  final bool isHappy;

  const _PetGraphicContainer({
    required this.type,
    required this.size,
    required this.isHappy,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            primaryColor.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _PetAvatarCircle(type: type, size: size * 0.8),
          if (isHappy)
            const Positioned(
              top: 4,
              right: 12,
              child: Text('✨', style: TextStyle(fontSize: 22)),
            ),
        ],
      ),
    );
  }
}

class _PetAvatarCircle extends StatelessWidget {
  final PetType type;
  final double size;

  const _PetAvatarCircle({
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.25),
            scheme.secondary.withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.6),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        type.emoji,
        style: TextStyle(fontSize: size * 0.52),
      ),
    );
  }
}
