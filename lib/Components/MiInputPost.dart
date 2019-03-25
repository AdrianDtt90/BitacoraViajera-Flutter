import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandbox_flutter/Components/MiImage.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyFunctions.dart';

import 'package:sandbox_flutter/MyFunctionalities/MyImagePicker.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyMapPicker/index.dart';
import 'package:sandbox_flutter/MyFunctionalities/MiUpdateImage/index.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:sandbox_flutter/Entities/Posts.dart';
import 'package:sandbox_flutter/MyFunctionalities/MyNotifications.dart';
import 'package:sandbox_flutter/Redux/index.dart';

import 'package:location/location.dart' as LocationManager;
import 'package:latlong/latlong.dart';

class MiInputPost extends StatefulWidget {
  MiInputPost({Key key}) : super(key: key);

  @override
  _MiInputPostState createState() => _MiInputPostState();
}

class _MiInputPostState extends State<MiInputPost> {
  TextEditingController _controllerTitulo = new TextEditingController();
  TextEditingController _controllerDescripcion = new TextEditingController();
  TextEditingController _controllerFecha = new TextEditingController();
  TextEditingController _controllerHora = new TextEditingController();

  TextEditingController _controllerMyLocation = new TextEditingController();

  List<Map<String, dynamic>> _listaAdjuntos = new List();
  Map<String, dynamic> _mapa = null;

  dynamic _mensajeUploadPost = 'Cargando...';

  bool _uploadPost = false;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    _controllerFecha.text = formattedDate;

    TimeOfDay hora = TimeOfDay.now();
    _controllerHora.text = hora.hour.toString() + ":" + hora.minute.toString();
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

