import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final intl.NumberFormat _formatter = intl.NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // فقط اعداد را نگه می‌دارد
    String newValueText = newValue.text.replaceAll(',', '');
    if (newValueText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // تبدیل به عدد و سپس فرمت‌دهی
    try {
      int value = int.parse(newValueText);
      String formatted = _formatter.format(value);

      // محاسبه موقعیت جدید کرسر
      int cursorPosition = newValue.selection.end;
      int oldCommaCount = ','.allMatches(oldValue.text).length;
      int newCommaCount = ','.allMatches(formatted).length;
      cursorPosition += (newCommaCount - oldCommaCount);

      // بررسی برای اطمینان از اینکه موقعیت کرسر معتبر است
      if (cursorPosition > formatted.length) {
        cursorPosition = formatted.length;
      } else if (cursorPosition < 0) {
        cursorPosition = 0;
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    } catch (e) {
      // اگر تبدیل با خطا مواجه شد، مقدار قبلی را برگرداند
      return oldValue;
    }
  }
}

// تبدیل رشته عددی با جداکننده به عدد صحیح
int parseFormattedNumber(String text) {
  if (text.isEmpty) return 0;
  return int.parse(text.replaceAll(',', '').replaceAll('.', ''));
}

// فرمت‌کننده اعداد با جداکننده هزارتایی
String formatNumber(int number) {
  final formatter = intl.NumberFormat('#,###');
  return formatter.format(number);
}