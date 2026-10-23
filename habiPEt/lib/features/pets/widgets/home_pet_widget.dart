import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pet_model.dart';
import '../models/pet_growth_stage.dart';
import '../controller/pet_animation_controller.dart';
import 'living_pet_painter.dart';

class HomePetWidget extends StatefulWidget {
  final PetModel pet;
  final double size;
  final VoidCallback? onTap;
  final bool showStageBadge;
  final PetAnimationController? animationController;

  const HomePetWidget({
    super.key,
    required this.pet,
    this.size = 180,
    this.onTap,
    this.showStageBadge = true,
    this.animationController,
  });

  @override
  State<HomePetWidget> createState() => HomePetWidgetState();
}

class HomePetWidgetState extends State<HomePetWidget>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _reactionController;
  late final AnimationController _blinkController;
  late final AnimationController _evolveController;

  late final Animation<double> _breathAnimation;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _blinkAnimation;
  late final Animation<double> _reactionAnimation;

  Timer? _blinkTimer;
  PetAnimationController? _internalController;
  PetAnimationController get _animCtrl =>
      widget.animationController ?? (_internalController ??= PetAnimationController());

  // Floating tap heart particles
  final List<_FloatingParticle> _particles = [];
  int _prevLevel = 1;
  PetGrowthStage? _prevStage;

  @override
  void initState() {
    super.initState();
    _prevLevel = widget.pet.level;
    _prevStage = widget.pet.growthStage;

    // 1. Idle Breathing Animation (2200ms loop)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _breathAnimation = CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOutSine,
    );

    // 2. Bounce Animation
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutQuad),
    );

    // 3. Eye Blinking Animation (150ms quick blink)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 55),
    ]).animate(_blinkController);

    _startBlinkTimer();

    // 4. Tap / Happy Reaction Controller
    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _reactionAnimation = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.easeOutBack,
    );

    // 5. Evolve Animation Controller
    _evolveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  void _startBlinkTimer() {
    _blinkTimer?.cancel();
    final nextBlinkMs = 2800 + math.Random().nextInt(2200);
    _blinkTimer = Timer(Duration(milliseconds: nextBlinkMs), () {
      if (mounted) {
        _blinkController.forward(from: 0.0);
        _startBlinkTimer();
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomePetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Detect level up or stage evolution to trigger celebration
    if (widget.pet.level > _prevLevel) {
      if (widget.pet.growthStage != _prevStage) {
        triggerEvolution();
      } else {
        triggerHappy();
      }
      _prevLevel = widget.pet.level;
      _prevStage = widget.pet.growthStage;
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _idleController.dispose();
    _reactionController.dispose();
    _blinkController.dispose();
    _evolveController.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  void triggerHappy() {
    HapticFeedback.lightImpact();
    _animCtrl.triggerHappy();
    _reactionController.forward(from: 0.0);
    _spawnParticles();
  }

  void triggerEvolution() {
    HapticFeedback.heavyImpact();
    _animCtrl.triggerEvolve();
    _evolveController.forward(from: 0.0);
    _spawnParticles(count: 8, isGold: true);
  }

  void _spawnParticles({int count = 4, bool isGold = false}) {
    final rand = math.Random();
    setState(() {
      for (int i = 0; i < count; i++) {
        _particles.add(
          _FloatingParticle(
            dx: (rand.nextDouble() - 0.5) * widget.size * 0.8,
            dy: -rand.nextDouble() * 20.0,
            emoji: isGold
                ? (rand.nextBool() ? '✨' : '🌟')
                : (rand.nextBool() ? '💖' : '✨'),
          ),
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }

  void _handleTap() {
    triggerHappy();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final stage = pet.growthStage;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final accentColor = AppColors.accentGold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Stage Badge Header (if enabled)
        if (widget.showStageBadge) ...[
          _StagePillBadge(pet: pet),
          const SizedBox(height: 8),
        ],

        // 2. Interactive Pet Canvas
        GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated Custom Painter (Living Pet)
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _idleController,
                    _blinkController,
                    _reactionController,
                    _evolveController,
                    _animCtrl,
                  ]),
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: LivingPetPainter(
                        petType: pet.type,
                        stage: stage,
                        breathValue: _breathAnimation.value,
                        bounceValue: _bounceAnimation.value,
                        blinkValue: _blinkAnimation.value,
                        reactionValue: _reactionAnimation.value,
                        mood: _animCtrl.mood,
                        primaryColor: primaryColor,
                        accentColor: accentColor,
                      ),
                    );
                  },
                ),

                // Floating Hearts / Sparkles on Tap
                ..._particles.map((p) => _AnimatedParticleItem(particle: p)),

                // Evolution Light Flash
                if (_animCtrl.isEvolving)
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.8, end: 0.0)
                        .animate(_evolveController),
                    child: Container(
                      width: widget.size * 0.9,
                      height: widget.size * 0.9,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0x99FFE066),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // 3. Stage Growth Helper Text
        const SizedBox(height: 6),
        Text(
          pet.stageDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _StagePillBadge extends StatelessWidget {
  final PetModel pet;

  const _StagePillBadge({required this.pet});

  @override
  Widget build(BuildContext context) {
    final stage = pet.growthStage;

    Color badgeBg;
    Color badgeBorder;
    Color badgeText;

    switch (stage) {
      case PetGrowthStage.baby:
        badgeBg = const Color(0xFF55B398).withValues(alpha: 0.15);
        badgeBorder = const Color(0xFF55B398).withValues(alpha: 0.4);
        badgeText = const Color(0xFF55B398);
        break;
      case PetGrowthStage.junior:
        badgeBg = const Color(0xFF38BDF8).withValues(alpha: 0.15);
        badgeBorder = const Color(0xFF38BDF8).withValues(alpha: 0.4);
        badgeText = const Color(0xFF0284C7);
        break;
      case PetGrowthStage.teen:
        badgeBg = const Color(0xFFF97316).withValues(alpha: 0.15);
        badgeBorder = const Color(0xFFF97316).withValues(alpha: 0.4);
        badgeText = const Color(0xFFEA580C);
        break;
      case PetGrowthStage.adult:
        badgeBg = const Color(0xFFFFF0D9);
        badgeBorder = const Color(0xFFF1C98D);
        badgeText = const Color(0xFF996018);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: badgeBorder, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(stage.badgeEmoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            '${stage.displayName} • ${stage.stageRangeText}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: badgeText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingParticle {
  final double dx;
  final double dy;
  final String emoji;

  _FloatingParticle({
    required this.dx,
    required this.dy,
    required this.emoji,
  });
}

class _AnimatedParticleItem extends StatefulWidget {
  final _FloatingParticle particle;

  const _AnimatedParticleItem({required this.particle});

  @override
  State<_AnimatedParticleItem> createState() => _AnimatedParticleItemState();
}

class _AnimatedParticleItemState extends State<_AnimatedParticleItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _translateY;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _translateY = Tween<double>(begin: 0.0, end: -60.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 80),
    ]).animate(_controller);

    _scale = Tween<double>(begin: 0.5, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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
      animation: _controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(widget.particle.dx, widget.particle.dy + _translateY.value),
          child: Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Text(
                widget.particle.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
        );
      },
    );
  }
}
