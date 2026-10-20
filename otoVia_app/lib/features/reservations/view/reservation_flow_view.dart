import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../widgets/reservation_step_indicator.dart';
import '../controller/reservation_controller.dart';
import '../../coupons/controller/coupon_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../core/extensions/context_extensions.dart';

class ReservationFlowView extends StatefulWidget {
  const ReservationFlowView({super.key, required this.vehicle});

  final VehicleModel vehicle;

  @override
  State<ReservationFlowView> createState() => _ReservationFlowViewState();
}

class _ReservationFlowViewState extends State<ReservationFlowView> {
  int _currentStep = 0;
  static const List<String> _stepTitles = [
    'Kiralama Türü',
    'Tarih ve Konum',
    'Ehliyet Uygunluğu',
    'Sözleşme & Onay',
    'Fiyat ve Kupon',
    'Ödeme ve Onay',
  ];

  late String _rentalType;
  int _durationUnits = 1; // Gün ya da saat
  String _pickupLocation = 'İstanbul Havalimanı (IST) VIP Lounge';
  String _dropoffLocation = 'İstanbul Havalimanı (IST) VIP Lounge';
  bool _contractAccepted = false;
  final TextEditingController _couponController = TextEditingController();
  double _discountAmount = 0;
  String? _appliedCouponCode;

