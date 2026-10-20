/// Ana Sayfa Özet Bilgileri Modeli
class HomeDashboardModel {
  final String activeStartupName;
  final String stage;
  final int matchedMentorsCount;
  final int activeApplicationsCount;
  final int availableOpportunitiesCount;
  final int roadmapProgressPercent;

  const HomeDashboardModel({
    required this.activeStartupName,
    required this.stage,
    required this.matchedMentorsCount,
    required this.activeApplicationsCount,
    required this.availableOpportunitiesCount,
    required this.roadmapProgressPercent,
  });

  factory HomeDashboardModel.sample() {
    return const HomeDashboardModel(
      activeStartupName: 'PayWise Fintek',
      stage: 'Tohum / MVP Aşaması',
      matchedMentorsCount: 14,
      activeApplicationsCount: 3,
      availableOpportunitiesCount: 8,
      roadmapProgressPercent: 65,
    );
  }
}
