extension NullableStringCapitalized on String? {
  String toCapitalized() {
    if (this == null || this!.isEmpty) return '';
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }
}
