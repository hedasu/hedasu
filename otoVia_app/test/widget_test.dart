import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otovia/app/app.dart';

/// Test ortamında ağ isteklerinin (Image.network) hata vermemesi için kullanılan
/// 1x1 piksel şeffaf PNG görsel bayt dizisi.
final List<int> _kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

/// Testlerde sahte HTTP istemcisi (Mock HttpClient)
class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

/// Sahte HTTP isteği nesnesi
class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

/// Sahte HTTP başlıkları
class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

/// Sahte HTTP yanıt nesnesi (200 OK ve şeffaf görsel döner)
class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

/// Test ortamında tüm HTTP isteklerini sahte istemciye yönlendiren geçersiz kılma sınıfı
class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // SharedPreferences mock verilerini hazırla
    SharedPreferences.setMockInitialValues({});
    // Görsel ağ isteklerini yerel mock istemciye bağla
    HttpOverrides.global = _MockHttpOverrides();
  });

  /// Uygulama ayağa kalkma (smoke test) ve ana kabuk widget testi
  testWidgets('otoVia app smoke test and main shell rendering', (WidgetTester tester) async {
    // Uygulama widget'ını çizdir
    await tester.pumpWidget(const OtoViaApp());
    await tester.pumpAndSettle();

    // Ana sayfa karşılama sloganının varlığını doğrula
    expect(find.text('Aracını keşfet.'), findsOneWidget);

    // Alt navigasyon çubuğu sekmelerinin doğru etiketlerle yüklendiğini doğrula
    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Favoriler'), findsOneWidget);
    expect(find.text('Kiralamalar'), findsOneWidget);
    expect(find.text('Bildirimler'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