  void _selectHour(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      _controllerHora.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nueva Publicación'),
        ),
        body: Container(
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
                                      color: Color.fromRGBO(67, 170, 139, 1),
                                    ),
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(67, 170, 139, 1),
                                    ))),
                            child: Text(
                              'Crear Publicación',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Color.fromRGBO(67, 170, 139, 1),
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
                                      hintText: "Ingrese la fecha...",
                                      labelText: "Fecha"))),
                        )),
                    GestureDetector(
                        onTap: () => _selectHour(context),
                        child: AbsorbPointer(
                          child: Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextField(
                                  controller: _controllerHora,
                                  maxLength: 20,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      hintText: "Ingrese la hora...",
                                      labelText: "Hora"))),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          direction:
                              Axis.horizontal, // main axis (rows or columns)
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
                          ? IconButton(
                              //Camera
                              icon: Icon(Icons.gps_fixed),
                              color: Color.fromRGBO(3, 169, 244, 1),
                              onPressed: () {
                                _getMyCurrentLocation();
                              },
                            )
                          : Container(),
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
                                  color: Color.fromRGBO(67, 170, 139, 1),
                                  child: Text(
                                    "PUBLICAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _publicarPost(context);
                                  },
                                ),
                              ))),
                    ]),
                  )
                ],
              ),
              _uploadPost == true
                  ? Container(
                      child: SimpleDialog(
                        title: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              SizedBox(
                                child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(67, 170, 139, 1)),),
                                height: 50.0,
                                width: 50.0,
                              )
                            ])),
                        children: <Widget>[
                          Text('${_mensajeUploadPost}',
                              textAlign: TextAlign.center)
                        ],
                      ),
                      decoration: new BoxDecoration(
                        color: const Color.fromRGBO(67, 170, 139, 0.8),
                      ),
                    )
                  : Container()
            ],
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(248, 248, 248, 1),
          ),
        ));
  }

  void _publicarPost(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    Random rnd = new Random();
    List<String> listaAdjuntos = new List();

    var postData = {
      "idPost": "idPost_${rnd.nextInt(100000000)}",
      "titulo": _controllerTitulo.text,
      "descripcion": _controllerDescripcion.text,
      "timestamp":
          getDateFromString("${_controllerFecha.text} ${_controllerHora.text}").millisecondsSinceEpoch,
      "fecha": "${_controllerFecha.text} ${_controllerHora.text}",
      "uidUser": store.state['loggedUser']['uid'],
      "nombreMapa": _mapa != null ? _mapa['text'] : null,
      "latitud": _mapa != null ? _mapa['lat'] : null,
      "longitud": _mapa != null ? _mapa['lon'] : null,
      "adjuntosInt": _listaAdjuntos,
      "adjuntos": listaAdjuntos
    };

    bool result = validarPost(postData);

    if (result == true) {
      //Vemos si hay adjuntos
      if (_listaAdjuntos.length > 0) {
        //Subimos Imagenes para obtener URLs
        List<String> listaLinkImg = new List();
        _listaAdjuntos.forEach((element) {
          //Camara
          if (element['tipo'] == 'image') {
            listaLinkImg.add(element['src']);
          }
        });
        subirMuchas(listaLinkImg, (idImagen, progressImage) {
          setState(() {
            _mensajeUploadPost =
                'Subiendo Imagen N° ${idImagen + 1} - ${progressImage}%';
            _uploadPost = true;
          });
        }).then((urlsImages) {
          postData['adjuntos'] = urlsImages; //List<String>

          updatePost(postData);
        }).catchError((e) {
          _showError('Ocurrió un problema al intentar subir las fotos.');
          setState(() {
            _uploadPost = false;
          });
        });
      } else {
        updatePost(postData);
      }
    }
  }

  void updatePost(dynamic postData) {
    setState(() {
      _mensajeUploadPost = 'Posteando...';
      _uploadPost = true;
    });

    //Publicamos
    Posts.create(postData).then((post) {

      NotificationSender.fetchNotification('Nuevo: ' + post.titulo, post.descripcion).then((result) {
        setState(() {
          _uploadPost = false;
        });

        Navigator.pop(context, true);
      });

    }).catchError((e) {
      _showError('Ocurrió un problema al intentar publicar.');
      setState(() {
        _uploadPost = false;
      });
    });
  }

  bool validarPost(dynamic post) {
    //Validamos Titulo
    if (post['titulo'] == '') {
      _showError('Debe ingresar un titulo.');
      return false;
    }

    //Validamos Descripción
    if (post['descripcion'] == '') {
      _showError('Debe ingresar una descripción.');
      return false;
    }

    //Validamos Fecha
    var fechaSplit = post['fecha'].split(" ")[0].split("/");
    final selectedDate = DateTime(int.parse(fechaSplit[2]),
        int.parse(fechaSplit[1]), int.parse(fechaSplit[0]));
    final nowDate = DateTime.now();
    final difference = nowDate.difference(selectedDate).inMilliseconds;

    if (difference < 0) {
      _showError('Debe ingresar una fecha igual o menor a la actual.');
      return false;
    }

    return true;
  }

  void _showError(String _errorMensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("${_errorMensaje}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Listar Adjuntos
  List<Widget> getListaAdjuntos() {
    if (_listaAdjuntos.length > 0) {
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
        _mapa = null;
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

  //My Current Location
  _getMyCurrentLocation() async {
    bool result = await _showDialogMyLocation();

    if (result) {
      String ubicacion = _controllerMyLocation.text;
      _controllerMyLocation.text = '';

      LatLng mylocation = await _getUserLocation();

      if (result == null || mylocation == null) {
        //Se rechazó foto
        setState(() {
          _mapa = null;
        });
      } else {
        //Se encontró Mapa
        setState(() {
          _mapa = {
            "text": ubicacion,
            "lat": mylocation.latitude,
            "lon": mylocation.longitude
          };
        });
      }
    } else {
      _showError('Ocurró un error al intenar ingresar la ubicación');
      _controllerMyLocation.text = '';
    }
  }

  Future<bool> _showDialogMyLocation() async {
    // flutter defined function
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Agregando mi ubicación"),
          content: new TextField(
              controller: _controllerMyLocation,
              maxLength: 25,
              decoration: InputDecoration(
                  hintText: "Ingrese la ubicación...", labelText: "Ubicación")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result;
  }

  Future<LatLng> _getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      _showGPSDialog();
      
      currentLocation = null;
      return null;
    }
  }

  Future<bool> _showGPSDialog() async {
    // flutter defined function
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Agregando mi ubicación"),
          content: Text("¡Debe encender el GPS!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          toolbarColor: Color.fromRGBO(67, 170, 139, 1));

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
