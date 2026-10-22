import '../models/pet_model.dart';

class PetRepository {
  List<PetType> getAvailablePetTypes() {
    return PetType.values;
  }

  PetModel getInitialPet() {
    // 16 days ago started to match project.md scenario
    return PetModel(
      id: 'active_pet',
      name: 'Mırnav',
      type: PetType.cat,
      level: 4,
      currentExp: 65,
      maxExp: 100,
      satiety: 80,
      appStartDate: DateTime.now().subtract(const Duration(days: 15)),
    );
  }
}
