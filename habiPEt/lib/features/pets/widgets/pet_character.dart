import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pet_model.dart';
import '../models/pet_growth_stage.dart';
import '../controller/pet_animation_controller.dart';
import 'living_pet_painter.dart';

class PetCharacter extends StatefulWidget {
  final PetType type;
  final double size;
  final bool isHappy;
  final PetGrowthStage stage;

  const PetCharacter({
    super.key,
    required this.type,
    this.size = 140,
    this.isHappy = false,
    this.stage = PetGrowthStage.baby,
  });

  @override
  State<PetCharacter> createState() => _PetCharacterState();
}

class _PetCharacterState extends State<PetCharacter>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _blinkController;
  late final Animation<double> _breathAnimation;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _blinkAnimation;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _breathAnimation = CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOutSine,
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutQuad),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 55),
    ]).animate(_blinkController);

    _startBlinkTimer();
  }

  void _startBlinkTimer() {
    _blinkTimer?.cancel();
    final ms = 3000 + math.Random().nextInt(2000);
    _blinkTimer = Timer(Duration(milliseconds: ms), () {
      if (mounted) {
        _blinkController.forward(from: 0.0);
        _startBlinkTimer();
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _idleController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _blinkController]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: LivingPetPainter(
            petType: widget.type,
            stage: widget.stage,
            breathValue: _breathAnimation.value,
            bounceValue: _bounceAnimation.value,
            blinkValue: _blinkAnimation.value,
            reactionValue: widget.isHappy ? 1.0 : 0.0,
            mood: widget.isHappy ? PetMoodState.happy : PetMoodState.idle,
            primaryColor: theme.colorScheme.primary,
            accentColor: AppColors.accentGold,
          ),
        );
      },
    );
  }
}
