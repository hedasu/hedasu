import '../../packing_list/models/packing_item_model.dart';

class ChecklistSectionModel {
  final String category;
  final List<PackingItemModel> items;

  const ChecklistSectionModel({
    required this.category,
    required this.items,
  });
}
