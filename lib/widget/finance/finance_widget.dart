// ساخت فیلد ورودی با فرمت‌دهی اعداد
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../util/numberFormat/number_format.dart';

Widget buildInputField(String label, TextEditingController controller) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 1),
    ),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.roboto(color: Colors.white),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsSeparatorInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.greenAccent),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    ),
  );
}

// تعیین رنگ متناسب با وضعیت مالی
Color getStatusColor(String status) {
  switch (status) {
    case 'عالی':
      return Colors.greenAccent;
    case 'خوب':
      return Colors.green;
    case 'متوسط':
      return Colors.yellow;
    case 'ضعیف':
      return Colors.orange;
    case 'بحرانی':
      return Colors.red;
    default:
      return Colors.white;
  }
}

