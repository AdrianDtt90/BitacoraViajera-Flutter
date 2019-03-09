import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandbox_flutter/Components/MiImage.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyImagePicker.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/index.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class MiInputPost extends StatefulWidget {
  MiInputPost({Key key}) : super(key: key);

  @override
  _MiInputPostState createState() => _MiInputPostState();
}

class _MiInputPostState extends State<MiInputPost> {
  TextEditingController _controllerTitulo = new TextEditingController();
  TextEditingController _controllerDescripcion = new TextEditingController();
  TextEditingController _controllerFecha = new TextEditingController();

  List<Map<String, dynamic>> _listaAdjuntos = new List();
  Map<String, dynamic> _mapa = null;

  bool _errorPublicacion = false;
  String _errorMensaje = 'Error al intentar publicar';

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    _controllerFecha.text = formattedDate;
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      _controllerFecha.text = formattedDate;
    }
  }

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
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: Color.fromRGBO(18, 142, 249, 1),
                                ),
                                bottom: BorderSide(
                                  color: Color.fromRGBO(18, 142, 249, 1),
                                ))),
                        child: Text(
                          'Crear Publicación',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color.fromRGBO(18, 142, 249, 1),
                          ),
                        ),
                      ))
                    ]),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                        controller: _controllerTitulo,
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "Ingrese el título...",
                            labelText: "Título"))),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                        controller: _controllerDescripcion,
                        maxLength: 500,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: "Ingrese la descripción...",
                            labelText: "Descripción"))),
                GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextField(
                              controller: _controllerFecha,
                              maxLength: 20,
                              maxLines: null,
                              decoration: InputDecoration(
                                  hintText: "Ingrese la descripción...",
                                  labelText: "Fecha"))),
                    )),
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
              _mapa != null
                  ? Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(248, 248, 248, 1)),
                      child: Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: IconButton(
                              //Map
                              icon: Icon(Icons.place),
                              color: Color.fromRGBO(232, 3, 3, 1),
                              onPressed: () {
                                _navigateAndReturnMap(context);
                              },
                            )),
                        Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(_mapa['text'],
                                    overflow: TextOverflow.ellipsis))),
                        IconButton(
                          //Map
                          icon: Icon(Icons.cancel),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              _mapa = null;
                            });
                          },
                        )
                      ]),
                    )
                  : Container(),
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
                  IconButton(
                    //Camera
                    icon: Icon(Icons.image),
                    color: Color.fromRGBO(66, 103, 178, 1),
                    onPressed: () {
                      _getImageFromGallery();
                    },
                  ),
                  _mapa == null
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2.0),
                          child: IconButton(
                            //Map
                            icon: Icon(Icons.place),
                            color: Color.fromRGBO(232, 3, 3, 1),
                            onPressed: () {
                              _navigateAndReturnMap(context);
                            },
                          ))
                      : Container(),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: FlatButton(
                              color: Color.fromRGBO(19, 137, 253, 1),
                              child: Text(
                                "PUBLICAR",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _publicarPost();
                              },
                            ),
                          ))),
                ]),
              )
            ],
          ),
          _errorPublicacion == true ? _neverSatisfied() : Container()
        ],
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(248, 248, 248, 1),
      ),
    );
  }

  void _publicarPost() {
    var post = {
      "titulo": _controllerTitulo.text,
      "descripcion": _controllerDescripcion.text,
      "fecha": _controllerFecha.text,
      "resultMap": _mapa,
      "adjuntos": _listaAdjuntos,
    };

    bool result = validarPost(post);

    if (result == true) {}
  }

  bool validarPost(dynamic post) {
    //Validamos Titulo
    if (post['titulo'] == '') {
      setState(() {
        _errorPublicacion = true;
        _errorMensaje = 'Debe ingresar un titulo.';
      });
      return false;
    }

    //Validamos Descripción
    if (post['descripcion'] == '') {
      setState(() {
        _errorPublicacion = true;
        _errorMensaje = 'Debe ingresar una descripción.';
      });
      return false;
    }

    //Validamos Fecha
    var fechaSplit = post['fecha'].split("/");
    final selectedDate = DateTime(int.parse(fechaSplit[2]), int.parse(fechaSplit[1]), int.parse(fechaSplit[0]));
    final nowDate = DateTime.now();
    final difference = nowDate.difference(selectedDate).inMilliseconds;

    if (difference < 0) {
      setState(() {
        _errorPublicacion = true;
        _errorMensaje = 'Debe ingresar una fecha igual o menor a la actual.';
      });
      return false;
    }

    setState(() {
      _errorPublicacion = false;
    });

    return true;
  }

  Widget _neverSatisfied() {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          child: Text("${_errorMensaje}"),
        ),
        SimpleDialogOption(
            onPressed: () {
              setState(() {
                _errorPublicacion = false;
              });
            },
            child: Text("CERRAR", style: TextStyle(fontWeight: FontWeight.bold),)),
      ],
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
                child: MiImage(
                    currentUrl: element['src'],
                    fileType: element['fileType'],
                    listImages: _listaAdjuntos), //Internal
              ),
              Container(
                margin: EdgeInsets.all(2),
                width: 24,
                height: 24,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.cancel),
                  color: Color.fromRGBO(232, 3, 3, 1),
                  onPressed: () {
                    _elimiarAdjunto(element);
                  },
                ),
              )
            ],
          ));
        }
      });

      return listaAdjuntos;
    } else {
      return [];
    }
  }

  //Eliminar adjunto
  _elimiarAdjunto(Map<String, dynamic> element) {
    List<Map<String, dynamic>> listaAdjuntos = _listaAdjuntos;
    listaAdjuntos.remove(element);

    setState(() {
      _listaAdjuntos = listaAdjuntos;
    });
  }

  //Agregar Mapa
  _navigateAndReturnMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressMap()),
    );

    if (result == null) {
      //Se rechazó foto
      setState(() {
        _mapa = {"text": null, "lat": null, "lon": null};
      });
    } else {
      //Se encontró Mapa
      setState(() {
        _mapa = {
          "text": result['text'],
          "lat": result['lat'],
          "lon": result['lon']
        };
      });
    }
  }

  //Agregar Imagen desde GALERIA
  _getImageFromGallery() async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (result == null) {
      //Se rechazó foto
      //No hacer nada
    } else {
      //La Recortamos
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: result.path,
          ratioX: 1.0,
          ratioY: 1.0,
          maxWidth: 512,
          maxHeight: 512,
          toolbarTitle: "Editar Imagen",
          toolbarColor: Color.fromRGBO(19, 137, 253, 1));

      if (croppedImage == null) return false;

      //Se tomó foto
      Map<String, dynamic> nuevaImagen = {
        'tipo': 'image',
        'fileType': 1,
        'src': croppedImage.path
      };

      List<Map<String, dynamic>> listaAdjuntos = _listaAdjuntos;
      listaAdjuntos.add(nuevaImagen);

      setState(() {
        _listaAdjuntos = listaAdjuntos;
      });
    }
  }

  //Agregar Imagen desde CAMARA
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
      Map<String, dynamic> nuevaImagen = {
        'tipo': 'image',
        'fileType': 1,
        'src': result.path
      };

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
