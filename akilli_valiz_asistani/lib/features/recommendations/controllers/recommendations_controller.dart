import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/utils/luggage_calculator.dart';
import '../../packing_list/models/packing_item_model.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/recommendation_model.dart';

class RecommendationsController {
  final TripRepository _tripRepository;
  final WeatherService _weatherService;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> trip = ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<RecommendationItem>> recommendations =
      ValueNotifier<List<RecommendationItem>>([]);
  final ValueNotifier<Set<String>> addedItemNames = ValueNotifier<Set<String>>({});

  RecommendationsController({
    required TripRepository tripRepository,
    required WeatherService weatherService,
    required this.tripId,
  })  : _tripRepository = tripRepository,
        _weatherService = weatherService {
    _generateRecommendations();
  }

  Future<void> _generateRecommendations() async {
    isLoading.value = true;
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isEmpty) {
      isLoading.value = false;
      return;
    }

    final curTrip = match.first;
    trip.value = curTrip;
    addedItemNames.value = curTrip.items.map((i) => i.name).toSet();

    // Fetch weather report for intelligent analysis
    WeatherReport? weather;
    try {
      weather = await _weatherService.fetchTripWeather(
        lat: curTrip.latitude,
        lon: curTrip.longitude,
        startDate: curTrip.startDate,
        endDate: curTrip.endDate,
      );
    } catch (_) {}

    final List<RecommendationItem> items = [];
    final days = curTrip.durationDays;

    // 1. Duration-based essentials
    items.add(
      RecommendationItem(
        title: 'Pamuklu Tişört / Üst Giyim ($days adet)',
        reason: '$days günlük seyahat süreniz boyunca her gün için birer temiz üst giyim.',
        category: AppConstants.categoryClothing,
        icon: Icons.checkroom_rounded,
      ),
    );
    items.add(
      RecommendationItem(
        title: 'İç Çamaşırı & Çorap (${days + 1} adet)',
        reason: 'Seyahat sürenize ek 1 adet yedek olacak şekilde hijyen paketi.',
        category: AppConstants.categoryClothing,
        icon: Icons.dry_cleaning_rounded,
      ),
    );

    // 2. Weather-based dynamic suggestions
    final avgMax = weather != null && weather.dailyForecast.isNotEmpty
        ? weather.dailyForecast.fold(0.0, (acc, d) => acc + d.tempMax) / weather.dailyForecast.length
        : 22.0;
    final hasRain = weather?.dailyForecast.any((d) => d.precipitationProbability > 40) ?? false;
    final hasCold = weather?.dailyForecast.any((d) => d.tempMin < 10) ?? false;

    if (hasRain) {
      items.add(
        const RecommendationItem(
          title: 'Kompakt Şemsiye veya Yağmurluk',
          reason: 'Tahminlerde yağış olasılığı yüksek görünüyor.',
          category: AppConstants.categoryClothing,
          icon: Icons.umbrella_rounded,
          isWeatherBased: true,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Su Geçirmez Ayakkabı',
          reason: 'Yağışlı günlerde ayak konforunu korumak için önerilir.',
          category: AppConstants.categoryClothing,
          icon: Icons.hiking_rounded,
          isWeatherBased: true,
        ),
      );
    }

    if (avgMax > 24) {
      items.add(
        const RecommendationItem(
          title: 'Yüksek Korumalı Güneş Kremi & Şapka',
          reason: 'Sıcak ve açık güneşli hava beklendiği için UV koruması şart.',
          category: AppConstants.categoryHealth,
          icon: Icons.wb_sunny_rounded,
          isWeatherBased: true,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Güneş Gözlüğü',
          reason: 'Parlak gün ışığına karşı göz sağlığı için tavsiye edilir.',
          category: AppConstants.categoryAccessories,
          icon: Icons.remove_red_eye_rounded,
          isWeatherBased: true,
        ),
      );
    }

    if (hasCold || avgMax < 14) {
      items.add(
        const RecommendationItem(
          title: 'Kalın Mont / Rüzgarlık & Bere',
          reason: 'Sıcaklık değerleri düşük seyredeceğinden katmanlı giyim tavsiye edilir.',
          category: AppConstants.categoryClothing,
          icon: Icons.ac_unit_rounded,
          isWeatherBased: true,
        ),
      );
    }

