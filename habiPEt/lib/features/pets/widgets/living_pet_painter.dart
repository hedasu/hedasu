import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/pet_growth_stage.dart';
import '../controller/pet_animation_controller.dart';

class LivingPetPainter extends CustomPainter {
  final PetType petType;
  final PetGrowthStage stage;
  final double breathValue; // 0.0 - 1.0 sinusoidal
  final double bounceValue; // 0.0 - 1.0 bounce offset
  final double blinkValue; // 0.0 (open) - 1.0 (closed)
  final double reactionValue; // 0.0 - 1.0 tap/happy burst
  final PetMoodState mood;
  final Color primaryColor;
  final Color accentColor;

  LivingPetPainter({
    required this.petType,
    required this.stage,
    required this.breathValue,
    required this.bounceValue,
    required this.blinkValue,
    required this.reactionValue,
    required this.mood,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.38 * stage.scaleFactor;

    // 1. Grounding Shadow
    _drawShadow(canvas, center, baseRadius, size);

    // 2. Ambient Aura / Particle Glow
    _drawAmbientAura(canvas, center, baseRadius);

    // Dynamic vertical bounce & breathing displacement
    final bounceY = -bounceValue * (mood == PetMoodState.happy ? 18.0 : 6.0);
    final breathScaleY = 1.0 + (breathValue * 0.04);
    final breathScaleX = 1.0 - (breathValue * 0.02);

    canvas.save();
    canvas.translate(center.dx, center.dy + bounceY);
    canvas.scale(breathScaleX, breathScaleY);

    // 3. Species-Specific Body & Anatomy
    _drawPetCharacter(canvas, Offset.zero, baseRadius);

    canvas.restore();

    // 4. Evolve / Level Up Rays
    if (mood == PetMoodState.evolve) {
      _drawEvolveRays(canvas, center, baseRadius);
    }
  }

  void _drawShadow(Canvas canvas, Offset center, double radius, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22 - (bounceValue * 0.08))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final shadowRect = Rect.fromCenter(
      center: Offset(center.dx, size.height * 0.90),
      width: radius * 1.5 * (1.0 - bounceValue * 0.25),
      height: 14 * (1.0 - bounceValue * 0.2),
    );
    canvas.drawOval(shadowRect, shadowPaint);
  }

