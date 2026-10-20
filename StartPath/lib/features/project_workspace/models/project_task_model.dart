/// Proje Görevi ve Kilometre Taşı Modeli
class ProjectTaskModel {
  final String id;
  final String title;
  final String assignee;
  final String dueDate;
  final bool isDone;
  final String priority; // Yüksek, Orta, Normal

  const ProjectTaskModel({
    required this.id,
    required this.title,
    required this.assignee,
    required this.dueDate,
    required this.isDone,
    required this.priority,
  });

  ProjectTaskModel copyWith({bool? isDone}) {
    return ProjectTaskModel(
      id: id,
      title: title,
      assignee: assignee,
      dueDate: dueDate,
      isDone: isDone ?? this.isDone,
      priority: priority,
    );
  }

  static List<ProjectTaskModel> get samples => const [
        ProjectTaskModel(
          id: 'tsk_1',
          title: 'Kullanıcı sözleşmesi ve KVKK metnini mentora incelet',
          assignee: 'Can Demir',
          dueDate: '24 Ekim',
          isDone: true,
          priority: 'Yüksek',
        ),
        ProjectTaskModel(
          id: 'tsk_2',
          title: 'TÜBİTAK BİGG proje iş planı taslağını tamamla',
          assignee: 'Can Demir',
          dueDate: '28 Ekim',
          isDone: false,
          priority: 'Yüksek',
        ),
        ProjectTaskModel(
          id: 'tsk_3',
          title: 'Mobil ödeme API entegrasyonu test senaryolarını yaz',
          assignee: 'Teknik Ekip',
          dueDate: '3 Kasım',
          isDone: false,
          priority: 'Orta',
        ),
      ];
}
