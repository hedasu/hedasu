import 'dart:async';
import 'package:flutter/material.dart';

enum PetMoodState {
  idle,     // Boşta bekleme, doğal nefes alma, periyodik göz kırpma
  happy,    // Dokunulduğunda sevinme, zıplama, neşe
  eating,   // Beslendiğinde çiğneme, mutlu tat alma
  evolve,   // Büyüme / Seviye atlama anında parıldama ve dönüşüm
  sleepy;   // Enerji/Tokluk düşükken uyuklama

  String get label {
    switch (this) {
      case PetMoodState.idle:
        return 'Sakin';
      case PetMoodState.happy:
        return 'Çok Mutlu';
      case PetMoodState.eating:
        return 'Afiyetle Yiyor';
      case PetMoodState.evolve:
        return 'Gelişiyor!';
      case PetMoodState.sleepy:
        return 'Uykulu';
    }
  }
}

class PetAnimationController extends ChangeNotifier {
  PetMoodState _mood = PetMoodState.idle;
  Timer? _resetTimer;
  int _reactionNonce = 0;

  PetMoodState get mood => _mood;
  int get reactionNonce => _reactionNonce;
  bool get isIdle => _mood == PetMoodState.idle;
  bool get isHappy => _mood == PetMoodState.happy;
  bool get isEating => _mood == PetMoodState.eating;
  bool get isEvolving => _mood == PetMoodState.evolve;

  void setMood(PetMoodState newMood, {Duration duration = const Duration(milliseconds: 1800)}) {
    _resetTimer?.cancel();
    _mood = newMood;
    _reactionNonce++;
    notifyListeners();

    if (newMood != PetMoodState.idle) {
      _resetTimer = Timer(duration, () {
        _mood = PetMoodState.idle;
        notifyListeners();
      });
    }
  }

  void triggerHappy() {
    setMood(PetMoodState.happy, duration: const Duration(milliseconds: 1600));
  }

  void triggerEating() {
    setMood(PetMoodState.eating, duration: const Duration(milliseconds: 2200));
  }

  void triggerEvolve() {
    setMood(PetMoodState.evolve, duration: const Duration(milliseconds: 2800));
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
