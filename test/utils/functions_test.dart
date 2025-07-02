import 'package:PongChamp/domain/functions/utility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('formatDateTimeManually', () {
    test('Formatta correttamente la data e ora', () {
      final dateTime = DateTime(2024, 12, 5, 9, 7);
      final result = formatDateTimeManually(dateTime);
      expect(result, '05/12/2024\n09:07');
    });
  });

  group('formatTimestamp', () {
    test('Ritorna "N/A" se il timestamp è null', () {
      expect(formatTimestamp(null), 'N/A');
    });

    test('Ritorna "Adesso" se timestamp è pochi secondi fa', () {
      final now = DateTime.now();
      final ts = Timestamp.fromDate(now.subtract(Duration(seconds: 10)));
      expect(formatTimestamp(ts), 'Adesso');
    });

    test('Ritorna minuti fa se < 60 minuti', () {
      final ts = Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 15)));
      expect(formatTimestamp(ts), contains('15 min fa'));
    });

    test('Ritorna ore fa se < 24 ore', () {
      final ts = Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 3)));
      expect(formatTimestamp(ts), contains('3 h fa'));
    });

    test('Ritorna data formattata se > 24 ore', () {
      final ts = Timestamp.fromDate(DateTime(2023, 4, 3, 14, 45));
      final result = formatTimestamp(ts);
      expect(result, contains('03/04/2023'));
      expect(result, contains('14:45'));
    });
  });
}
