String formatStringDate (String date) {
    String fecha = date.split(' ')[0];
    String hora = date.split(' ')[1];
    
    return fecha.split('/')[2]+'-'+fecha.split('/')[1]+'-'+fecha.split('/')[0] + ' ' + hora.split(':')[0] + ':' + hora.split(':')[1] + ':00';
}

DateTime getDateFromString(String date) {
  try {
    return DateTime.parse(formatStringDate(date));
  } catch (e) {
    return DateTime.now();
  }
} 

String getMonthById (int idMonth) {
  switch (idMonth) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Septiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';
    default:
      return '';
  }
}