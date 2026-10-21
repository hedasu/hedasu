class AppDateUtils {
  AppDateUtils._();

  static const List<String> _months = [
    '',
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
  ];

  static const List<String> _fullMonths = [
    '',
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  static const List<String> _weekdays = [
    '',
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
  ];

  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '${start.day} - ${end.day} ${_months[start.month]} ${start.year}';
      }
      return '${start.day} ${_months[start.month]} - ${end.day} ${_months[end.month]} ${start.year}';
    }
    return '${start.day} ${_months[start.month]} ${start.year} - ${end.day} ${_months[end.month]} ${end.year}';
  }

  static String formatSingleDate(DateTime date) {
    return '${date.day} ${_fullMonths[date.month]} ${date.year}, ${_weekdays[date.weekday]}';
  }

  static String formatShortDate(DateTime date) {
    return '${date.day} ${_months[date.month]}';
  }

  static String formatDayName(DateTime date) {
    return _weekdays[date.weekday];
  }

  static int calculateDurationDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return e.difference(s).inDays + 1;
  }
}
