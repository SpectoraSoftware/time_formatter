/*    
  Time formatting library for Dart programs.
  Copyright (C) 2019  Jeremi Gendron <gendronjeremi@gmail.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program; if not, write to the Free Software Foundation, Inc.,
  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

/// Formats a given UNIX millisecond timestamp into a human-readable string.
///
/// Progresses from smallest unit (second), to largest (years)
String formatTime(int timestamp, {bool abbreviateUnit = false}) {
  /// The number of milliseconds that have passed since the timestamp
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference, abbreviateUnit);
  } else if (difference < 3600000) {
    result = countMinutes(difference, abbreviateUnit);
  } else if (difference < 86400000) {
    result = countHours(difference, abbreviateUnit);
  } else if (difference < 604800000) {
    result = countDays(difference, abbreviateUnit);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference, abbreviateUnit);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference, abbreviateUnit);
  } else
    result = countYears(difference, abbreviateUnit);

  return !result.startsWith("J") ? result + ' ago' : result; 
}

/// Converts the time difference to a number of seconds.
/// This function truncates to the lowest second.
///   returns ("Just now" OR "X seconds")
String countSeconds(int difference, bool abbreviateUnit) {
  final unit = abbreviateUnit ? 'sec' : 'seconds';
  final count = (difference / 1000).truncate();

  return count > 1 ? count.toString() + ' $unit' : 'Just now';
}

/// Converts the time difference to a number of minutes.
/// This function truncates to the lowest minute.
///   returns ("1 minute" OR "X minutes")
String countMinutes(int difference, bool abbreviateUnit) {
  final count = (difference / 60000).truncate();
  final unit = abbreviateUnit ? 'min' : 'minute';
  final text = _getText(count, unit);

  return count.toString() + text;
}

/// Converts the time difference to a number of hours.
/// This function truncates to the lowest hour.
///   returns ("1 hour" OR "X hours")
String countHours(int difference, bool abbreviateUnit) {
  final count = (difference / 3600000).truncate();
  final unit = abbreviateUnit ? 'hr' : 'hour';
  final text = _getText(count, unit);

  return count.toString() + text;
}

/// Converts the time difference to a number of days.
/// This function truncates to the lowest day.
///   returns ("1 day" OR "X days")
String countDays(int difference, bool abbreviateUnit) {
  final count = (difference / 86400000).truncate();
  final text = _getText(count, 'day');

  return count.toString() + text;
}

/// Converts the time difference to a number of weeks.
/// This function truncates to the lowest week.
///   returns ("1 week" OR "X weeks" OR "1 month")
String countWeeks(int difference, bool abbreviateUnit) {
  final count = (difference / 604800000).truncate();

  if (count > 3) {
    final unit = abbreviateUnit ? 'mth' : 'month';
    return '1 $unit';
  }
  
  final unit = abbreviateUnit ? 'wk' : 'week';
  final text = _getText(count, unit);
  return count.toString() + text;
}

/// Converts the time difference to a number of months.
/// This function rounds to the nearest month.
///   returns ("1 month" OR "X months" OR "1 year")
String countMonths(int difference, bool abbreviateUnit) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;

  if (count > 12) {
    final unit = abbreviateUnit ? 'yr' : 'year';
    return '1 $unit';
  }

  final unit = abbreviateUnit ? 'mth' : 'month';
  final text = _getText(count, unit);
  return count.toString() + text;
}

/// Converts the time difference to a number of years.
/// This function truncates to the lowest year.
///   returns ("1 year" OR "X years")
String countYears(int difference, bool abbreviateUnit) {
  final count = (difference / 31536000000).truncate();
  final unit = abbreviateUnit ? 'yr' : 'year';
  final text = _getText(count, unit);

  return count.toString() + text;
}

String _getText(int count, String unit) {
  return count > 1 ? ' ${unit}s' : ' $unit';
}