import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/storage_service.dart';
import '../models/shopping_item_model.dart';

class ShoppingController {
  final StorageService _storageService;

  final ValueNotifier<List<ShoppingItemModel>> items = ValueNotifier<List<ShoppingItemModel>>([]);

  ShoppingController({required StorageService storageService})
      : _storageService = storageService {
    loadItems();
  }

  void loadItems() {
    items.value = _storageService.getShoppingItems();
  }

  Future<void> addItem({
    required String title,
    String category = 'Genel',
    double? price,
  }) async {
    if (title.trim().isEmpty) return;
    const uuid = Uuid();
    final item = ShoppingItemModel(
      id: uuid.v4(),
      title: title.trim(),
      category: category,
      estimatedPrice: price,
      isPurchased: false,
    );
    await _storageService.saveShoppingItem(item);
    loadItems();
  }

  Future<void> togglePurchased(String id) async {
    final list = _storageService.getShoppingItems();
    final idx = list.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      final updated = list[idx].copyWith(isPurchased: !list[idx].isPurchased);
      await _storageService.saveShoppingItem(updated);
      loadItems();
    }
  }

  Future<void> toggleItem(String id) => togglePurchased(id);

  Future<void> deleteItem(String id) async {
    await _storageService.deleteShoppingItem(id);
    loadItems();
  }

  void dispose() {
    items.dispose();
  }
}
