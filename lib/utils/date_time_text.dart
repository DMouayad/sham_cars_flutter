import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sham_cars/utils/utils.dart';

class DateTimeText {
  static String relativeOrShort(BuildContext context, DateTime dt) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 2) return l10n.timeNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.timeYesterday;
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);

    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.Md(locale).format(dt);
  }
}
