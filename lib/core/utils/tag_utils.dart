/// Parses a comma-separated tag string into a list of trimmed,
/// non-empty tags. Returns an empty list for null/empty input.
List<String> tagsFromCsv(String? csv) {
  if (csv == null || csv.trim().isEmpty) return [];

  return csv
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();
}

/// Joins tags into a comma-separated string. Empty list -> empty string.
String tagsToCsv(List<String> tags) => tags.join(',');
