import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../controller/review_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../core/extensions/context_extensions.dart';

/// Araç Değerlendirme ve Yorum Ekleme Modal Penceresi (AddReviewDialog)
///
/// Tamamlanan kiralama sonrası 5 yıldızlı puanlama, donanım/amaç/destek memnuniyeti
/// kontrol onay kutuları ve deneyim yorumu giriş alanını barındırır.
class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key, required this.vehicle});

  /// Değerlendirilen araç
  final VehicleModel vehicle;

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  // Seçilen yıldız puanı (varsayılan 5.0)
  double _rating = 5.0;

  // Yorum metni kontrolcüsü
  final TextEditingController _commentController = TextEditingController();

  // Deneyim kriterleri onay durumları
  bool _specsMatched = true;
  bool _purposeMatched = true;
  bool _supportSatisfied = true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.vehicle.fullName} Değerlendir'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 5 Yıldızlı Puanlama Alanı
            _buildRatingStars(),
            const SizedBox(height: 16),
            // Donanım, amaç ve destek memnuniyeti onay kutuları
            _buildCriteriaCheckboxes(),
            const SizedBox(height: 16),
            // Yorum metni giriş alanı
            _buildCommentField(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: _submitReview,
          child: const Text('Gönder'),
        ),
      ],
    );
  }

  /// 5 Yıldızlı dokunmatik puan seçici
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        return IconButton(
          icon: Icon(
            _rating >= starValue ? Icons.star : Icons.star_border,
            color: const Color(0xFFC0B09A),
            size: 32,
          ),
          onPressed: () => setState(() => _rating = starValue),
        );
      }),
    );
  }

  /// Memnuniyet kriterleri onay kutuları listesi
  Widget _buildCriteriaCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Araç belirtilen özelliklerle uyumlu muydu?', style: TextStyle(fontSize: 12)),
          value: _specsMatched,
          onChanged: (val) => setState(() => _specsMatched = val ?? false),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Araç kiralama amacınıza uygun muydu?', style: TextStyle(fontSize: 12)),
          value: _purposeMatched,
          onChanged: (val) => setState(() => _purposeMatched = val ?? false),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Destek hizmeti yeterli miydi?', style: TextStyle(fontSize: 12)),
          value: _supportSatisfied,
          onChanged: (val) => setState(() => _supportSatisfied = val ?? false),
        ),
      ],
    );
  }

  /// Yorum yazma çok satırlı metin kutusu
  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'Deneyiminizi birkaç cümleyle özetleyin...',
      ),
    );
  }

  /// Yorumu doğrulayıp ReviewController'a ekleyen fonksiyon
  void _submitReview() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      context.showAppSnackBar('Lütfen bir değerlendirme yorumu yazınız.', isError: true);
      return;
    }

    final user = authController.currentUser;
    reviewController.addReview(
      vehicleId: widget.vehicle.id,
      userName: user != null ? user.fullName : 'Misafir Kullanıcı',
      rating: _rating,
      comment: comment,
      specsMatched: _specsMatched,
      purposeMatched: _purposeMatched,
      supportSatisfied: _supportSatisfied,
    );
    Navigator.pop(context);
    context.showAppSnackBar('Değerlendirmeniz için teşekkür ederiz!');
  }
}
