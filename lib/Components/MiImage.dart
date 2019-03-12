import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MiImage extends StatefulWidget {
  final String currentUrl;
  final String linkTexto;
  final int fileType;
  //fileType; // 0: External, 1:Internal, 2:Assets

  List<Map<String, dynamic>> listImages;

  MiImage({Key key, this.currentUrl, this.linkTexto, this.fileType: 0, this.listImages})
      : super(key: key);

  @override
  _MiImageState createState() => _MiImageState();
}

class _MiImageState extends State<MiImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageViewer(
                    currentUrl: widget.currentUrl,
                    fileType: widget.fileType,
                    listImages: widget.listImages)),
          );
        },
        child: widget.linkTexto != null ? Text("${widget.linkTexto}", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(18, 142, 249, 1))) : getImageWidget(widget.currentUrl, widget.fileType));
  }

  Widget getImageWidget(String url, int fileType) {
    switch (fileType) {
      case 0:
        return Image.network(url);
      case 1:
        return Image.file(File(url));
      case 2:
        return Image.asset(url);
      default:
    }
  }
}

class ImageViewer extends StatelessWidget {
  final String currentUrl;
  final int fileType;

  List<Map<String, dynamic>> listImages;

  ImageViewer({Key key, this.currentUrl, this.fileType: 0, this.listImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentUrl == null) return Container();

    dynamic src = PhotoView(
      imageProvider: getImageWidget(currentUrl, fileType),
    );
    if (listImages == null || (listImages != null && listImages.length > 1)) {
      src = getImagesViewer(listImages);
    }

    return Container(color: Colors.black, child: src);
  }

  dynamic getImageWidget(String url, int fileType) {
    switch (fileType) {
      case 0:
        return NetworkImage(url);
      case 1:
        return FileImage(File(url));
      case 2:
        return AssetImage(url);
      default:
    }
  }

  dynamic getImagesViewer(List<Map<String, dynamic>> list) {
    if (list == null) return Container();

    List<PhotoViewGalleryPageOptions> listSrc = new List();
    int count = 1;

    list.forEach((image) {
      if(image['src'] == null) return false;

      listSrc.add(PhotoViewGalleryPageOptions(
        imageProvider: getImageWidget(image['src'], image['fileType']),
        heroTag: "Image " + count.toString(),
      ));

      count = count + 1;
    });

    if (listSrc.length == 0) return Container();

    return Container(
        child: PhotoViewGallery(
      pageOptions: listSrc,
      backgroundDecoration: BoxDecoration(color: Colors.black87),
    ));
  }
}
