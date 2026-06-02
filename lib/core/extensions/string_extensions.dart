extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get truncate100 =>
      length > 100 ? '${substring(0, 100)}...' : this;

  String truncate(int max) =>
      length > max ? '${substring(0, max)}...' : this;

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPassword => length >= 6;

  bool get isNotBlank => trim().isNotEmpty;
}
