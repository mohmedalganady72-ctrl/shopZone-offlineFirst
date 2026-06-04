import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final String? cacheDate;

  const OfflineBanner({super.key, this.cacheDate});

  @override
  Widget build(BuildContext context) {
    String dateText = '';
    if (cacheDate != null) {
      try {
        final dt = DateTime.parse(cacheDate!);
        dateText =
            ' • Cached ${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFFFFF3CD),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 16, color: Color(0xFF856404)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline mode — showing cached data$dateText',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF856404),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
