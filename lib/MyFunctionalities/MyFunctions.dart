String formatStringDate (String date) {
    String onlyDate = date.split(' ')[0];
    
    return onlyDate.split('/')[2]+'-'+onlyDate.split('/')[1]+'-'+onlyDate.split('/')[0];
}

DateTime getDateFromString(String date) {
  try {
    return DateTime.parse(formatStringDate(date));
  } catch (e) {
    return DateTime.now();
  }
} 