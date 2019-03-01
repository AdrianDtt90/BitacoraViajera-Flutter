import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String,dynamic>> getAutocompleteAdress(String value) {
  String inputAddress = value;

  inputAddress = inputAddress.replaceAll(new RegExp(r','), '').replaceAll(new RegExp(r' '), '+');

  http.get('http://autocomplete.geocoder.api.here.com/6.2/suggest.json?app_id=gw52EVJ0mr84C1RtrW0K&app_code=MD9QrPmc6HRS1v4YojbgsA&query='+inputAddress+'&beginHighlight=&endHighlight=')
  .then((response) {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Info OK");
        return data;
      } else {
        print("Info FAIL");
        return {};
      }
    });
}