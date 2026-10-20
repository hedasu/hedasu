import 'package:flutter/foundation.dart';
import '../models/profile_details_model.dart';

/// Profil Ekranı Kontrolcüsü
class ProfileController {
  final ValueNotifier<ProfileDetailsModel> profile =
      ValueNotifier<ProfileDetailsModel>(ProfileDetailsModel.sample());

  void dispose() {
    profile.dispose();
  }
}
