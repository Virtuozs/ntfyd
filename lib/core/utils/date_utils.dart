String relativeTime(DateTime time, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final diff = reference.difference(time);

  if (diff.inSeconds < 60) {
    return 'just now';
  }

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min ago';
  }

  if (diff.inHours < 24) {
    return '${diff.inHours} h ago';
  }

  // Check if `time` falls on the calendar day immediately before `reference`.
  final referenceDate = DateTime(
    reference.year,
    reference.month,
    reference.day,
  );
  final yesterday = referenceDate.subtract(const Duration(days: 1));
  final timeDate = DateTime(time.year, time.month, time.day);

  if (timeDate == yesterday) {
    return 'yesterday';
  }

  // Older — formatted date, e.g. "Jun 10".
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[time.month - 1]} ${time.day}';
}