  @override
  void initState() {
    super.initState();
    _rentalType = widget.vehicle.supportsDaily ? 'daily' : 'hourly';
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  double get _unitPrice => _rentalType == 'hourly' ? widget.vehicle.hourlyPrice : widget.vehicle.dailyPrice;
  double get _basePrice => _unitPrice * _durationUnits;
  double get _extraInsurance => _rentalType == 'hourly' ? 120 : 500;
  double get _deposit => 2000;
  double get _finalPrice => (_basePrice + _extraInsurance - _discountAmount).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.vehicle.fullName)),
      body: Column(
        children: [
          ReservationStepIndicator(
            currentStep: _currentStep,
            totalSteps: _stepTitles.length,
            stepTitles: _stepTitles,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStepContent(context),
            ),
          ),
          _buildNavigationFooter(context),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildStepRentalType(context);
      case 1:
        return _buildStepDateAndLocation(context);
      case 2:
        return _buildStepLicenseCheck(context);
      case 3:
        return _buildStepContract(context);
      case 4:
        return _buildStepPriceAndCoupon(context);
      case 5:
        return _buildStepPayment(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepRentalType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kiralama Süresi ve Türü', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'daily',
              label: Text('Günlük (₺${widget.vehicle.dailyPrice.toStringAsFixed(0)})'),
              enabled: widget.vehicle.supportsDaily,
            ),
            ButtonSegment(
              value: 'hourly',
              label: Text('Saatlik (₺${widget.vehicle.hourlyPrice.toStringAsFixed(0)})'),
              enabled: widget.vehicle.supportsHourly,
            ),
          ],
          selected: {_rentalType},
          onSelectionChanged: (set) => setState(() => _rentalType = set.first),
        ),
        const SizedBox(height: 24),
        Text('Süre: $_durationUnits ${_rentalType == 'hourly' ? 'Saat' : 'Gün'}', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.remove),
              onPressed: _durationUnits > 1 ? () => setState(() => _durationUnits--) : null,
            ),
            const SizedBox(width: 16),
            Text('$_durationUnits', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _durationUnits++),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepDateAndLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Teslim Alma & Bırakma Noktaları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _pickupLocation,
          decoration: const InputDecoration(labelText: 'Teslim Alma Noktası', prefixIcon: Icon(Icons.location_on_outlined)),
          items: const [
            DropdownMenuItem(value: 'İstanbul Havalimanı (IST) VIP Lounge', child: Text('İstanbul Havalimanı (IST) VIP Lounge')),
            DropdownMenuItem(value: 'Sabiha Gökçen Havalimanı (SAW)', child: Text('Sabiha Gökçen Havalimanı (SAW)')),
            DropdownMenuItem(value: 'Zorlu Center VIP Vale', child: Text('Zorlu Center VIP Vale')),
            DropdownMenuItem(value: 'Bodrum Milas Havalimanı (BJV)', child: Text('Bodrum Milas Havalimanı (BJV)')),
          ],
          onChanged: (val) => setState(() => _pickupLocation = val!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _dropoffLocation,
          decoration: const InputDecoration(labelText: 'Teslim Bırakma Noktası', prefixIcon: Icon(Icons.flag_outlined)),
          items: const [
            DropdownMenuItem(value: 'İstanbul Havalimanı (IST) VIP Lounge', child: Text('İstanbul Havalimanı (IST) VIP Lounge')),
            DropdownMenuItem(value: 'Sabiha Gökçen Havalimanı (SAW)', child: Text('Sabiha Gökçen Havalimanı (SAW)')),
            DropdownMenuItem(value: 'Zorlu Center VIP Vale', child: Text('Zorlu Center VIP Vale')),
            DropdownMenuItem(value: 'Bodrum Milas Havalimanı (BJV)', child: Text('Bodrum Milas Havalimanı (BJV)')),
          ],
          onChanged: (val) => setState(() => _dropoffLocation = val!),
        ),
      ],
    );
  }

  Widget _buildStepLicenseCheck(BuildContext context) {
    final userLicense = authController.currentUser?.driverLicenseClass ?? 'B';
    final isEligible = widget.vehicle.isEligibleForLicense(userLicense);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ehliyet ve Uygunluk Kontrolü', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.outline)),
          leading: Icon(isEligible ? Icons.check_circle : Icons.error, color: isEligible ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F)),
          title: Text(isEligible ? 'Ehliyetiniz Onaylandı' : 'Ehliyet Yetersiz'),
          subtitle: Text('Gereken: ${widget.vehicle.requiredLicenseClass} Sınıfı | Sizdeki: $userLicense Sınıfı'),
        ),
      ],
    );
  }

  Widget _buildStepContract(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kiralama Sözleşmesi ve Taahhütler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const SingleChildScrollView(
            child: Text(
              'otoVia Araç Kiralama Genel Koşulları:\n\n'
              '1. Araç yalnızca sözleşmede adı geçen sürücü tarafından kullanılabilir.\n'
              '2. Teslim alma sırasında araç üzerindeki mevcut çizik veya hasarlar fotoğraflanarak sisteme kaydedilir.\n'
              '3. İade sürecinde aracın temizliği ve yakıt/şarj durumu kontrol edilir.\n'
              '4. Hız limitlerine ve trafik kurallarına uyulması kiracının yasal sorumluluğundadır.\n'
              '5. Kiralama bedeli ve provizyon depozitosu peşin tahsil edilir.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Kiralama sözleşmesini okudum, onaylıyorum.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _contractAccepted,
          onChanged: (val) => setState(() => _contractAccepted = val ?? false),
        ),
      ],
    );
  }

  Widget _buildStepPriceAndCoupon(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Şeffaf Fiyatlandırma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        _buildPriceRow('Birim Fiyat', '₺${_unitPrice.toStringAsFixed(0)} / ${_rentalType == 'hourly' ? 'saat' : 'gün'}'),
        _buildPriceRow('Süre', '$_durationUnits ${_rentalType == 'hourly' ? 'Saat' : 'Gün'}'),
        _buildPriceRow('Ara Toplam', '₺${_basePrice.toStringAsFixed(0)}'),
        _buildPriceRow('VIP Kasko & Güvence', '₺${_extraInsurance.toStringAsFixed(0)}'),
        _buildPriceRow('İade Edilebilir Depozito', '₺${_deposit.toStringAsFixed(0)}'),
        if (_discountAmount > 0)
          _buildPriceRow('Kupon İndirimi ($_appliedCouponCode)', '-₺${_discountAmount.toStringAsFixed(0)}', isDiscount: true),
        const Divider(height: 24),
        _buildPriceRow('Nihai Ödeme Tutarı', '₺${_finalPrice.toStringAsFixed(0)}', isBold: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(hintText: 'Kupon Kodu (Örn: OTOVIA20)'),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(onPressed: _applyCoupon, child: const Text('Uygula')),
          ],
        ),
      ],
    );
  }

  Widget _buildStepPayment(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ödeme Onayı (Simülasyon)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card, color: Color(0xFFC0B09A)),
                  SizedBox(width: 8),
                  Text('Kayıtlı Kart: •••• 4092 (World VIP)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Tahsil Edilecek Tutar: ₺${_finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text('Bloke Edilecek Depozito: ₺${_deposit.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDiscount ? const Color(0xFF2E7D32) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                child: const Text('Geri'),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _canProceed() ? _onNextStep : null,
                child: Text(_currentStep == _stepTitles.length - 1 ? 'Ödemeyi Tamamla' : 'Devam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_currentStep == 2) {
      final userLicense = authController.currentUser?.driverLicenseClass ?? 'B';
      return widget.vehicle.isEligibleForLicense(userLicense);
    }
    if (_currentStep == 3) {
      return _contractAccepted;
    }
    return true;
  }

  void _onNextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
    } else {
      _finishReservation();
    }
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    final coupon = couponController.getCouponByCode(code);
    if (coupon != null) {
      setState(() {
        _discountAmount = (_basePrice * coupon.discountPercent) / 100;
        _appliedCouponCode = coupon.code;
      });
      context.showAppSnackBar('%${coupon.discountPercent} indirim uygulandı!');
    } else {
      context.showAppSnackBar('Geçersiz veya süresi dolmuş kupon kodu.', isError: true);
    }
  }

  Future<void> _finishReservation() async {
    final now = DateTime.now();
    final endDate = _rentalType == 'hourly'
        ? now.add(Duration(hours: _durationUnits))
        : now.add(Duration(days: _durationUnits));

    await reservationController.createReservation(
      vehicle: widget.vehicle,
      rentalType: _rentalType,
      startDate: now.add(const Duration(hours: 2)),
      endDate: endDate,
      totalUnits: _durationUnits,
      basePrice: _basePrice,
      extraInsurance: _extraInsurance,
      deposit: _deposit,
      discountAmount: _discountAmount,
      finalPrice: _finalPrice,
      pickupLocation: _pickupLocation,
      dropoffLocation: _dropoffLocation,
      appliedCouponCode: _appliedCouponCode,
    );

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 48),
        title: const Text('Rezervasyon Kesinleşti!'),
        content: Text(
          'Tebrikler! ${widget.vehicle.fullName} rezervasyonunuz oluşturuldu. Araç bilgilerinizi Rezervasyonlarım sayfasından takip edebilirsiniz.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