    // 3. Trip-Type and Sub-Type based suggestions
    if (curTrip.tripType == AppConstants.tripTypeBusiness) {
      items.add(
        const RecommendationItem(
          title: 'Takım Elbise / Resmi Gömlek & Kravat',
          reason: 'İş toplantıları ve etkinlik standartlarına uygun kıyafet.',
          category: AppConstants.categoryBusiness,
          icon: Icons.business_center_rounded,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Dizüstü Bilgisayar & HDMI Sunum Adaptörü',
          reason: 'Konferans ve sunum hazırlıkları için gerekli donanımlar.',
          category: AppConstants.categoryTech,
          icon: Icons.laptop_mac_rounded,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Yedek Not Defteri & Kartvizitlik',
          reason: 'İş belgeleri ve profesyonel görüşmeler için.',
          category: AppConstants.categoryBusiness,
          icon: Icons.badge_rounded,
        ),
      );
    } else if (curTrip.tripType == AppConstants.tripTypeCamping) {
      items.add(
        const RecommendationItem(
          title: 'Çadır, Mat ve Uyku Tulumu',
          reason: 'Gece açık hava konaklaması için temel kamp barınma kiti.',
          category: AppConstants.categoryCamping,
          icon: Icons.cabin_rounded,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Kafa Feneri & Yedek Pil',
          reason: 'Gece görüşü ve doğa yürüyüşlerinde eller serbest aydınlatma.',
          category: AppConstants.categoryCamping,
          icon: Icons.flashlight_on_rounded,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Termos & Çok Amaçlı Çakı',
          reason: 'Sıcak içecek ve kamp emniyeti için temel araçlar.',
          category: AppConstants.categoryCamping,
          icon: Icons.handyman_rounded,
        ),
      );
    } else if (curTrip.tripType == AppConstants.tripTypeVacation) {
      if (curTrip.tripSubType == 'Kış Tatili') {
        items.add(
          const RecommendationItem(
            title: 'Termal İçlik & Kayak Eldiveni',
            reason: 'Kış sporları ve karlı pistlerde vücut sıcaklığını muhafaza eder.',
            category: AppConstants.categoryWinterSports,
            icon: Icons.downhill_skiing_rounded,
          ),
        );
      } else {
        items.add(
          const RecommendationItem(
            title: 'Mayo / Şort & Plaj Havlusu',
            reason: 'Deniz ve havuz aktiviteleri için plaj çantası gereksinimleri.',
            category: AppConstants.categoryBeach,
            icon: Icons.pool_rounded,
          ),
        );
      }
    } else if (curTrip.tripType == AppConstants.tripTypeCultural) {
      items.add(
        const RecommendationItem(
          title: 'Ergonomik Yürüyüş Ayakkabısı',
          reason: 'Şehir keşfi ve müzelerde uzun süreli yürüyüş konforu sağlar.',
          category: AppConstants.categoryClothing,
          icon: Icons.directions_walk_rounded,
        ),
      );
      items.add(
        const RecommendationItem(
          title: 'Hızlı Şarj Powerbank',
          reason: 'Gün boyu navigasyon, fotoğraf ve müze biletleri için telefon şarjı.',
          category: AppConstants.categoryTech,
          icon: Icons.battery_charging_full_rounded,
        ),
      );
    }

    // 4. Critical Health & Tech Must-Haves
    items.add(
      const RecommendationItem(
        title: 'Seyahat Boy Diş Fırçası & Macun',
        category: AppConstants.categoryPersonalCare,
        reason: 'Günlük kişisel bakım ihtiyaçları.',
        icon: Icons.clean_hands_rounded,
      ),
    );
    items.add(
      const RecommendationItem(
        title: 'Kişisel İlaçlar ve Ağrı Kesici',
        category: AppConstants.categoryHealth,
        reason: 'Yolculuk sırasında olası baş ağrısı veya acil durumlar için.',
        icon: Icons.medication_rounded,
      ),
    );

    recommendations.value = items;
    isLoading.value = false;
  }

  Future<void> addItemToTrip(RecommendationItem rec) async {
    final curTrip = trip.value;
    if (curTrip == null) return;

    final metrics = LuggageCalculator.estimateItemMetrics(rec.title);
    const uuid = Uuid();
    final newItem = PackingItemModel(
      id: uuid.v4(),
      name: rec.title,
      category: rec.category,
      quantity: 1,
      unitWeightKg: metrics.weight,
      unitVolumeLiters: metrics.volume,
      isPacked: false,
      isCustom: false,
    );

    final currentItems = List<PackingItemModel>.from(curTrip.items);
    currentItems.add(newItem);

    final updatedTrip = curTrip.copyWith(items: currentItems);
    await _tripRepository.saveTrip(updatedTrip);
    trip.value = updatedTrip;

    final newSet = Set<String>.from(addedItemNames.value)..add(rec.title);
    addedItemNames.value = newSet;
  }

  void dispose() {
    trip.dispose();
    isLoading.dispose();
    recommendations.dispose();
    addedItemNames.dispose();
  }
}
