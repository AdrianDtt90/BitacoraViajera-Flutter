import 'package:flutter/material.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyImagePicker.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker.dart';

class MiInputPost extends StatefulWidget {
  MiInputPost({Key key}) : super(key: key);

  @override
  _MiInputPostState createState() => _MiInputPostState();
}

class _MiInputPostState extends State<MiInputPost> {
  List<Map<String, dynamic>> _listaAdjuntos = new List();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Crear Publicación',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))
                    ]),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "Ingrese el título...",
                            labelText: "Título"))),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                        maxLength: 500,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: "Ingrese la descripción...",
                            labelText: "Descripción"))),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      direction: Axis.horizontal, // main axis (rows or columns)
                      children: getListaAdjuntos(),
                    ))
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text("Agregar: ")),
                  IconButton(
                    //Camera
                    icon: Icon(Icons.camera_alt),
                    color: Color.fromRGBO(63, 187, 12, 1),
                    onPressed: () {
                      _navigateAndReturnImage(context);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: IconButton(
                        //Map
                        icon: Icon(Icons.place),
                        color: Color.fromRGBO(232, 3, 3, 1),
                        onPressed: () {
                          _navigateAndReturnMap(context);
                        },
                      ))
                ]),
              )
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(248, 248, 248, 1),
      ),
    );
  }

  //Listar Adjuntos
  List<Widget> getListaAdjuntos() {
    if (_listaAdjuntos != null) {
      List<Widget> listaAdjuntos = new List();

      _listaAdjuntos.forEach((element) {
        //Camara
        if (element['tipo'] == 'image') {
          listaAdjuntos.add(Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                child: Image.file(element['src']),
              ),
              IconButton(
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.topLeft,
                icon: Icon(Icons.cancel),
                color: Color.fromRGBO(232, 3, 3, 1),
                onPressed: () {
                  _elimiarAdjunto(element);
                },
              )
            ],
          ));
        }

        //Mapa
        if (element['tipo'] == 'map') {
          listaAdjuntos.add(Text('Se esta programando'));
        }
      });

      return listaAdjuntos;
    } else {
      return [];
    }
  }

  //Eliminar adjunto
  _elimiarAdjunto (Map<String, dynamic> element) {
    List<Map<String, dynamic>> listaAdjuntos = _listaAdjuntos;
    listaAdjuntos.remove(element);

    setState(() {
      _listaAdjuntos = listaAdjuntos;
    });
  }

  //Agregar Imagen
  _navigateAndReturnMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressMap()),
    );
  }

  //Agregar Imagen
  _navigateAndReturnImage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageCamera()),
    );

    if (result == null) {
      //Se rechazó foto
      //No hacer nada
    } else {
      //Se tomó foto
      Map<String, dynamic> nuevaImagen = {'tipo': 'image', 'src': result};

      List<Map<String, dynamic>> listaAdjuntos = _listaAdjuntos;
      listaAdjuntos.add(nuevaImagen);

      setState(() {
        _listaAdjuntos = listaAdjuntos;
      });
    }
  }
}

class ImageCamera extends StatefulWidget {
  ImageCamera({Key key}) : super(key: key);

  @override
  _ImageCameraState createState() => _ImageCameraState();
}

class _ImageCameraState extends State<ImageCamera> {
  @override
  Widget build(BuildContext context) {
    return MyImagePicker();
  }
}


class AddressMap extends StatefulWidget {
  AddressMap({Key key}) : super(key: key);

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  @override
  Widget build(BuildContext context) {
    return MyMapPicker();
  }
}