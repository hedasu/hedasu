import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../repository/pet_repository.dart';

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
      // Retains level, currentExp, maxExp, satiety, and appStartDate
    );
    notifyListeners();
  }

  /// Feed pet with satiety and exp boost; handles level up
  bool feedPet({required int satietyBoost, required int expBoost}) {
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

    notifyListeners();
    return leveledUp;
  }
}
