class AppConstants {
  AppConstants._();

  // Baggage Limits
  static const double cabinMaxWeightKg = 8.0;
  static const double cabinMaxVolumeLiters = 40.0;
  static const double checkInMaxWeightKg = 23.0;
  static const double checkInMaxVolumeLiters = 85.0;

  // Standard Categories (Always present in any trip)
  static const String categoryHealth = 'Sağlık';
  static const String categoryClothing = 'Giyim';
  static const String categoryAccessories = 'Aksesuarlar';
  static const String categoryTech = 'Teknolojik Ürünler';
  static const String categoryPersonalCare = 'Kişisel Bakım & İhtiyaçlar';

  static const List<String> standardCategories = [
    categoryHealth,
    categoryClothing,
    categoryAccessories,
    categoryTech,
    categoryPersonalCare,
  ];

  // Dynamic Categories (Based on Trip Type)
  static const String categoryBusiness = 'İş Belgeleri ve Ekipmanları';
  static const String categoryCamping = 'Kamp Ekipmanları';
  static const String categoryBeach = 'Yüzme ve Plaj Malzemeleri';
  static const String categoryWinterSports = 'Kayak ve Kış Sporları Malzemeleri';

  // Trip Types & Subtypes
  static const String tripTypeBusiness = 'İş Gezisi';
  static const String tripTypeCamping = 'Kamp';
  static const String tripTypeVacation = 'Tatil';
  static const String tripTypeCultural = 'Kültürel Gezi';

  static const List<String> tripTypes = [
    tripTypeBusiness,
    tripTypeCamping,
    tripTypeVacation,
    tripTypeCultural,
  ];

  static const Map<String, List<String>> tripSubTypes = {
    tripTypeBusiness: ['Konferans', 'Sempozyum', 'Toplantı'],
    tripTypeCamping: ['Kamp Gezisi', 'Dağcılık / Trekking'],
    tripTypeVacation: ['Yaz Tatili', 'Kış Tatili'],
    tripTypeCultural: ['Şehir Keşfi', 'Müze & Tarihi Tur'],
  };

  // Popular Destinations for quick picker
  static const List<Map<String, dynamic>> popularDestinations = [
    {'name': 'İstanbul, Türkiye', 'lat': 41.0082, 'lon': 28.9784, 'country': 'TR'},
    {'name': 'Antalya, Türkiye', 'lat': 36.8969, 'lon': 30.7133, 'country': 'TR'},
    {'name': 'İzmir, Türkiye', 'lat': 38.4237, 'lon': 27.1428, 'country': 'TR'},
    {'name': 'Trabzon, Türkiye', 'lat': 41.0027, 'lon': 39.7168, 'country': 'TR'},
    {'name': 'Kapadokya, Türkiye', 'lat': 38.6431, 'lon': 34.8289, 'country': 'TR'},
    {'name': 'Londra, İngiltere', 'lat': 51.5074, 'lon': -0.1278, 'country': 'GB'},
    {'name': 'Paris, Fransa', 'lat': 48.8566, 'lon': 2.3522, 'country': 'FR'},
    {'name': 'Roma, İtalya', 'lat': 41.9028, 'lon': 12.4964, 'country': 'IT'},
    {'name': 'Tokyo, Japonya', 'lat': 35.6762, 'lon': 139.6503, 'country': 'JP'},
    {'name': 'New York, ABD', 'lat': 40.7128, 'lon': -74.0060, 'country': 'US'},
  ];
}
