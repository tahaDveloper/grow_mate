// بخش خلاصه وضعیت مالی
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/transaction/financeAi/modelAi.dart';



// کارت اطلاعات مالی
Widget buildFinancialInfoCard(
    String title, String value, String unit, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.vazirmatn(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: GoogleFonts.vazirmatn(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}





// ساخت حباب گفتگو
Widget buildChatBubble(ChatMessage message) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment:
      message.isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isUserMessage)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.blue,
              size: 16,
            ),
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUserMessage
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.text,
              style: GoogleFonts.vazirmatn(
                color: Colors.white,
                fontSize: 14,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        if (message.isUserMessage)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.blue,
              size: 16,
            ),
          ),
      ],
    ),
  );
}

// تعیین رنگ وضعیت مالی
Color getStatusColor(String status) {
  switch (status) {
    case 'عالی':
      return Colors.green;
    case 'خوب':
      return Colors.teal;
    case 'متوسط':
      return Colors.amber;
    case 'ضعیف':
      return Colors.orange;
    case 'بحرانی':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// تعیین رنگ پیشرفت پس‌انداز
Color getSavingsProgressColor(double progress) {
  if (progress < 0.3) {
    return Colors.red;
  } else if (progress < 0.7) {
    return Colors.amber;
  } else {
    return Colors.green;
  }
}