  void _drawAmbientAura(Canvas canvas, Offset center, double radius) {
    Color auraColor;
    switch (stage) {
      case PetGrowthStage.baby:
        auraColor = primaryColor.withValues(alpha: 0.15 + (breathValue * 0.05));
        break;
      case PetGrowthStage.junior:
        auraColor = const Color(0xFF55B398).withValues(alpha: 0.20 + (breathValue * 0.08));
        break;
      case PetGrowthStage.teen:
        auraColor = const Color(0xFFF0AA3C).withValues(alpha: 0.22 + (breathValue * 0.10));
        break;
      case PetGrowthStage.adult:
        auraColor = const Color(0xFFFFD166).withValues(alpha: 0.30 + (breathValue * 0.15));
        break;
    }

    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          auraColor,
          auraColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.6));

    canvas.drawCircle(center, radius * 1.5, auraPaint);
  }

  void _drawPetCharacter(Canvas canvas, Offset origin, double r) {
    switch (petType) {
      case PetType.cat:
        _drawCat(canvas, origin, r);
        break;
      case PetType.dog:
        _drawDog(canvas, origin, r);
        break;
      case PetType.bunny:
        _drawBunny(canvas, origin, r);
        break;
      case PetType.fox:
        _drawFox(canvas, origin, r);
        break;
      case PetType.owl:
        _drawOwl(canvas, origin, r);
        break;
      case PetType.dragon:
        _drawDragon(canvas, origin, r);
        break;
    }
  }

  // ===========================================================================
  // 🐱 CAT (Kedi - Mırnav)
  // ===========================================================================
  void _drawCat(Canvas canvas, Offset o, double r) {
    final bodyColor = const Color(0xFFFFA952);
    final shadowFurColor = const Color(0xFFE68A2E);
    final creamColor = const Color(0xFFFFF6ED);
    final innerEarColor = const Color(0xFFFF9EAA);

    // Tail (swishing)
    final tailAngle = math.sin(breathValue * math.pi * 2) * 0.25 + (reactionValue * 0.6);
    final tailPath = Path();
    tailPath.moveTo(o.dx + r * 0.65, o.dy + r * 0.45);
    tailPath.cubicTo(
      o.dx + r * 1.1 + math.cos(tailAngle) * 15,
      o.dy + r * 0.2,
      o.dx + r * 1.15,
      o.dy - r * 0.3 + math.sin(tailAngle) * 20,
      o.dx + r * 0.85,
      o.dy - r * 0.5,
    );
    final tailPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.22;
    canvas.drawPath(tailPath, tailPaint);

    // White Tail Tip
    final tailTipPaint = Paint()
      ..color = creamColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.22;
    final tipPath = Path();
    tipPath.moveTo(o.dx + r * 1.0, o.dy - r * 0.35);
    tipPath.lineTo(o.dx + r * 0.85, o.dy - r * 0.5);
    canvas.drawPath(tipPath, tailTipPaint);

    // Ears
    _drawTriangleEar(
      canvas,
      Offset(o.dx - r * 0.58, o.dy - r * 0.65),
      Offset(o.dx - r * 0.85, o.dy - r * 1.15),
      Offset(o.dx - r * 0.25, o.dy - r * 0.80),
      bodyColor,
      innerEarColor,
    );
    _drawTriangleEar(
      canvas,
      Offset(o.dx + r * 0.58, o.dy - r * 0.65),
      Offset(o.dx + r * 0.85, o.dy - r * 1.15),
      Offset(o.dx + r * 0.25, o.dy - r * 0.80),
      bodyColor,
      innerEarColor,
    );

    // Main Head/Body
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [bodyColor, shadowFurColor],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.85, height: r * 1.65),
      headPaint,
    );

    // Cream Muzzle Patch
    final muzzlePaint = Paint()..color = creamColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy + r * 0.22), width: r * 0.95, height: r * 0.65),
      muzzlePaint,
    );

    // Cute Nose & Mouth
    _drawNoseAndMouth(canvas, Offset(o.dx, o.dy + r * 0.12), r);

    // Whiskers
    _drawWhiskers(canvas, o, r);

    // Expressive Eyes
    _drawEyes(canvas, o, r, eyeColor: const Color(0xFF2C3E50));

    // Stage Accessories & Evolution Details
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // 🐶 DOG (Köpek - Karabaş)
  // ===========================================================================
  void _drawDog(Canvas canvas, Offset o, double r) {
    final dogFur = const Color(0xFFD38B5D);
    final darkFur = const Color(0xFFB56A3C);
    final creamPatch = const Color(0xFFFFF9F2);

    // Wagging Tail
    final wag = math.sin(breathValue * math.pi * 3) * 0.35 + (reactionValue * 0.8);
    final tailPaint = Paint()
      ..color = dogFur
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.22;
    final tailPath = Path()
      ..moveTo(o.dx + r * 0.6, o.dy + r * 0.45)
      ..quadraticBezierTo(
        o.dx + r * 1.1 + math.sin(wag) * 15,
        o.dy + r * 0.1,
        o.dx + r * 1.0,
        o.dy - r * 0.3,
      );
    canvas.drawPath(tailPath, tailPaint);

    // Floppy Puppy Ears
    final earBounce = math.sin(breathValue * math.pi * 2) * 4.0;
    _drawFloppyEar(canvas, Offset(o.dx - r * 0.72, o.dy - r * 0.4 + earBounce), r, true, darkFur);
    _drawFloppyEar(canvas, Offset(o.dx + r * 0.72, o.dy - r * 0.4 + earBounce), r, false, darkFur);

    // Head
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [dogFur, darkFur],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.82, height: r * 1.68),
      headPaint,
    );

    // Cream Forehead Patch
    final patchPaint = Paint()..color = creamPatch;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy - r * 0.2), width: r * 0.45, height: r * 0.75),
      patchPaint,
    );

    // Cream Snout
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy + r * 0.24), width: r * 1.0, height: r * 0.70),
      patchPaint,
    );

    // Nose & Happy Tongue (blep)
    _drawNoseAndMouth(canvas, Offset(o.dx, o.dy + r * 0.14), r, showTongue: true);

    // Eyes
    _drawEyes(canvas, o, r, eyeColor: const Color(0xFF3E2723));

    // Stage Accessories
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // 🐰 BUNNY (Tavşan - Pofuduk)
  // ===========================================================================
  void _drawBunny(Canvas canvas, Offset o, double r) {
    final furColor = const Color(0xFFFFFDF9);
    final shadowFur = const Color(0xFFEADFD5);
    final pinkEar = const Color(0xFFFFB4BE);

    // Long upright ears
    final earTwitch = math.sin(breathValue * math.pi * 2) * 0.08;
    _drawBunnyEar(canvas, Offset(o.dx - r * 0.38, o.dy - r * 0.6), r, -0.15 + earTwitch, furColor, pinkEar);
    _drawBunnyEar(canvas, Offset(o.dx + r * 0.38, o.dy - r * 0.6), r, 0.15 - earTwitch, furColor, pinkEar);

    // Head
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.15, -0.2),
        colors: [furColor, shadowFur],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.75, height: r * 1.60),
      headPaint,
    );

    // Rosy Cheeks
    _drawBlush(canvas, o, r);

    // Nose and rabbit mouth
    _drawBunnyNose(canvas, Offset(o.dx, o.dy + r * 0.16), r);

    // Eyes
    _drawEyes(canvas, o, r, eyeColor: const Color(0xFF4A2810));

    // Stage Accessories
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // 🦊 FOX (Tilki - Kızıl)
  // ===========================================================================
  void _drawFox(Canvas canvas, Offset o, double r) {
    final foxOrange = const Color(0xFFE65100);
    final darkOrange = const Color(0xFFBF360C);
    final whiteFur = const Color(0xFFFFFFFF);
    final earTipBlack = const Color(0xFF263238);

    // Bushy Fox Tail
    final tailPaint = Paint()
      ..color = foxOrange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.38;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(o.dx + r * 0.5, o.dy + r * 0.1), width: r * 1.3, height: r * 1.3),
      -math.pi * 0.4,
      math.pi * 0.9,
      false,
      tailPaint,
    );

    // Big Triangular Fox Ears
    _drawTriangleEar(
      canvas,
      Offset(o.dx - r * 0.55, o.dy - r * 0.65),
      Offset(o.dx - r * 0.92, o.dy - r * 1.30),
      Offset(o.dx - r * 0.20, o.dy - r * 0.85),
      foxOrange,
      whiteFur,
      tipColor: earTipBlack,
    );
    _drawTriangleEar(
      canvas,
      Offset(o.dx + r * 0.55, o.dy - r * 0.65),
      Offset(o.dx + r * 0.92, o.dy - r * 1.30),
      Offset(o.dx + r * 0.20, o.dy - r * 0.85),
      foxOrange,
      whiteFur,
      tipColor: earTipBlack,
    );

    // Head
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [foxOrange, darkOrange],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.80, height: r * 1.55),
      headPaint,
    );

    // White Cheek Flares & Muzzle
    final whitePath = Path()
      ..moveTo(o.dx - r * 0.80, o.dy + r * 0.1)
      ..quadraticBezierTo(o.dx - r * 0.35, o.dy + r * 0.05, o.dx, o.dy + r * 0.45)
      ..quadraticBezierTo(o.dx + r * 0.35, o.dy + r * 0.05, o.dx + r * 0.80, o.dy + r * 0.1)
      ..quadraticBezierTo(o.dx + r * 0.5, o.dy + r * 0.65, o.dx, o.dy + r * 0.65)
      ..quadraticBezierTo(o.dx - r * 0.5, o.dy + r * 0.65, o.dx - r * 0.80, o.dy + r * 0.1)
      ..close();
    canvas.drawPath(whitePath, Paint()..color = whiteFur);

    // Nose
    canvas.drawCircle(Offset(o.dx, o.dy + r * 0.22), r * 0.09, Paint()..color = const Color(0xFF212121));

    // Eyes
    _drawEyes(canvas, o, r, eyeColor: const Color(0xFF263238));

    // Stage Accessories
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // 🦉 OWL (Baykuş - Bilge)
  // ===========================================================================
  void _drawOwl(Canvas canvas, Offset o, double r) {
    final owlBrown = const Color(0xFF795548);
    final darkBrown = const Color(0xFF4E342E);
    final creamBelly = const Color(0xFFFFF3E0);

    // Ear Tufts
    final tuftPaint = Paint()..color = darkBrown;
    final leftTuft = Path()
      ..moveTo(o.dx - r * 0.6, o.dy - r * 0.65)
      ..lineTo(o.dx - r * 0.85, o.dy - r * 1.1)
      ..lineTo(o.dx - r * 0.35, o.dy - r * 0.8)
      ..close();
    canvas.drawPath(leftTuft, tuftPaint);

    final rightTuft = Path()
      ..moveTo(o.dx + r * 0.6, o.dy - r * 0.65)
      ..lineTo(o.dx + r * 0.85, o.dy - r * 1.1)
      ..lineTo(o.dx + r * 0.35, o.dy - r * 0.8)
      ..close();
    canvas.drawPath(rightTuft, tuftPaint);

    // Body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [owlBrown, darkBrown],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.85, height: r * 1.80),
      bodyPaint,
    );

    // Cream Feathered Breast
    final breastPaint = Paint()..color = creamBelly;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy + r * 0.25), width: r * 1.1, height: r * 1.0),
      breastPaint,
    );

    // Small chevron feather markings
    final markPaint = Paint()
      ..color = darkBrown.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(o.dx - 12, o.dy + r * 0.15 + (i * 12)),
        Offset(o.dx, o.dy + r * 0.22 + (i * 12)),
        markPaint,
      );
      canvas.drawLine(
        Offset(o.dx, o.dy + r * 0.22 + (i * 12)),
        Offset(o.dx + 12, o.dy + r * 0.15 + (i * 12)),
        markPaint,
      );
    }

    // Yellow Beak
    final beakPath = Path()
      ..moveTo(o.dx - r * 0.12, o.dy + r * 0.05)
      ..lineTo(o.dx + r * 0.12, o.dy + r * 0.05)
      ..lineTo(o.dx, o.dy + r * 0.24)
      ..close();
    canvas.drawPath(beakPath, Paint()..color = const Color(0xFFFFA000));

    // Big Round Wisdom Eyes
    _drawOwlEyes(canvas, o, r);

    // Stage Accessories
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // 🐲 DRAGON (Ejderha - Kıvılcım)
  // ===========================================================================
  void _drawDragon(Canvas canvas, Offset o, double r) {
    final dragonGreen = const Color(0xFF2E7D32);
    final darkGreen = const Color(0xFF1B5E20);
    final goldenScales = const Color(0xFFFFD54F);

    // Mini Wings
    final wingFlap = math.sin(breathValue * math.pi * 2) * 0.15;
    _drawDragonWing(canvas, Offset(o.dx - r * 0.85, o.dy - r * 0.2), r, true, wingFlap);
    _drawDragonWing(canvas, Offset(o.dx + r * 0.85, o.dy - r * 0.2), r, false, wingFlap);

    // Cute Horns
    final hornPaint = Paint()..color = goldenScales;
    _drawHorn(canvas, Offset(o.dx - r * 0.45, o.dy - r * 0.7), r, true, hornPaint);
    _drawHorn(canvas, Offset(o.dx + r * 0.45, o.dy - r * 0.7), r, false, hornPaint);

    // Body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [dragonGreen, darkGreen],
      ).createShader(Rect.fromCircle(center: o, radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy), width: r * 1.80, height: r * 1.65),
      bodyPaint,
    );

    // Golden Belly
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx, o.dy + r * 0.28), width: r * 0.95, height: r * 0.80),
      Paint()..color = goldenScales,
    );

    // Dragon Nostrils
    final nostrilPaint = Paint()..color = darkGreen;
    canvas.drawCircle(Offset(o.dx - r * 0.14, o.dy + r * 0.16), r * 0.05, nostrilPaint);
    canvas.drawCircle(Offset(o.dx + r * 0.14, o.dy + r * 0.16), r * 0.05, nostrilPaint);

    // Eyes
    _drawEyes(canvas, o, r, eyeColor: const Color(0xFFB71C1C));

    // Stage Accessories
    _drawStageAccessories(canvas, o, r);
  }

  // ===========================================================================
  // SHARED ANATOMY HELPERS
  // ===========================================================================

  void _drawTriangleEar(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Offset p3,
    Color baseColor,
    Color innerColor, {
    Color? tipColor,
  }) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = baseColor);

    if (tipColor != null) {
      final tipPath = Path()
        ..moveTo(p1.dx + (p2.dx - p1.dx) * 0.7, p1.dy + (p2.dy - p1.dy) * 0.7)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx + (p2.dx - p3.dx) * 0.7, p3.dy + (p2.dy - p3.dy) * 0.7)
        ..close();
      canvas.drawPath(tipPath, Paint()..color = tipColor);
    }

    final innerPath = Path()
      ..moveTo(p1.dx + (p2.dx - p1.dx) * 0.25, p1.dy + (p2.dy - p1.dy) * 0.25)
      ..lineTo(p2.dx, p2.dy + (p1.dy - p2.dy) * 0.2)
      ..lineTo(p3.dx + (p2.dx - p3.dx) * 0.25, p3.dy + (p2.dy - p3.dy) * 0.25)
      ..close();
    canvas.drawPath(innerPath, Paint()..color = innerColor);
  }

  void _drawFloppyEar(Canvas canvas, Offset pos, double r, bool isLeft, Color color) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(isLeft ? -0.3 : 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: r * 0.45, height: r * 0.85), Radius.circular(r * 0.25)),
      Paint()..color = color,
    );
    canvas.restore();
  }

  void _drawBunnyEar(Canvas canvas, Offset pos, double r, double angle, Color outer, Color inner) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    final earRect = Rect.fromCenter(center: Offset(0, -r * 0.6), width: r * 0.38, height: r * 1.25);
    canvas.drawRRect(RRect.fromRectAndRadius(earRect, Radius.circular(r * 0.2)), Paint()..color = outer);

    final innerRect = Rect.fromCenter(center: Offset(0, -r * 0.6), width: r * 0.20, height: r * 0.95);
    canvas.drawRRect(RRect.fromRectAndRadius(innerRect, Radius.circular(r * 0.1)), Paint()..color = inner);

    canvas.restore();
  }

  void _drawDragonWing(Canvas canvas, Offset pos, double r, bool isLeft, double flap) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(isLeft ? -1.0 : 1.0, 1.0);
    canvas.rotate(flap);

    final wingPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(r * 0.6, -r * 0.5, r * 0.9, -r * 0.3)
      ..quadraticBezierTo(r * 0.65, 0, r * 0.8, r * 0.3)
      ..quadraticBezierTo(r * 0.4, r * 0.15, 0, 0)
      ..close();
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFF1B5E20));

    canvas.restore();
  }

  void _drawHorn(Canvas canvas, Offset pos, double r, bool isLeft, Paint paint) {
    final hornPath = Path()
      ..moveTo(pos.dx - (isLeft ? 8 : -8), pos.dy)
      ..quadraticBezierTo(
        pos.dx + (isLeft ? -r * 0.25 : r * 0.25),
        pos.dy - r * 0.45,
        pos.dx + (isLeft ? -r * 0.15 : r * 0.15),
        pos.dy - r * 0.55,
      )
      ..lineTo(pos.dx + (isLeft ? 8 : -8), pos.dy)
      ..close();
    canvas.drawPath(hornPath, paint);
  }

  void _drawNoseAndMouth(Canvas canvas, Offset pos, double r, {bool showTongue = false}) {
    // Nose
    final nosePaint = Paint()..color = const Color(0xFF333333);
    canvas.drawCircle(pos, r * 0.08, nosePaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final mouthPath = Path();
    mouthPath.moveTo(pos.dx - r * 0.14, pos.dy + r * 0.08);
    mouthPath.quadraticBezierTo(pos.dx - r * 0.07, pos.dy + r * 0.15, pos.dx, pos.dy + r * 0.06);
    mouthPath.quadraticBezierTo(pos.dx + r * 0.07, pos.dy + r * 0.15, pos.dx + r * 0.14, pos.dy + r * 0.08);
    canvas.drawPath(mouthPath, mouthPaint);

    // Happy Blep Tongue
    if (showTongue || mood == PetMoodState.happy) {
      final tonguePaint = Paint()..color = const Color(0xFFFF8A9E);
      final tongueRect = Rect.fromCenter(
        center: Offset(pos.dx, pos.dy + r * 0.14),
        width: r * 0.16,
        height: r * 0.18,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(tongueRect, Radius.circular(r * 0.08)), tonguePaint);
    }
  }

  void _drawBunnyNose(Canvas canvas, Offset pos, double r) {
    final nosePaint = Paint()..color = const Color(0xFFFF8FA3);
    canvas.drawCircle(pos, r * 0.07, nosePaint);

    final mouthPaint = Paint()
      ..color = const Color(0xFF5A4A42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy + r * 0.08), mouthPaint);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(pos.dx - r * 0.08, pos.dy + r * 0.10), width: r * 0.16, height: r * 0.12),
      0,
      math.pi,
      false,
      mouthPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(pos.dx + r * 0.08, pos.dy + r * 0.10), width: r * 0.16, height: r * 0.12),
      0,
      math.pi,
      false,
      mouthPaint,
    );
  }

  void _drawWhiskers(Canvas canvas, Offset o, double r) {
    final whiskerPaint = Paint()
      ..color = const Color(0xFF4A4A4A).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    // Left Whiskers
    canvas.drawLine(Offset(o.dx - r * 0.45, o.dy + r * 0.16), Offset(o.dx - r * 0.90, o.dy + r * 0.10), whiskerPaint);
    canvas.drawLine(Offset(o.dx - r * 0.45, o.dy + r * 0.24), Offset(o.dx - r * 0.90, o.dy + r * 0.28), whiskerPaint);

    // Right Whiskers
    canvas.drawLine(Offset(o.dx + r * 0.45, o.dy + r * 0.16), Offset(o.dx + r * 0.90, o.dy + r * 0.10), whiskerPaint);
    canvas.drawLine(Offset(o.dx + r * 0.45, o.dy + r * 0.24), Offset(o.dx + r * 0.90, o.dy + r * 0.28), whiskerPaint);
  }

  void _drawBlush(Canvas canvas, Offset o, double r) {
    final blushPaint = Paint()
      ..color = const Color(0xFFFF85A1).withValues(alpha: 0.40)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx - r * 0.55, o.dy + r * 0.18), width: r * 0.35, height: r * 0.20),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(o.dx + r * 0.55, o.dy + r * 0.18), width: r * 0.35, height: r * 0.20),
      blushPaint,
    );
  }

  void _drawEyes(Canvas canvas, Offset o, double r, {required Color eyeColor}) {
    // If Happy or Eating: Draw joyful squinting arcs `^ - ^`
    if (mood == PetMoodState.happy || mood == PetMoodState.eating) {
      final happyEyePaint = Paint()
        ..color = eyeColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.5;

      final leftArc = Path();
      leftArc.moveTo(o.dx - r * 0.48, o.dy - r * 0.05);
      leftArc.quadraticBezierTo(o.dx - r * 0.32, o.dy - r * 0.25, o.dx - r * 0.16, o.dy - r * 0.05);
      canvas.drawPath(leftArc, happyEyePaint);

      final rightArc = Path();
      rightArc.moveTo(o.dx + r * 0.16, o.dy - r * 0.05);
      rightArc.quadraticBezierTo(o.dx + r * 0.32, o.dy - r * 0.25, o.dx + r * 0.48, o.dy - r * 0.05);
      canvas.drawPath(rightArc, happyEyePaint);
      return;
    }

    // Normal Eyes with Blinking Interpolation
    final eyeHeight = (r * 0.38) * (1.0 - blinkValue).clamp(0.08, 1.0);
    final eyeWidth = r * 0.30;

    // Left Eye
    final leftCenter = Offset(o.dx - r * 0.32, o.dy - r * 0.08);
    canvas.drawOval(
      Rect.fromCenter(center: leftCenter, width: eyeWidth, height: eyeHeight),
      Paint()..color = eyeColor,
    );

    // Right Eye
    final rightCenter = Offset(o.dx + r * 0.32, o.dy - r * 0.08);
    canvas.drawOval(
      Rect.fromCenter(center: rightCenter, width: eyeWidth, height: eyeHeight),
      Paint()..color = eyeColor,
    );

    // Catchlights (Sparkles) if open
    if (blinkValue < 0.3) {
      final sparkPaint = Paint()..color = Colors.white;
      // Main highlight
      canvas.drawCircle(Offset(leftCenter.dx - eyeWidth * 0.22, leftCenter.dy - eyeHeight * 0.25), eyeWidth * 0.22, sparkPaint);
      canvas.drawCircle(Offset(rightCenter.dx - eyeWidth * 0.22, rightCenter.dy - eyeHeight * 0.25), eyeWidth * 0.22, sparkPaint);
      // Secondary mini highlight
      canvas.drawCircle(Offset(leftCenter.dx + eyeWidth * 0.20, leftCenter.dy + eyeHeight * 0.18), eyeWidth * 0.10, sparkPaint);
      canvas.drawCircle(Offset(rightCenter.dx + eyeWidth * 0.20, rightCenter.dy + eyeHeight * 0.18), eyeWidth * 0.10, sparkPaint);
    }
  }

  void _drawOwlEyes(Canvas canvas, Offset o, double r) {
    final eyeRadius = r * 0.30;
    final leftCenter = Offset(o.dx - r * 0.34, o.dy - r * 0.10);
    final rightCenter = Offset(o.dx + r * 0.34, o.dy - r * 0.10);

    // White orbital rings
    final orbitPaint = Paint()..color = Colors.white;
    canvas.drawCircle(leftCenter, eyeRadius, orbitPaint);
    canvas.drawCircle(rightCenter, eyeRadius, orbitPaint);

    // Gold Iris with Pupil
    final irisRadius = eyeRadius * (1.0 - blinkValue).clamp(0.1, 0.85);
    final irisPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(leftCenter, irisRadius, irisPaint);
    canvas.drawCircle(rightCenter, irisRadius, irisPaint);

    if (blinkValue < 0.3) {
      final pupilPaint = Paint()..color = const Color(0xFF212121);
      canvas.drawCircle(leftCenter, irisRadius * 0.55, pupilPaint);
      canvas.drawCircle(rightCenter, irisRadius * 0.55, pupilPaint);

      // Catchlight
      canvas.drawCircle(Offset(leftCenter.dx - 4, leftCenter.dy - 4), 3, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(rightCenter.dx - 4, rightCenter.dy - 4), 3, Paint()..color = Colors.white);
    }
  }

  // ===========================================================================
  // STAGE-SPECIFIC ACCESSORIES & EVOLUTIONS
  // ===========================================================================
  void _drawStageAccessories(Canvas canvas, Offset o, double r) {
    switch (stage) {
      case PetGrowthStage.baby:
        _drawBabyDetails(canvas, o, r);
        break;
      case PetGrowthStage.junior:
        _drawJuniorCollar(canvas, o, r);
        break;
      case PetGrowthStage.teen:
        _drawTeenBandana(canvas, o, r);
        break;
      case PetGrowthStage.adult:
        _drawAdultCrownAndRunes(canvas, o, r);
        break;
    }
  }

  void _drawBabyDetails(Canvas canvas, Offset o, double r) {
    // Baby blush & cute tiny bell / bib
    _drawBlush(canvas, o, r);

    // Tiny gold star bib button
    final bibPaint = Paint()..color = const Color(0xFFFFD166);
    canvas.drawCircle(Offset(o.dx, o.dy + r * 0.62), r * 0.08, bibPaint);
  }

  void _drawJuniorCollar(Canvas canvas, Offset o, double r) {
    // Stylish Junior Collar with Medal
    final collarPaint = Paint()
      ..color = const Color(0xFF00A896)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.14;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(o.dx, o.dy + r * 0.40), width: r * 1.35, height: r * 0.60),
      math.pi * 0.15,
      math.pi * 0.70,
      false,
      collarPaint,
    );

    // Gold Star Bell Pendant
    final medalCenter = Offset(o.dx, o.dy + r * 0.68);
    canvas.drawCircle(medalCenter, r * 0.11, Paint()..color = const Color(0xFFFFD166));
    canvas.drawCircle(medalCenter, r * 0.06, Paint()..color = const Color(0xFFEAA02D));
  }

  void _drawTeenBandana(Canvas canvas, Offset o, double r) {
    // Adventurer Crimson Bandana
    final bandanaPaint = Paint()..color = const Color(0xFFE63946);
    final bandanaPath = Path()
      ..moveTo(o.dx - r * 0.65, o.dy + r * 0.48)
      ..quadraticBezierTo(o.dx, o.dy + r * 0.75, o.dx + r * 0.65, o.dy + r * 0.48)
      ..lineTo(o.dx, o.dy + r * 0.95)
      ..close();
    canvas.drawPath(bandanaPath, bandanaPaint);

    // Bandana knot & emblem
    canvas.drawCircle(Offset(o.dx, o.dy + r * 0.62), r * 0.08, Paint()..color = Colors.white);
  }

  void _drawAdultCrownAndRunes(Canvas canvas, Offset o, double r) {
    // Floating Golden Celestial Crown
    final crownFloat = math.sin(breathValue * math.pi * 2) * 5.0;
    final crownCenter = Offset(o.dx, o.dy - r * 0.95 + crownFloat);

    final crownPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFE066), Color(0xFFF4A261)],
      ).createShader(Rect.fromCenter(center: crownCenter, width: r * 0.8, height: r * 0.4));

    final crownPath = Path()
      ..moveTo(crownCenter.dx - r * 0.35, crownCenter.dy + r * 0.10)
      ..lineTo(crownCenter.dx - r * 0.42, crownCenter.dy - r * 0.20)
      ..lineTo(crownCenter.dx - r * 0.18, crownCenter.dy - r * 0.05)
      ..lineTo(crownCenter.dx, crownCenter.dy - r * 0.28)
      ..lineTo(crownCenter.dx + r * 0.18, crownCenter.dy - r * 0.05)
      ..lineTo(crownCenter.dx + r * 0.42, crownCenter.dy - r * 0.20)
      ..lineTo(crownCenter.dx + r * 0.35, crownCenter.dy + r * 0.10)
      ..close();
    canvas.drawPath(crownPath, crownPaint);

    // Crown Center Ruby Gem
    canvas.drawCircle(Offset(crownCenter.dx, crownCenter.dy - r * 0.05), r * 0.06, Paint()..color = const Color(0xFFE63946));

    // Astral Star Rune Sparkles around adult
    _drawStarRune(canvas, Offset(o.dx - r * 0.95, o.dy - r * 0.4 + crownFloat * 0.5), r * 0.12);
    _drawStarRune(canvas, Offset(o.dx + r * 0.95, o.dy - r * 0.4 + crownFloat * 0.5), r * 0.12);
  }

  void _drawStarRune(Canvas canvas, Offset p, double size) {
    final runePaint = Paint()..color = const Color(0xFFFFD166).withValues(alpha: 0.85);
    final path = Path()
      ..moveTo(p.dx, p.dy - size)
      ..lineTo(p.dx + size * 0.3, p.dy - size * 0.3)
      ..lineTo(p.dx + size, p.dy)
      ..lineTo(p.dx + size * 0.3, p.dy + size * 0.3)
      ..lineTo(p.dx, p.dy + size)
      ..lineTo(p.dx - size * 0.3, p.dy + size * 0.3)
      ..lineTo(p.dx - size, p.dy)
      ..lineTo(p.dx - size * 0.3, p.dy - size * 0.3)
      ..close();
    canvas.drawPath(path, runePaint);
  }

  void _drawEvolveRays(Canvas canvas, Offset center, double radius) {
    final rayPaint = Paint()
      ..color = const Color(0xFFFFE066).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) + (breathValue * math.pi);
      final p1 = Offset(center.dx + math.cos(angle) * radius * 1.1, center.dy + math.sin(angle) * radius * 1.1);
      final p2 = Offset(center.dx + math.cos(angle) * radius * 1.6, center.dy + math.sin(angle) * radius * 1.6);
      canvas.drawLine(p1, p2, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LivingPetPainter oldDelegate) {
    return oldDelegate.breathValue != breathValue ||
        oldDelegate.bounceValue != bounceValue ||
        oldDelegate.blinkValue != blinkValue ||
        oldDelegate.reactionValue != reactionValue ||
        oldDelegate.stage != stage ||
        oldDelegate.mood != mood ||
        oldDelegate.petType != petType;
  }
}
