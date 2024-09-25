import 'package:timeago/timeago.dart' as timeago;

class MyCustomMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String suffixFromNow() => 'from now';
  @override
  String lessThanOneMinute(int seconds) => '$seconds sec';
  @override
  String aboutAMinute(int minutes) => '1 min';
  @override
  String minutes(int minutes) => '$minutes mins';
  @override
  String aboutAnHour(int minutes) => '1 hr';
  @override
  String hours(int hours) => '$hours hrs';
  @override
  String aDay(int hours) => '1 d';
  @override
  String days(int days) => '$days d';
  @override
  String aboutAMonth(int days) => '1 mo';
  @override
  String months(int months) => '$months mo';
  @override
  String aboutAYear(int year) => '1 yr';
  @override
  String years(int years) => '$years yrs';
  @override
  String wordSeparator() => ' ';
}
