extension StringEx on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String replaceArabicNumbers() {
    String input = this;
    const mapper = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '٫': '.',
    };
    mapper.forEach((origin, dest) {
      input = input.replaceAll(origin, dest);
    });

    return input;
  }
}
