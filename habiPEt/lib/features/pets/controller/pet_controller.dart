import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/pet_growth_stage.dart';
import '../repository/pet_repository.dart';

class PetLevelUpResult {
  final bool leveledUp;
  final bool stageEvolved;
  final PetGrowthStage newStage;
  final int newLevel;

  const PetLevelUpResult({
    required this.leveledUp,
    required this.stageEvolved,
    required this.newStage,
    required this.newLevel,
  });
}

class PetController extends ChangeNotifier {
  final PetRepository _repository;
  late PetModel _pet;

  PetController({PetRepository? repository})
      : _repository = repository ?? PetRepository() {
    _pet = _repository.getInitialPet();
  }

  PetModel get pet => _pet;
  List<PetType> get availableTypes => _repository.getAvailablePetTypes();

  void renamePet(String newName) {
    if (newName.trim().isEmpty) return;
    _pet = _pet.copyWith(name: newName.trim());
    notifyListeners();
  }

  /// Change pet type while transferring all progress (level, exp, satiety, age)
  void changePetType(PetType newType) {
    if (_pet.type == newType) return;
    _pet = _pet.copyWith(
      type: newType,
    );
    notifyListeners();
  }

  /// Feed pet with satiety and exp boost; handles level up and stage evolution
  PetLevelUpResult feedPet({required int satietyBoost, required int expBoost}) {
    final oldStage = _pet.growthStage;
    int newSatiety = (_pet.satiety + satietyBoost).clamp(0, 100);
    int newExp = _pet.currentExp + expBoost;
    int newLevel = _pet.level;
    int newMaxExp = _pet.maxExp;
    bool leveledUp = false;

    while (newExp >= newMaxExp) {
      newExp -= newMaxExp;
      newLevel += 1;
      newMaxExp = (newMaxExp * 1.25).round();
      leveledUp = true;
    }

    _pet = _pet.copyWith(
      satiety: newSatiety,
      currentExp: newExp,
      level: newLevel,
      maxExp: newMaxExp,
    );

    final stageEvolved = leveledUp && (_pet.growthStage != oldStage);

    notifyListeners();
    return PetLevelUpResult(
      leveledUp: leveledUp,
      stageEvolved: stageEvolved,
      newStage: _pet.growthStage,
      newLevel: newLevel,
    );
  }

  /// Add experience directly (e.g., when completing a habit)
  PetLevelUpResult addExp(int expBoost) {
    return feedPet(satietyBoost: 2, expBoost: expBoost);
  }

  /// Triggered when the user taps or pets the animal
  void petTapped() {
    int newSatiety = (_pet.satiety + 1).clamp(0, 100);
    _pet = _pet.copyWith(satiety: newSatiety);
    notifyListeners();
  }
}

