extension StringHelper on String {
  int? get toInt => int.tryParse(this);
}
