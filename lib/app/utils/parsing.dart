class Parsing {
  static DateTime? parseDate(value) {
    return value != null ? (value is DateTime ? value : DateTime.parse(value).toLocal()) : null;
  }

  static double? parseDouble(value) {
    if (value == '') return null;
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();

    return double.tryParse(value.replaceAll(',', '.'));
  }

  static double? parseFormattedDouble(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'\s+'), '').replaceAll(',', '.'));
  }
}
