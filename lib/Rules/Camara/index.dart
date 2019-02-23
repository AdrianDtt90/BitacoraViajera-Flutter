import 'dart:async';
import 'dart:convert';

//import 'package:image_picker/image_picker.dart';
import 'package:multipart_request/multipart_request.dart';

Future<dynamic> getImage() async {
  //var image = await ImagePicker.pickImage(source: ImageSource.camera);
  return 'image';
}

Future<List<String>> subirMuchas(
    List<String> paths, Function onProgress) async {
  List<String> resultado = [];

  int i = 0;
  for (var path in paths) {
    try {
      String link = await subir(path, (progress) {
        if (onProgress != null) {
          onProgress(i, progress);
        }
      });

      resultado.add(link);
    } catch (ex) {
      return Future.error(ex);
    }

    i++;
  }

  return Future.value(resultado);
}

Future<String> subir(String path, Function onProgress) {
  Completer<String> completer = new Completer<String>();

  try {
    String url = "https://api.imgur.com/3/image";

    var request = MultipartRequest();
    request.setUrl(url);
    request.addHeader("Authorization", "Client-ID dbbab19ece686c0");
    request.addFile("image", path);
    Response response = request.send();

    response.onError = () {
      completer.completeError('Error procesando la solicitud');
    };

    response.onComplete = (response) {
      Map<String, dynamic> resultado = jsonDecode(response);
      if (resultado['success'] != true)
        Future.error('Error procesando la solicitud');

      Map<String, dynamic> data = resultado['data'];
      String link = data['link'];
      completer.complete(link);
    };

    response.progress.listen((int progress) {
      if (onProgress != null) {
        onProgress(progress);
      }
    });

    // Library HTTP
    // String url = "https://api.imgur.com/3/image";

    // var uri = Uri.parse(url);
    // var request = new http.MultipartRequest("POST", uri);

    // request.headers.addAll({"Authorization": "Client-ID dbbab19ece686c0" });
    // request.files.add(new http.MultipartFile.fromString('image', path);
    // request.send()
    // .then((response) {
    //   Map<String, dynamic> resultado = jsonDecode(response);
    //   if (resultado['success'] != true) Future.error('Error procesando la solicitud');

    //   Map<String, dynamic> data = resultado['data'];
    //   String link = data['link'];
    //   completer.complete(link);
    // })
    // .catchError((onError) {
    //   completer.completeError('Error procesando la solicitud');
    // });
  } catch (ex) {
    completer.completeError(ex.toString());
  }

  return completer.future;
}
