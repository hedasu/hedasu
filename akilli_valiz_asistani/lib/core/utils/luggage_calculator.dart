import '../constants/app_constants.dart';

class LuggageCalculator {
  LuggageCalculator._();

  // Known item weights (kg) and volumes (liters) references
  static const Map<String, ({double weight, double volume})> itemReferenceDatabase = {
    // Giyim
    'tişört': (weight: 0.2, volume: 0.8),
    't-shirt': (weight: 0.2, volume: 0.8),
    'pantolon': (weight: 0.5, volume: 1.8),
    'kot pantolon': (weight: 0.65, volume: 2.2),
    'gömlek': (weight: 0.25, volume: 0.9),
    'elbise': (weight: 0.4, volume: 1.5),
    'ceket': (weight: 0.8, volume: 3.5),
    'mont': (weight: 1.2, volume: 6.0),
    'kazak': (weight: 0.5, volume: 2.5),
    'hırka': (weight: 0.4, volume: 2.0),
    'şort': (weight: 0.2, volume: 0.8),
    'pijama': (weight: 0.35, volume: 1.2),
    'iç çamaşırı': (weight: 0.08, volume: 0.3),
    'çorap': (weight: 0.06, volume: 0.2),
    'ayakkabı': (weight: 0.9, volume: 3.2),
    'spor ayakkabı': (weight: 0.85, volume: 3.0),
    'terlik': (weight: 0.25, volume: 1.2),

    // Teknolojik
    'laptop': (weight: 1.5, volume: 2.5),
    'dizüstü bilgisayar': (weight: 1.5, volume: 2.5),
    'şarj aleti': (weight: 0.15, volume: 0.3),
    'powerbank': (weight: 0.3, volume: 0.4),
    'kulaklık': (weight: 0.2, volume: 0.6),
    'fotoğraf makinesi': (weight: 0.8, volume: 1.8),
    'tablet': (weight: 0.5, volume: 0.8),
    'priz dönüştürücü': (weight: 0.1, volume: 0.2),

    // Sağlık & Bakım
    'diş fırçası ve macun': (weight: 0.12, volume: 0.3),
    'şampuan / duş jeli': (weight: 0.25, volume: 0.35),
    'parfüm': (weight: 0.2, volume: 0.25),
    'güneş kremi': (weight: 0.2, volume: 0.3),
    'ilaç çantası / ilk yardım': (weight: 0.35, volume: 0.8),
    'ağrı kesici': (weight: 0.05, volume: 0.1),
    'nemlendirici krem': (weight: 0.15, volume: 0.2),
    'tıraş takımı': (weight: 0.25, volume: 0.5),

    // Aksesuar
    'güneş gözlüğü': (weight: 0.1, volume: 0.3),
    'şapka': (weight: 0.15, volume: 0.8),
    'kemer': (weight: 0.2, volume: 0.4),
    'şemsiye': (weight: 0.4, volume: 1.2),
    'saat': (weight: 0.1, volume: 0.2),

    // Özel / Kamp
    'çadır': (weight: 3.2, volume: 14.0),
    'uyku tulumu': (weight: 1.4, volume: 7.0),
    'mat': (weight: 0.6, volume: 4.0),
    'kamp feneri': (weight: 0.3, volume: 0.8),
    'termos': (weight: 0.45, volume: 1.5),

    // Yaz / Kış Spor
    'mayo / bikini': (weight: 0.2, volume: 0.6),
    'plaj havlusu': (weight: 0.5, volume: 2.2),
    'deniz gözlüğü': (weight: 0.15, volume: 0.4),
    'kayak eldiveni': (weight: 0.25, volume: 0.8),
    'termal içlik': (weight: 0.35, volume: 1.2),
    'kar gözlüğü': (weight: 0.25, volume: 0.9),
  };

  static ({double weight, double volume}) estimateItemMetrics(String itemName) {
    final lower = itemName.trim().toLowerCase();
    for (final entry in itemReferenceDatabase.entries) {
      if (lower.contains(entry.key) || entry.key.contains(lower)) {
        return entry.value;
      }
    }
    // Default safe baseline fallback
    return (weight: 0.35, volume: 1.0);
  }

  static bool isCabinExceeded({required double totalWeight, required double totalVolume}) {
    return totalWeight > AppConstants.cabinMaxWeightKg ||
        totalVolume > AppConstants.cabinMaxVolumeLiters;
  }
}
