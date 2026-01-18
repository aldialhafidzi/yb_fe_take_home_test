import 'package:intl/intl.dart';

class FormaterUtils {
  /// Hitung selisih waktu dari publishedAt ke sekarang
  /// dan kembalikan string seperti "4h ago", "12m ago", "2d ago"
  static String timeAgo(String isoTime) {
    try {
      DateTime published = DateTime.parse(isoTime).toLocal();
      final now = DateTime.now();
      final diff = now.difference(published);

      if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';

      // lebih dari 1 minggu, tampilkan tanggal
      return DateFormat('dd MMM yyyy').format(published);
    } catch (e) {
      return '';
    }
  }
}
