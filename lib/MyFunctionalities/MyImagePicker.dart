import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    File croppedImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
      toolbarTitle: "Editar Imagen",
      toolbarColor: Color.fromRGBO(19, 137, 253, 1)
    );

    setState(() {
      _image = croppedImage;
    });
  }

  void acceptPhoto() {
    Navigator.pop(context, _image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Image Picker Example'),
        ),
        body: Center(
          child: _image == null
              ? Text('Tomar Foto')
              : Stack(children: <Widget>[
                  Center(
                    child: Text("Cargando..."),
                  ),
                  Center(
                    child: Image.file(_image)
                  )
                ]),
        ),
        floatingActionButton: _image == null
            ? Center(
                widthFactor: 6.8,
                heightFactor: 1.0,
                child: FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Tomar Foto',
                  child: Icon(Icons.add_a_photo),
                ),
              )
            : Center(
                widthFactor: 6.8,
                heightFactor: 1.0,
                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(63, 187, 12, 1),
                  onPressed: acceptPhoto,
                  tooltip: 'Aceptar Foto',
                  child: Icon(Icons.check),
                )));
  }
}
