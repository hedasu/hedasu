import 'package:flutter/material.dart';
import 'core/services/storage_service.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const OtoViaApp());
}
