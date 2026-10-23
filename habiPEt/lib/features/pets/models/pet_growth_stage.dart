enum PetGrowthStage {
  baby,
  junior,
  teen,
  adult;

  static PetGrowthStage fromLevel(int level) {
    if (level < 5) return PetGrowthStage.baby;
    if (level < 10) return PetGrowthStage.junior;
    if (level < 20) return PetGrowthStage.teen;
    return PetGrowthStage.adult;
  }

  String get displayName {
    switch (this) {
      case PetGrowthStage.baby:
        return 'Yavru';
      case PetGrowthStage.junior:
        return 'Genç';
      case PetGrowthStage.teen:
        return 'Gelişkin';
      case PetGrowthStage.adult:
        return 'Efsanevi Usta';
    }
  }

  String get badgeEmoji {
    switch (this) {
      case PetGrowthStage.baby:
        return '🐣';
      case PetGrowthStage.junior:
        return '🐾';
      case PetGrowthStage.teen:
        return '⚡';
      case PetGrowthStage.adult:
        return '👑';
    }
  }

  String get titlePrefix {
    switch (this) {
      case PetGrowthStage.baby:
        return 'Minik';
      case PetGrowthStage.junior:
        return 'Neşeli';
      case PetGrowthStage.teen:
        return 'Cesur';
      case PetGrowthStage.adult:
        return 'Kadim';
    }
  }

  String get stageRangeText {
    switch (this) {
      case PetGrowthStage.baby:
        return 'Seviye 1 – 4';
      case PetGrowthStage.junior:
        return 'Seviye 5 – 9';
      case PetGrowthStage.teen:
        return 'Seviye 10 – 19';
      case PetGrowthStage.adult:
        return 'Seviye 20+';
    }
  }

  double get scaleFactor {
    switch (this) {
      case PetGrowthStage.baby:
        return 0.88;
      case PetGrowthStage.junior:
        return 1.0;
      case PetGrowthStage.teen:
        return 1.14;
      case PetGrowthStage.adult:
        return 1.28;
    }
  }

  int get minLevel {
    switch (this) {
      case PetGrowthStage.baby:
        return 1;
      case PetGrowthStage.junior:
        return 5;
      case PetGrowthStage.teen:
        return 10;
      case PetGrowthStage.adult:
        return 20;
    }
  }

  int? get nextStageLevel {
    switch (this) {
      case PetGrowthStage.baby:
        return 5;
      case PetGrowthStage.junior:
        return 10;
      case PetGrowthStage.teen:
        return 20;
      case PetGrowthStage.adult:
        return null;
    }
  }
}
