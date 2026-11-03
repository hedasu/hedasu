// -bu dosya .agents/skills/examples altında yer alan örnek ekran şablonu yer tutucusudur.-
// ÖNEMLİ: Bu şablonun tam kapsamlı, 4 katmanlı (Immutable Model, ValueNotifier Controller, StatelessWidget View ve Modüler Alt Widget'lar) çalışan örneği `lib/sample_test.dart` dosyasında detaylı açıklamalarıyla birlikte yer almaktadır.
//
// MİMARİ ÖZET:
// 1. Model Katmanı -> const kurucu, final alanlar (immutable), copyWith(), fromJson(), toJson()
// 2. Controller Katmanı -> ValueNotifier<T> ile reaktif durum yönetimi, Undo (Geri Alma) desteği ve dispose() ile bellek temizliği
// 3. View Katmanı -> StatelessWidget + ValueListenableBuilder (40 satırı aşmayan temiz build metodu)
// 4. Modüler Widget Katmanı -> const kuruculu, temaya duyarlı küçük özel alt widget'lar
