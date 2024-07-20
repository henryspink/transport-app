import 'package:intl/intl.dart';

final ptvTimeFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
// final ptvTimeFormatNoZ = DateFormat("yyyy-MM-ddTHH:mm:ss");
final displayTimeFormat = DateFormat("HH:mm");
final displayTimeFormats = DateFormat("HH:mm:ss");

/// Try and convert a string to a DateTime object based on the time format the ptv api returns.
/// Assume the given string is utc
/// 
/// Takes in a string that could be null of the time to convert.
/// 
/// Returns a DateTime object of the given time in local time
/// or null if the string is null or the conversion fails.
DateTime? parseTime(String? time) {
  DateTime? parsedTime;
  bool utc = true;
  if (time == null) {
    return null;
  }
  if (!time.contains("Z")) {
    time += "Z";
    utc = false;
  }
  parsedTime = ptvTimeFormat.tryParse(time, utc);
  parsedTime = parsedTime?.toLocal();
  return parsedTime;
}