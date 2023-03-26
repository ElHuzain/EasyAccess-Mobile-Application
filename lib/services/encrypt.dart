String encrypt(String key) {
  DateTime d = new DateTime.now();
  String month = getMonth(d.month);
  String day = getMonth(d.day);
  String year = d.year.toString();
  int minute = d.minute;

  // int date = int.parse("$month$day$year");
  int date = d.minute;
  int secret = int.parse(key);
  // Encryption
  int result = date * secret;
  // result = result + secret;
  // result = result - date;
  return "$result";
}

String getMonth(int month) {
  if (month > 9)
    return "$month";
  else
    return "0$month";
}
