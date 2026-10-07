import 'package:flutter/services.dart';

String formatMoney(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';

  final formatted = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      formatted.write('.');
    }
    formatted.write(digits[index]);
  }
  return formatted.toString();
}

int? parseMoney(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  return digits.isEmpty ? null : int.tryParse(digits);
}

class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatMoney(newValue.text);
    final selectionOffset = newValue.selection.extentOffset
        .clamp(0, newValue.text.length)
        .toInt();
    final digitsBeforeCursor = newValue.text
        .substring(0, selectionOffset)
        .replaceAll(RegExp(r'\D'), '')
        .length;

    var cursorOffset = 0;
    var digitsSeen = 0;
    while (cursorOffset < formatted.length &&
        digitsSeen < digitsBeforeCursor) {
      if (formatted.codeUnitAt(cursorOffset) != 0x2E) {
        digitsSeen++;
      }
      cursorOffset++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}
